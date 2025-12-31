import 'package:finance_ai_app/src/common_widgets/styled_button.dart';
import 'package:finance_ai_app/src/constants/colors.dart';
import 'package:finance_ai_app/src/features/transactions/domain/category_item.dart';
import 'package:finance_ai_app/src/features/transactions/domain/transaction_model.dart';
import 'package:finance_ai_app/src/features/transactions/presentation/widgets/custom_numpad.dart';
import 'package:finance_ai_app/src/features/transactions/presentation/widgets/transaction_type_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  // state
  String _amountStr = "0";
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

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

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
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    final filteredCategories = kCategories
        .where((cat) => cat.type == _selectedType)
        .toList();
    if (!filteredCategories.contains(_selectedCategory)) {
      // Safe reset category
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _selectedCategory = filteredCategories.first);
        }
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _isNumpadVisible = false),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: topPadding + 16,
                  bottom: 120,
                ),
                child: Column(
                  children: [
                    _buildHeader(),

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

                    GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() => _isNumpadVisible = true);
                      },
                      child: _buildAmountDisplay(),
                    ),

                    const SizedBox(height: 24),

                    _buildCategorySelector(filteredCategories),

                    const SizedBox(height: 24),

                    _buildInputFields(),
                  ],
                ),
              ),
            ),
          ),

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
                        onCalendarTap: _pickDate,
                        onSubmit: () {},
                        isLoading: false,
                        isSubmitEnabled: true,
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
                        onPressed: () {},
                        isLoading: false,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.close, color: AppColors.textPrimary),
              onPressed: () => context.pop(),
            ),
          ),
          const Expanded(
            child: Text(
              "Add Transaction",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildAmountDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Text(
            "ENTER AMOUNT",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   'Rp',
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //     color: AppColors.textSecondary,
              //   ),
              // ),
              // const SizedBox(width: 8),
              Text(
                _amountStr.isEmpty
                    ? currencyFormatter.format(0)
                    : currencyFormatter.format(
                        double.tryParse(_amountStr) ?? 0,
                      ),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(List<CategoryItem> categories) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Select Category",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text('See all', style: TextStyle(color: AppColors.primary)),
          ],
        ),
        Container(
          height: 100,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.separated(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = _selectedCategory.id == cat.id;
              return _buildCategoryItem(cat, isSelected);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(width: 8);
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(CategoryItem cat, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = cat;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 4)
                  : null,
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: cat.color,
              child: Icon(cat.icon, color: AppColors.background),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            cat.name,
            style: TextStyle(
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _noteController,
            onTap: () {
              setState(() => _isNumpadVisible = false);
            },
            decoration: InputDecoration(
              hintText: 'Write a note (Optional)',
              hintStyle: TextStyle(color: AppColors.textSecondary),
              prefixIcon: Icon(
                Icons.description_outlined,
                color: AppColors.textSecondary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        GestureDetector(
          onTap: () => _pickDate(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    DateFormat('EEEE, MMM d, y').format(_selectedDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AppColors.textPrimary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
