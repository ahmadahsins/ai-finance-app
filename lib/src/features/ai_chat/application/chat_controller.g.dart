// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatController)
final chatControllerProvider = ChatControllerProvider._();

final class ChatControllerProvider
    extends $NotifierProvider<ChatController, List<ChatMessage>> {
  ChatControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatControllerHash();

  @$internal
  @override
  ChatController create() => ChatController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ChatMessage> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ChatMessage>>(value),
    );
  }
}

String _$chatControllerHash() => r'a09340f8dfc1da1e19ebac0b13fe55cf32e28227';

abstract class _$ChatController extends $Notifier<List<ChatMessage>> {
  List<ChatMessage> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<ChatMessage>, List<ChatMessage>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ChatMessage>, List<ChatMessage>>,
              List<ChatMessage>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
