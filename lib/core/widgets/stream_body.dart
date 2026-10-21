import 'package:flutter/material.dart';

import 'common.dart';

/// [StreamBuilder] with the app's loading and error states. Keep the stream
/// in widget state so it is not re-created on every build.
class StreamBody<T> extends StatelessWidget {
  const StreamBody({super.key, required this.stream, required this.builder});
  final Stream<T> stream;
  final Widget Function(BuildContext context, T data) builder;

  @override
  Widget build(BuildContext context) => StreamBuilder<T>(
    stream: stream,
    builder: (context, snap) {
      if (snap.hasError) return ErrorView(message: '${snap.error}');
      if (!snap.hasData) return const LoadingView();
      return builder(context, snap.data as T);
    },
  );
}
