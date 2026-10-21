import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'network_event.dart';
import 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState>
    with WidgetsBindingObserver {
  NetworkBloc() : super(ConnectionInitial()) {
    on<ListenConnection>((event, emit) {
      WidgetsBinding.instance.addObserver(this);
      _startListening();
    });
    on<ConnectionChanged>((event, emit) {
     emit(event.connection);
    });
  }
// atul asl connection change
  final InternetConnectionChecker _checker = InternetConnectionChecker();
  StreamSubscription<InternetConnectionStatus>? _subscription;
  Timer? _confirmOfflineTimer;
  bool _inForeground = true;

  // A single failed check is common right after the app comes back from the
  // background (the OS is still reconnecting the app to the network). Only
  // show "No Internet" if a second check after this delay also fails.
  static const Duration _confirmOfflineDelay = Duration(seconds: 3);

  void _startListening() {
    _subscription?.cancel();
    _subscription = _checker.onStatusChange.listen(_onStatusChange);
  }

  void _stopListening() {
    _confirmOfflineTimer?.cancel();
    _subscription?.cancel();
    _subscription = null;
  }

  void _onStatusChange(InternetConnectionStatus status) {
    _log('status: ${status.name}');
    if (status == InternetConnectionStatus.connected) {
      _confirmOfflineTimer?.cancel();
      add(ConnectionChanged(ConnectionSuccess()));
      return;
    }
    _confirmOfflineTimer?.cancel();
    _confirmOfflineTimer = Timer(_confirmOfflineDelay, () async {
      final bool online = await _checker.hasConnection;
      _log('re-check after ${_confirmOfflineDelay.inSeconds}s: '
          '${online ? 'online, ignoring blip' : 'offline, showing No Internet'}');
      if (!online && _inForeground && !isClosed) {
        add(ConnectionChanged(ConnectionFailure()));
      }
    });
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[Network] $message');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _log('app ${state.name}');
    if (state == AppLifecycleState.paused) {
      // Checks made while the app is in the background fail because the OS
      // suspends its network access, so stop checking until it comes back.
      _inForeground = false;
      _stopListening();
    } else if (state == AppLifecycleState.resumed) {
      // Keep showing the current screen; re-listening runs a fresh check
      // right away and only a confirmed failure shows "No Internet".
      _inForeground = true;
      _startListening();
    }
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    _stopListening();
    return super.close();
  }
}
