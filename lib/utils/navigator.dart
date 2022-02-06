import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'logger.dart';

final navigator = WorddleNav();

class WorddleNav {
  /// Navigator state key
  final key = GlobalKey<NavigatorState>();

  /// Navigator's current state
  NavigatorState? get state => key.currentState;

  /// Navigator's current context
  BuildContext get context => state!.context;

  /// Smooth navigation from Splash
  Future navigateFromSplash(
    Widget route, {
    bool isDialog = false,
  }) {
    popView();
    logger.i('Nav: Current Route -> ${(route.runtimeType)}');
    return state!.push(PageTransition(
      alignment: Alignment.center,
      type: PageTransitionType.fade,
      duration: const Duration(milliseconds: 1000),
      child: route,
    ));
  }

  /// Push a named route
  void pushTop(String routeName) {
    logger.i('Nav: Current Route -> ${(routeName)}');

    state!.pushNamed(routeName);
  }

  /// Push a replacement route
  void replaceTop(
    Widget page, {
    bool isDialog = false,
    bool isTransparent = false,
  }) {
    final route =
        isTransparent ? _transparentRoute(page) : _materialRoute(page);
    state!.pushReplacement(route);
  }

  /// Push a  route and replace the root route
  void replaceRoot(
    Widget root, {
    bool isDialog = false,
    bool isTransparent = false,
  }) {
    final route =
        isTransparent ? _transparentRoute(root) : _materialRoute(root);
    state!.pushAndRemoveUntil(route, (route) => false);
  }

  /// Push a  route
  Future<T?> pushTo<T>(
    Widget? page, {
    bool isDialog = false,
    bool isTransparent = false,
  }) {
    final route = isTransparent
        ? _transparentRoute<T>(page)
        : _materialRoute<T>(
            page,
          );
    return state!.push(route);
  }

  /// Pop to initial route
  void popToFirst() => state!.popUntil((route) => route.isFirst);

  /// Pop/remove current route
  void popView<T>([T? result]) => state!.pop<T>(result);

  /// If ui can pop/remove current route
  bool get canPop => state!.canPop();

  /// Custom material route
  PageTransition<T> _materialRoute<T>(
    Widget? widget,
  ) {
    logger.i('Nav: Current Route -> ${(widget.runtimeType)}');

    return PageTransition<T>(
      alignment: Alignment.center,
      type: PageTransitionType.fade,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 400),
      childCurrent: widget,
      child: widget!,
    );
  }
}

/// Custom Transaprent route
TransparentRoute<T> _transparentRoute<T>(Widget? widget) {
  logger.i('Nav: Current Route -> ${(widget.runtimeType)}');

  return TransparentRoute<T>(
    builder: (context) => widget!,
  );
}

extension MyNavigator on BuildContext {
  void navigateFromSplash(
    Widget route, {
    bool isDialog = false,
  }) =>
      navigator.navigateFromSplash(
        route,
        isDialog: isDialog,
      );

  void navigateReplace(
    Widget route, {
    bool isDialog = false,
    bool isTransparent = false,
  }) =>
      navigator.replaceTop(
        route,
        isDialog: isDialog,
        isTransparent: isTransparent,
      );

  void navigate(
    Widget route, {
    bool isDialog = false,
    bool isTransparent = false,
  }) =>
      navigator.pushTo(
        route,
        isDialog: isDialog,
        isTransparent: isTransparent,
      );

  void popToFirst() => navigator.popToFirst();

  void popView() => navigator.popView();

  bool get canPop => navigator.canPop;
}

class FadeInRoute<T> extends MaterialPageRoute<T> {
  FadeInRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/') return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return FadeTransition(opacity: animation, child: child);
  }
}

class TransparentRoute<T> extends PageRoute<T> {
  TransparentRoute({
    required this.builder,
    RouteSettings? settings,
  }) : super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: SlideTransition(
          transformHitTests: false,
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0.0, -1.0),
            ).animate(secondaryAnimation),
            child: result,
          ),
        ),
      ),
    );
  }
}
