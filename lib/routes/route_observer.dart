import 'package:flutter/material.dart';

/// Registered in MaterialApp.navigatorObservers so screens can tell when a
/// page pushed on top of them has been popped.
final RouteObserver<PageRoute<dynamic>> routeObserver =
    RouteObserver<PageRoute<dynamic>>();

/// Calls [onReturn] every time the user comes back to this screen from a page
/// pushed on top of it (back button / Navigator.pop). Dialogs and bottom
/// sheets are not pages, so closing them does not trigger a refresh.
mixin RefreshOnReturn<T extends StatefulWidget> on State<T>
    implements RouteAware {
  void onReturn();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() => onReturn();

  @override
  void didPush() {}

  @override
  void didPop() {}

  @override
  void didPushNext() {}
}
