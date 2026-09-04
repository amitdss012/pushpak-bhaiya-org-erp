import 'dart:async';

import 'package:flutter_query/flutter_query.dart';

import 'toast_utils.dart';

/// Extension on [MutationSnapshot] to provide convenient UI helper getters.
extension AppMutationSnapshotX<TData, TError, TVariables>
    on MutationSnapshot<TData, TError, TVariables> {
  /// Returns a cleaned, user-friendly error message if mutation failed, or null.
  String? get errorMessage {
    if (this is MutationError<TData, TError, TVariables>) {
      final err = (this as MutationError<TData, TError, TVariables>).error;
      final msg = err.toString().replaceAll('Exception: ', '').trim();
      return msg.isNotEmpty ? msg : 'An unexpected error occurred';
    }
    return null;
  }
}

/// Clean mutation wrapper that automatically triggers Success & Error toasts
/// and simplifies mutation callback parameters.
MutationSnapshot<TData, Object, TVariables> useAppMutation<TData, TVariables>(
  Future<TData> Function(TVariables variables) mutationFn, {
  String? successMessage,
  String Function(TData data)? successMessageBuilder,
  void Function(TData data)? onSuccess,
  void Function(Object error)? onError,
  bool showSuccessToast = true,
  bool showErrorToast = true,
}) {
  return useMutation<TData, Object, TVariables, dynamic>(
    (variables, _) => mutationFn(variables),
    onSuccess: (data, variables, onMutateResult, context) {
      if (showSuccessToast) {
        String? message;
        try {
          final dynamic d = data;
          if (d?.message is String && (d.message as String).trim().isNotEmpty) {
            message = (d.message as String).trim();
          }
        } catch (_) {}

        message ??= successMessageBuilder?.call(data) ?? successMessage;
        if (message != null && message.isNotEmpty) {
          AppToast.showSuccess(message);
        }
      }
      onSuccess?.call(data);
    },
    onError: (error, variables, onMutateResult, context) {
      if (showErrorToast) {
        AppToast.showError(error);
      }
      onError?.call(error);
    },
  );
}
