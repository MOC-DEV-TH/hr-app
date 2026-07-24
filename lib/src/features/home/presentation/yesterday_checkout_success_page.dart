import 'package:flutter/material.dart';

class YesterdayCheckoutSuccessPage extends StatelessWidget {
  const YesterdayCheckoutSuccessPage({
    super.key,
  });

  static const Color _primaryBlue = Color(0xFF3971B8);
  static const Color _backgroundColor = Color(0xFFF7F7F7);
  static const Color _buttonColor = Color(0xFFFBE7A2);
  static const Color _darkTextColor = Color(0xFF465267);

  void _goToCheckIn(BuildContext context) {
    Navigator.of(context).popUntil(
          (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: _primaryBlue,
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              _goToCheckIn(context);
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              28,
              40,
              28,
              34,
            ),
            child: Column(
              children: [
                const Spacer(
                  flex: 4,
                ),

                const _SuccessCheckIcon(),

                const SizedBox(height: 38),

                const Text(
                  'Submitted Successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _darkTextColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Yesterday checkout has been recorded.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _darkTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'You can now check-in today.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _darkTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),

                const Spacer(
                  flex: 3,
                ),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      _goToCheckIn(context);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: _buttonColor,
                      foregroundColor: const Color(
                        0xFF24436A,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          28,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Go To Check-in',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const Spacer(
                  flex: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessCheckIcon extends StatelessWidget {
  const _SuccessCheckIcon();

  static const Color _greenColor = Color(0xFF00AD68);
  static const Color _greenBackgroundColor = Color(0xFFE9F8F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: const BoxDecoration(
        color: _greenBackgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _greenColor,
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.check_rounded,
          color: _greenColor,
          size: 30,
        ),
      ),
    );
  }
}