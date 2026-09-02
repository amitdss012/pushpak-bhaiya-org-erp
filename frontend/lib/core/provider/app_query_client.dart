import 'package:flutter_query/flutter_query.dart';

/// App-wide configured instance and factory for [QueryClient].
class AppQueryClient {
  AppQueryClient._();

  /// Default cache time and stale duration of 5 minutes for queries.
  static const Duration cacheTime = Duration(minutes: 5);

  static final QueryClient instance = QueryClient(
    defaultQueryOptions: const DefaultQueryOptions(
      staleDuration: StaleDuration(minutes: 5),
      gcDuration: GcDuration(minutes: 5),
    ),
  );
}
