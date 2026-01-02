import 'package:finance_ai_app/src/common_widgets/styled_button.dart';
import 'package:finance_ai_app/src/constants/colors.dart';
import 'package:finance_ai_app/src/features/transactions/application/transaction_controller.dart';
import 'package:finance_ai_app/src/features/transactions/domain/category_item.dart';
import 'package:finance_ai_app/src/features/transactions/domain/transaction_model.dart';
import 'package:finance_ai_app/src/features/transactions/presentation/widgets/add_transaction_header.dart';
import 'package:finance_ai_app/src/features/transactions/presentation/widgets/amount_display_card.dart';
import 'package:finance_ai_app/src/features/transactions/presentation/widgets/category_selector_list.dart';
import 'package:finance_ai_app/src/features/transactions/presentation/widgets/custom_numpad.dart';
import 'package:finance_ai_app/src/features/transactions/presentation/widgets/transaction_input_form.dart';
import 'package:finance_ai_app/src/features/transactions/presentation/widgets/transaction_type_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  // state
  String _amountStr = "";
  TransactionType _selectedType = TransactionType.expense;
  CategoryItem _selectedCategory = kCategories.first;
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isNumpadVisible = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // logic methods
  void _onNumberTap(String value) {
    if (_amountStr == "0") _amountStr = "";
    if (_amountStr.length < 10) setState(() => _amountStr += value);
  }

  void _onBackspace() {
    if (_amountStr.isNotEmpty) {
      setState(
        () => _amountStr = _amountStr.substring(0, _amountStr.length - 1),
      );
    }
  }

  void _onClear() => setState(() => _amountStr = "");

  void _showTopToast(String message, {bool isError = false}) {
    toastification.show(
      context: context,
      type: isError ? ToastificationType.error : ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: Text(
        isError ? 'Oops!' : 'Success',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(message),
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 3),
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        ),
      ],
      showProgressBar: false,
      animationBuilder: (context, animation, alignment, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: const Offset(0, 0),
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }

  void _submit() {
    final amount = double.tryParse(_amountStr);
    if (amount == null || amount <= 0) {
      setState(() {
        _isNumpadVisible = true;
        _showTopToast('Please enter an amount', isError: true);
      });
      return;
    }

    ref
        .read(transactionControllerProvider.notifier)
        .addTransaction(
          amount: amount,
          type: _selectedType,
          category: _selectedCategory.name,
          description: _noteController.text,
          date: _selectedDate,
        );
  }

  Future<void> _pickDate() async {
    setState(() => _isNumpadVisible = false);
    FocusManager.instance.primaryFocus?.unfocus();

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isNumpadVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    final filteredCategories = kCategories
        .where((cat) => cat.type == _selectedType)
        .toList();

    if (!filteredCategories.contains(_selectedCategory)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _selectedCategory = filteredCategories.first);
        }
      });
    }

    ref.listen<AsyncValue<void>>(transactionControllerProvider, (
      prev,
      next,
    ) async {
      next.whenOrNull(
        data: (_) async {
          if (mounted) context.pop();
          _showTopToast('Transaction Saved!');
        },
        error: (e, s) {
          _showTopToast(e.toString(), isError: true);
        },
      );
    });

    final isLoading = ref.watch(transactionControllerProvider).isLoading;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() => _isNumpadVisible = false);
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: topPadding + 16,
                  bottom: 120,
                ),
                child: Column(
                  children: [
                    AddTransactionHeader(),

                    const SizedBox(height: 16),
                    TransactionTypeToggle(
                      selectedType: _selectedType,
                      onTypeChanged: (type) {
                        setState(() {
                          _selectedType = type;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    AmountDisplayCard(
                      amountStr: _amountStr,
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() => _isNumpadVisible = true);
                      },
                      isNumpadVisible: _isNumpadVisible,
                    ),

                    const SizedBox(height: 24),

                    CategorySelectorList(
                      categories: filteredCategories,
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (cat) => setState(() {
                        _selectedCategory = cat;
                      }),
                    ),

                    const SizedBox(height: 24),

                    TransactionInputForm(
                      noteController: _noteController,
                      selectedDate: _selectedDate,
                      onTapNote: () => setState(() {
                        _isNumpadVisible = false;
                      }),
                      onPickDate: _pickDate,
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (!isKeyboardVisible)
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) => SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: const Offset(0, 0),
                  ).animate(animation),
                  child: child,
                ),
                child: _isNumpadVisible
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: CustomNumpad(
                          onNumberTap: _onNumberTap,
                          onBackspaceTap: _onBackspace,
                          onClearTap: _onClear,
                          onHideTap: () =>
                              setState(() => _isNumpadVisible = false),
                          onEnterTap: () =>
                              setState(() => _isNumpadVisible = false),
                          isSubmitEnabled: _amountStr.isNotEmpty,
                        ),
                      )
                    : Container(
                        key: const ValueKey('save_button'),
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 24,
                          bottom: bottomPadding + 24,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.background.withValues(alpha: 0.0),
                              AppColors.background,
                            ],
                            stops: const [0.0, 0.3],
                          ),
                        ),
                        child: StyledButton(
                          text: 'Save',
                          onPressed: isLoading ? null : _submit,
                          isLoading: isLoading,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
