library flutter_breakpoints;

import 'dart:developer';

import 'package:flutter/material.dart';

class FlutterBreakpoint {
  final double minWidth;
  final String name;

  const FlutterBreakpoint({
    required this.name,
    required this.minWidth,
  });
  bool isBreakpoint(BuildContext context) {
    final provider = FlutterBreakpointProvider.of(context);
    return provider.breakpoint == this;
  }
}

class Breakpoints {
  Breakpoints._();
  static FlutterBreakpoint mobile = const FlutterBreakpoint(name: 'mobile', minWidth: 0);
  static FlutterBreakpoint tablet = const FlutterBreakpoint(name: 'tablet', minWidth: 600);
  static FlutterBreakpoint desktop = const FlutterBreakpoint(name: 'desktop', minWidth: 1024);
  static FlutterBreakpoint largeDesktop = const FlutterBreakpoint(name: 'largeDesktop', minWidth: 1440);
  static List<FlutterBreakpoint> get _breakpoints => [mobile, tablet, desktop, largeDesktop];
}

class FlutterBreakpointProvider extends InheritedWidget {
  final List<FlutterBreakpoint> breakpoints;
  final FlutterBreakpoint breakpoint;
  final Size? size;

  const FlutterBreakpointProvider._({
    required super.child,
    required this.breakpoints,
    required this.breakpoint,
    this.size,
  });

  @override
  bool updateShouldNotify(FlutterBreakpointProvider oldWidget) => breakpoint != oldWidget.breakpoint || size != oldWidget.size;

  static Widget builder({
    required BuildContext context,
    Widget? child,
    List<FlutterBreakpoint>? breakpoints,
  }) {
    return _BuildListener(
      breakpoints: breakpoints,
      child: child ?? const SizedBox.shrink(),
    );
  }

  bool isDevice(String name) => breakpoint.name == name;

  static FlutterBreakpointProvider of(BuildContext context) {
    final responsiveProvider = context.dependOnInheritedWidgetOfExactType<FlutterBreakpointProvider>();
    assert(responsiveProvider != null, "UiResponsiveProvider não foi encontrado no contexto!");
    return responsiveProvider!;
  }

  static void _modifyDevice(BuildContext context, List<FlutterBreakpoint> breakpoints, void Function(FlutterBreakpoint) deviceCallBack) {
    final provider = FlutterBreakpointProvider.of(context);
    final double width = MediaQuery.sizeOf(context).width;

    final FlutterBreakpoint result = breakpoints.where((bp) => width >= bp.minWidth).reduce((a, b) => a.minWidth > b.minWidth ? a : b);

    if (provider.breakpoint != result) {
      log("Change to -> ${result.name}", name: 'Breakpoint');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        deviceCallBack(result);
      });
    }
  }

  static void _modifySize(BuildContext context, void Function(Size) sizeCallBack) {
    final provider = FlutterBreakpointProvider.of(context);
    final Size size = MediaQuery.sizeOf(context);
    if (provider.size != size) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        sizeCallBack(size);
      });
    }
  }
}

class _BuildListener extends StatefulWidget {
  final Widget child;
  final List<FlutterBreakpoint>? breakpoints;

  const _BuildListener({
    required this.child,
    this.breakpoints,
  });

  @override
  State<_BuildListener> createState() => _BuildListenerState();
}

class _BuildListenerState extends State<_BuildListener> {
  late final List<FlutterBreakpoint> _breakPoints = widget.breakpoints ?? Breakpoints._breakpoints;
  late FlutterBreakpoint device;
  Size? size;

  @override
  void initState() {
    super.initState();
    device = _breakPoints.first;
  }

  void modifyDevice(BuildContext context) {
    FlutterBreakpointProvider._modifyDevice(context, _breakPoints, (newDevice) => setState(() => device = newDevice));
    FlutterBreakpointProvider._modifySize(context, (newSize) => setState(() => size = newSize));
  }

  @override
  Widget build(BuildContext context) {
    return FlutterBreakpointProvider._(
      breakpoints: _breakPoints,
      breakpoint: device,
      size: size,
      child: Builder(builder: (context) {
        modifyDevice(context);
        return widget.child;
      }),
    );
  }
}

extension ResponsiveProviderContext on BuildContext {
  FlutterBreakpointProvider get responsive => FlutterBreakpointProvider.of(this);
}
