// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:idream/common/references.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class AppLifecycleObserver extends StatefulWidget {
  final Widget child;

  const AppLifecycleObserver({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<AppLifecycleObserver>
    with WidgetsBindingObserver {
  static final _log = Logger('AppLifecycleObserver');

  final ValueNotifier<AppLifecycleState> lifecycleListenable =
      ValueNotifier(AppLifecycleState.inactive);

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<ValueNotifier<AppLifecycleState>>.value(
      value: lifecycleListenable,
      child: widget.child,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _log.info(() => 'didChangeAppLifecycleState: $state');
    lifecycleListenable.value = state;
    debugPrint(state.name.toString());
    switch (state) {
      case AppLifecycleState.detached:
        userLoginRepository.userLastLogin();
        break;
      case AppLifecycleState.inactive:
        userLoginRepository.userLastLogin();
        break;
      case AppLifecycleState.paused:
        userLoginRepository.userLastLogin();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    debugPrint("Last login saved ");
    userLoginRepository.userLastLogin();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _log.info('Subscribed to app lifecycle updates');
  }
}
