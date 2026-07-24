import 'package:flutter/material.dart';
import 'package:hr_app/src/features/home/presentation/yesterday_checkout_success_page.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../common_widgets/loading_view.dart';

typedef SaveYesterdayCheckoutCallback =
    Future<bool> Function({
      required DateTime date,
      required String checkoutTime,
    });

class AddYesterdayCheckoutPage extends StatefulWidget {
  const AddYesterdayCheckoutPage({
    super.key,
    required this.date,
    required this.onSave,
    this.initialCheckoutTime,
  });

  final DateTime date;

  /// Return true when the API request succeeds.
  final SaveYesterdayCheckoutCallback onSave;

  /// Optional initial value, for example: "17:30" or "17:30:00".
  final String? initialCheckoutTime;

  @override
  State<AddYesterdayCheckoutPage> createState() =>
      _AddYesterdayCheckoutPageState();
}

class _AddYesterdayCheckoutPageState extends State<AddYesterdayCheckoutPage> {
  static const Color _primaryBlue = Color(0xFF3971B8);
  static const Color _backgroundColor = Color(0xFFFFFFFF);
  static const Color _cardBackgroundColor = Color(0xFFFFFDF0);
  static const Color _yellowBorderColor = Color(0xFFF4B400);
  static const Color _saveButtonColor = Color(0xFFFBE7A2);
  static const Color _darkTextColor = Color(0xFF374151);
  static const Color _greyTextColor = Color(0xFF687386);
  static const Color _fieldBorderColor = Color(0xFFE2E5E9);

  final TextEditingController _checkoutTimeController = TextEditingController();

  TimeOfDay? _selectedCheckoutTime;

  bool _isSaving = false;
  String? _checkoutTimeError;

  @override
  void initState() {
    super.initState();

    _setInitialCheckoutTime();
  }

  @override
  void dispose() {
    _checkoutTimeController.dispose();
    super.dispose();
  }

  void _setInitialCheckoutTime() {
    final initialTime = widget.initialCheckoutTime?.trim();

    if (initialTime == null || initialTime.isEmpty) {
      return;
    }

    final parsedTime = _parseTime(initialTime);

    if (parsedTime == null) {
      return;
    }

    _selectedCheckoutTime = parsedTime;
    _checkoutTimeController.text = _formatTimeForDisplay(parsedTime);
  }

  TimeOfDay? _parseTime(String value) {
    try {
      final parts = value.split(':');

      if (parts.length < 2) {
        return null;
      }

      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);

      if (hour == null ||
          minute == null ||
          hour < 0 ||
          hour > 23 ||
          minute < 0 ||
          minute > 59) {
        return null;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return null;
    }
  }

  String _formatTimeForDisplay(TimeOfDay time) {
    final dateTime = DateTime(2026, 1, 1, time.hour, time.minute);

    return DateFormat('hh:mm a').format(dateTime);
  }

  String _formatTimeForApi(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');

    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String get _formattedDate {
    return DateFormat('dd MMM yyyy').format(widget.date);
  }

  Future<void> _selectCheckoutTime() async {
    if (_isSaving) {
      return;
    }

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedCheckoutTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: 'SELECT TIME',
      cancelText: 'CANCEL',
      confirmText: 'OK',
      builder: (dialogContext, child) {
        final theme = Theme.of(dialogContext);

        return MediaQuery(
          data: MediaQuery.of(
            dialogContext,
          ).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: theme.copyWith(
              useMaterial3: false,
              colorScheme: const ColorScheme.light(
                primary: _primaryBlue,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: _darkTextColor,
              ),
              timePickerTheme: TimePickerThemeData(
                backgroundColor: Colors.white,

                hourMinuteTextColor: _darkTextColor,
                hourMinuteColor: const Color(0xFFE0E0E0),

                dialBackgroundColor: const Color(0xFFE0E0E0),
                dialHandColor: _primaryBlue,
                dialTextColor: _darkTextColor,

                /*
               * Selected AM/PM background.
               */
                dayPeriodColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(0xFFE7D9FF);
                  }

                  return Colors.transparent;
                }),

                /*
               * Selected AM/PM text color.
               */
                dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return _primaryBlue;
                  }

                  return _darkTextColor;
                }),

