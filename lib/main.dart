import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_app/src/routing/go_router/go_router_delegate.dart';
import 'package:hr_app/src/utils/fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Handling a background message: ${message.messageId}");
}

/// A single, top-level ProviderContainer (matches your original pattern)
final ProviderContainer container = ProviderContainer();

/// App readiness flag so we can render instantly and initialize in parallel
final appReadyProvider = StateProvider<bool>((_) => false);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerErrorHandlers();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const _BootstrapGate(),
    ),
  );
}

/// Bootstrap gate: shows a minimal splash while we init Firebase, storage, locales, etc.
class _BootstrapGate extends ConsumerStatefulWidget {
  const _BootstrapGate({super.key});

  @override
  ConsumerState<_BootstrapGate> createState() => _BootstrapGateState();
}

class _BootstrapGateState extends ConsumerState<_BootstrapGate> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
      await Future.wait([
        initializeDateFormatting('en_US'),
        GetStorage.init(),
        EasyLocalization.ensureInitialized(),
      ]);
    } catch (e, st) {
      debugPrint('Bootstrap error: $e\n$st');
    } finally {
      if (mounted) {
        ref.read(appReadyProvider.notifier).state = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ready = ref.watch(appReadyProvider);

    if (!ready) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _SplashScaffold(),
      );
    }
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('th')],
      path: 'assets/l10n',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    );
  }
}

/// Your real app (unchanged except for being mounted after bootstrap)
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterDelegateProvider);

    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: kJaldi),
    );
  }
}

/// Lightweight splash shown during bootstrap
class _SplashScaffold extends StatelessWidget {
  const _SplashScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

/// ------------------------------
/// Error handling
/// ------------------------------
void registerErrorHandlers() {
  /// Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };

  /// Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint(error.toString());
    return true;
  };

  /// Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('An error occurred'),
        ),
        body: Center(child: Text(details.toString())),
      ),
    );
  };
}

/// Page transition builder (unchanged)
class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);

    return SlideTransition(position: offsetAnimation, child: child);
  }
}
