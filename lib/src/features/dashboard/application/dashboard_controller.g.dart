// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dashboardTransactions)
final dashboardTransactionsProvider = DashboardTransactionsProvider._();

final class DashboardTransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransactionModel>>,
          List<TransactionModel>,
          Stream<List<TransactionModel>>
        >
    with
        $FutureModifier<List<TransactionModel>>,
        $StreamProvider<List<TransactionModel>> {
  DashboardTransactionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardTransactionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardTransactionsHash();

  @$internal
  @override
  $StreamProviderElement<List<TransactionModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TransactionModel>> create(Ref ref) {
    return dashboardTransactions(ref);
  }
}

String _$dashboardTransactionsHash() =>
    r'00e006c7e4e2c4ccb6658316a66e6d844d4f08fb';

@ProviderFor(transactionSummary)
final transactionSummaryProvider = TransactionSummaryProvider._();

final class TransactionSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<TransactionSummary>,
          AsyncValue<TransactionSummary>,
          AsyncValue<TransactionSummary>
        >
    with $Provider<AsyncValue<TransactionSummary>> {
  TransactionSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionSummaryHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<TransactionSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<TransactionSummary> create(Ref ref) {
    return transactionSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<TransactionSummary> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<TransactionSummary>>(
        value,
      ),
    );
  }
}

String _$transactionSummaryHash() =>
    r'4350bfed8030d9c078eb95664858a10ba46388ed';

@ProviderFor(recentTransactions)
final recentTransactionsProvider = RecentTransactionsProvider._();

final class RecentTransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransactionModel>>,
          AsyncValue<List<TransactionModel>>,
          AsyncValue<List<TransactionModel>>
        >
    with $Provider<AsyncValue<List<TransactionModel>>> {
  RecentTransactionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentTransactionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentTransactionsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<TransactionModel>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<TransactionModel>> create(Ref ref) {
    return recentTransactions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<TransactionModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<TransactionModel>>>(
        value,
      ),
    );
  }
}

String _$recentTransactionsHash() =>
    r'4a9ead1a9cb65ffafa9355fe07fdce6f435045d6';
