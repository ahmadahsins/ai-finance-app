// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(allTransactions)
final allTransactionsProvider = AllTransactionsProvider._();

final class AllTransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransactionModel>>,
          List<TransactionModel>,
          Stream<List<TransactionModel>>
        >
    with
        $FutureModifier<List<TransactionModel>>,
        $StreamProvider<List<TransactionModel>> {
  AllTransactionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allTransactionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allTransactionsHash();

  @$internal
  @override
  $StreamProviderElement<List<TransactionModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TransactionModel>> create(Ref ref) {
    return allTransactions(ref);
  }
}

String _$allTransactionsHash() => r'2d0a234bbfab88bb91443fd8790949764362be92';

@ProviderFor(groupedTransactions)
final groupedTransactionsProvider = GroupedTransactionsFamily._();

final class GroupedTransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<TransactionModel>>>,
          AsyncValue<Map<String, List<TransactionModel>>>,
          AsyncValue<Map<String, List<TransactionModel>>>
        >
    with $Provider<AsyncValue<Map<String, List<TransactionModel>>>> {
  GroupedTransactionsProvider._({
    required GroupedTransactionsFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'groupedTransactionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupedTransactionsHash();

  @override
  String toString() {
    return r'groupedTransactionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<Map<String, List<TransactionModel>>>>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  AsyncValue<Map<String, List<TransactionModel>>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return groupedTransactions(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    AsyncValue<Map<String, List<TransactionModel>>> value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<Map<String, List<TransactionModel>>>>(
            value,
          ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GroupedTransactionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupedTransactionsHash() =>
    r'04ce19fe9284f7898fc78cc9417d01af432c6910';

final class GroupedTransactionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          AsyncValue<Map<String, List<TransactionModel>>>,
          DateTime
        > {
  GroupedTransactionsFamily._()
    : super(
        retry: null,
        name: r'groupedTransactionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GroupedTransactionsProvider call(DateTime selectedMonth) =>
      GroupedTransactionsProvider._(argument: selectedMonth, from: this);

  @override
  String toString() => r'groupedTransactionsProvider';
}

@ProviderFor(historySummary)
final historySummaryProvider = HistorySummaryFamily._();

final class HistorySummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<HistorySummary>,
          AsyncValue<HistorySummary>,
          AsyncValue<HistorySummary>
        >
    with $Provider<AsyncValue<HistorySummary>> {
  HistorySummaryProvider._({
    required HistorySummaryFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'historySummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$historySummaryHash();

  @override
  String toString() {
    return r'historySummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<HistorySummary>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<HistorySummary> create(Ref ref) {
    final argument = this.argument as DateTime;
    return historySummary(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<HistorySummary> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<HistorySummary>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HistorySummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$historySummaryHash() => r'e9c91779fde9ea105a15bafffbdfe1d81a140cb8';

final class HistorySummaryFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<HistorySummary>, DateTime> {
  HistorySummaryFamily._()
    : super(
        retry: null,
        name: r'historySummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HistorySummaryProvider call(DateTime selectedMonth) =>
      HistorySummaryProvider._(argument: selectedMonth, from: this);

  @override
  String toString() => r'historySummaryProvider';
}

@ProviderFor(HistoryController)
final historyControllerProvider = HistoryControllerProvider._();

final class HistoryControllerProvider
    extends $AsyncNotifierProvider<HistoryController, void> {
  HistoryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyControllerHash();

  @$internal
  @override
  HistoryController create() => HistoryController();
}

String _$historyControllerHash() => r'f7fbe0a7d87160b83ffb14a76230f1fa1c781d3d';

abstract class _$HistoryController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
