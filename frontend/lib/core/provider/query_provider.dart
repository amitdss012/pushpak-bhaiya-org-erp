import 'package:flutter/widgets.dart';
import 'package:flutter_query/flutter_query.dart';

import 'app_query_client.dart';

/// Top-level provider widget wrapping [QueryClientProvider] to furnish
/// the global [QueryClient] throughout the widget hierarchy.
class AppQueryProvider extends StatelessWidget {
  final Widget child;
  final QueryClient? client;

  const AppQueryProvider({
    super.key,
    required this.child,
    this.client,
  });

  @override
  Widget build(BuildContext context) {
    final queryClient = client ?? AppQueryClient.instance;
    return QueryClientProvider(
      create: (_) => queryClient,
      child: child,
    );
  }
}
