import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget? child;

  final Widget Function(
    BuildContext context,
    A a,
    B b,
    Widget? child,
  ) builder;

  const ValueListenableBuilder2({
    super.key,
    required this.first,
    required this.second,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, a, child) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, child) {
            return builder(context, a, b, child);
          },
          child: child,
        );
      },
      child: child,
    );
  }
}

class ValueListenableBuilder3<A, B, C> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final ValueListenable<C> third;
  final Widget? child;

  final Widget Function(
    BuildContext context,
    A a,
    B b,
    C c,
    Widget? child,
  ) builder;

  const ValueListenableBuilder3({
    super.key,
    required this.first,
    required this.second,
    required this.third,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder2(
      first: first,
      second: second,
      builder: (context, a, b, child) {
        return ValueListenableBuilder<C>(
          valueListenable: third,
          builder: (context, c, child) {
            return builder(context, a, b, c, child);
          },
          child: child,
        );
      },
    );
  }
}
