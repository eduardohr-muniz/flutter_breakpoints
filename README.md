# Flutter Breakpoints

Flutter Breakpoints is a flexible package designed to help you manage responsive layouts in Flutter applications by defining specific breakpoints for different screen sizes.

## Table of Contents

- [Installation](#installation)
- [Getting Started](#getting-started)
  - [Basic Setup](#basic-setup)
  - [Implementing Responsive Layouts](#implementing-responsive-layouts)
  - [Customizing Breakpoints](#customizing-breakpoints)
  - [Using Custom Breakpoints in Your Application](#using-custom-breakpoints-in-your-application)
- [Examples](#examples)
- [Demonstrations](#demonstrations)

## Demonstrations

Below are GIFs demonstrating how the `flutter_breakpoints` package adapts layouts across different screen sizes. This visual representation helps illustrate the package's responsive design capabilities.

![Demo Breakpoints](assets/demo.gif)

## Installation

Add the `flutter_breakpoints` dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_breakpoints: ^1.0.0
```

## Getting Started

### Basic Setup

First, wrap your application with the `FlutterBreakpointProvider` in the `MaterialApp`:

```dart
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
      builder: (context, child) => FlutterBreakpointProvider.builder( // 👋
        context: context,                                             //
        child: child,                                                 //
      ),                                                              //
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ResponsivePage(),
    );
  }
}
```

### Implementing Responsive Layouts

Inside your pages or widgets, utilize the `Breakpoints` class to adjust the layout according to the device width:

```dart
class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.mobile.isBreakpoint(context);   // 👋
    final isTablet = Breakpoints.tablet.isBreakpoint(context);   // 
    final isDesktop = Breakpoints.desktop.isBreakpoint(context); // 

    if (isMobile) {
      return buildMobileLayout();
    } else if (isTablet) {
      return buildTabletLayout();
    } else if (isDesktop) {
      return buildDesktopLayout();
    }

    return const SizedBox.shrink();
  }

  Widget buildMobileLayout() => Center(child: Text('Mobile Layout'));
  Widget buildTabletLayout() => Center(child: Text('Tablet Layout'));
  Widget buildDesktopLayout() => Center(child: Text('Desktop Layout'));
}
```

### Customizing Breakpoints

To customize breakpoints, define custom breakpoints in a separate class called `MyBreakpoints`. Here's how you can do it:

```dart
class MyBreakpoints {
  MyBreakpoints._();
  static FlutterBreakpoint smallPhone = const FlutterBreakpoint(name: 'smallPhone', minWidth: 0);
  static FlutterBreakpoint largePhone = const FlutterBreakpoint(name: 'largePhone', minWidth: 400);
  static FlutterBreakpoint smallTablet = const FlutterBreakpoint(name: 'smallTablet', minWidth: 700);
  static FlutterBreakpoint largeTablet = const FlutterBreakpoint(name: 'largeTablet', minWidth: 900);

  static List<FlutterBreakpoint> get breakpoints => [
    smallPhone,
    largePhone,
    smallTablet,
    largeTablet,
  ];
}
```

### Using Custom Breakpoints in Your Application

Use your custom breakpoints in the `FlutterBreakpointProvider`:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Breakpoints',
      builder: (context, child) => FlutterBreakpointProvider.builder( // 
        context: context,                                             //
        child: child,                                                 //
        breakpoints: MyBreakpoints.breakpoints,                       // 👋 custom
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CustomResponsivePage(),
    );
  }
}

class CustomResponsivePage extends StatelessWidget {
  const CustomResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallPhone = MyBreakpoints.smallPhone.isBreakpoint(context); // 👋 custom
    final isLargePhone = MyBreakpoints.largePhone.isBreakpoint(context); // 
    final isSmallTablet = MyBreakpoints.smallTablet.isBreakpoint(context);//
    final isLargeTablet = MyBreakpoints.largeTablet.isBreakpoint(context);//

    if (isSmallPhone) {
      return Center(child: Text('Small Phone Layout'));
    } else if (isLargePhone) {
      return Center(child: Text('Large Phone Layout'));
    } else if (isSmallTablet) {
      return Center(child: Text('Small Tablet Layout'));
    } else if (isLargeTablet) {
      return Center(child: Text('Large Tablet Layout'));
    }

    return const SizedBox.shrink();
  }
}
```

## Examples

For a comprehensive demonstration of how to implement and customize breakpoints using the `flutter_breakpoints` package, please refer to the example available in the **Example** tab. This detailed example showcases the package's usage and demonstrates how to effectively handle different screen sizes.



