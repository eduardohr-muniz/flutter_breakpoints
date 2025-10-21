import 'package:flutter/material.dart';
import 'package:flutter_breakpoints/flutter_breakpoints.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Breakpoints',
      builder: (context, child) => FlutterBreakpointProvider.builder(context: context, child: child),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ResponsivePage(),
    );
  }
}

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.mobile.isBreakpoint(context);
    final isTablet = Breakpoints.tablet.isBreakpoint(context);
    final isDesktop = Breakpoints.desktop.isBreakpoint(context) || Breakpoints.largeDesktop.isBreakpoint(context);

    Widget coloredContainer(Color color) {
      return Container(
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
      );
    }

    List<Widget> buildContainers({required Color color, required int qty}) {
      return List.generate(qty, (index) => coloredContainer(color));
    }

    final list = buildContainers(color: Colors.red.shade900, qty: 2);
    final list2 = buildContainers(color: Colors.red.shade300, qty: 2);
    final list3 = buildContainers(color: Colors.grey.shade400, qty: 6);

    Widget buildMobileLayout() {
      return ListView(
        children: [
          ...list,
          ...list2,
          ...list3,
        ],
      );
    }

    Widget buildTabletLayour() {
      return Row(
        children: [
          Expanded(
            child: ListView(
              children: [
                ...list,
                ...list2,
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 300,
            child: ListView(
              children: [
                ...list3,
              ],
            ),
          ),
        ],
      );
    }

    Widget buildDesktopLayout() {
      return Row(
        children: [
          Expanded(
            child: ListView(
              children: list,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ListView(
              children: list2,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 300,
            child: ListView(
              children: list3,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Breakpoints Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: () {
          if (isMobile) return buildMobileLayout();
          if (isTablet) return buildTabletLayour();
          if (isDesktop) return buildDesktopLayout();
          return const SizedBox.shrink();
        }(),
      ),
    );
  }
}