                dayPeriodBorderSide: const BorderSide(
                  color: Color(0xFF9CA3AF),
                  width: 1,
                ),

                dayPeriodShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),

                entryModeIconColor: _primaryBlue,

                helpTextStyle: const TextStyle(
                  color: _greyTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: _primaryBlue,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (selectedTime == null || !mounted) {
      return;
    }

    setState(() {
      _selectedCheckoutTime = selectedTime;

      _checkoutTimeController.text = _formatTimeForDisplay(selectedTime);

      _checkoutTimeError = null;
    });

    debugPrint(
      'Selected time: '
      '${_formatTimeForDisplay(selectedTime)}',
    );

    debugPrint(
      'API time: '
      '${_formatTimeForApi(selectedTime)}',
    );
  }

  bool _validateForm() {
    if (_selectedCheckoutTime == null) {
      setState(() {
        _checkoutTimeError = 'Please select your checkout time.';
      });

      return false;
    }

    setState(() {
      _checkoutTimeError = null;
    });

    return true;
  }

  Future<void> _saveCheckout() async {
    if (_isSaving || !_validateForm()) {
      return;
    }

    final selectedTime = _selectedCheckoutTime;

    if (selectedTime == null) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isSaving = true;
    });

    try {
      final success = await widget.onSave(
        date: widget.date,
        checkoutTime: _formatTimeForApi(selectedTime),
      );

      if (!mounted) {
        return;
      }

      if (!success) {
        _showErrorMessage(
          'Unable to save the checkout time. Please try again.',
        );

        return;
      }

      if (!mounted) {
        return;
      }

      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const YesterdayCheckoutSuccessPage()),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showErrorMessage('Something went wrong: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade700,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSaving,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: _backgroundColor,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: _primaryBlue,
              foregroundColor: Colors.white,
              leading: IconButton(
                onPressed: _isSaving
                    ? null
                    : () {
                  Navigator.of(context).pop(false);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 27,
                ),
              ),
              title: const Text(
                'Add Yesterday Checkout',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  32,
                  24,
                  40,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _buildInformationCard(),

                    const SizedBox(height: 36),

                    const Text(
                      'Checkout Time',
                      style: TextStyle(
                        color: _darkTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 7),

                    _buildTimeField(),

                    if (_checkoutTimeError != null) ...[
                      const SizedBox(height: 7),
                      Padding(
                        padding:
                        const EdgeInsets.only(
                          left: 4,
                        ),
                        child: Text(
                          _checkoutTimeError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight:
                            FontWeight.w400,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 70),

                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ),

          if (_isSaving)
            Positioned.fill(
              child: Container(
                color: Colors.black38,
                child: const Center(
                  child: LoadingView(
                    indicatorColor: Colors.white,
                    indicator: Indicator.ballRotate,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInformationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 27, 20, 24),
      decoration: BoxDecoration(
        color: kSoftYellow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPrimaryColor, width: 1.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'You didn’t checkout yesterday',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _greyTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            '( $_formattedDate )',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _darkTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 13),

          const Text(
            'Please provide your checkout details',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _greyTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeField() {
    return TextFormField(
      controller: _checkoutTimeController,
      readOnly: true,
      enabled: !_isSaving,
      onTap: _selectCheckoutTime,
      style: const TextStyle(
        color: _darkTextColor,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: '00:00',
        hintStyle: const TextStyle(
          color: Color(0xFFB5B8B0),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 16,
        ),
        suffixIcon: IconButton(
          onPressed: _isSaving ? null : _selectCheckoutTime,
          icon: const Icon(
            Icons.access_time_filled,
            size: 17,
            color: Color(0xFFA9AC9F),
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(
            color: _checkoutTimeError == null ? _fieldBorderColor : Colors.red,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(
            color: _checkoutTimeError == null ? _primaryBlue : Colors.red,
            width: 1.3,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: _fieldBorderColor, width: 1),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveCheckout,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: kPrimaryColor,
          foregroundColor: _darkTextColor,
          disabledBackgroundColor: _saveButtonColor.withOpacity(0.65),
          disabledForegroundColor: _darkTextColor.withOpacity(0.55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
      ),
    );
  }
}
