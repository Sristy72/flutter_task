import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';
import '../../../../core/theme/app_icons.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/app_back_button.dart';
import '../widgets/otp_box.dart';
import '../widgets/text_with_navigation_button.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String? email;

  const VerifyEmailScreen({
    super.key,
    this.email,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _controller4 = TextEditingController();

  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();
  final _focusNode4 = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  void _onCodeChanged() {
    final code =
        '${_controller1.text}${_controller2.text}${_controller3.text}${_controller4.text}';
    context.read<AuthBloc>().add(OtpCodeChanged(code));
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _handleVerify(AuthState state) {
    if (!state.isOtpCodeComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 4-digit verification code'),
          backgroundColor: Color(0xFF1E2320),
        ),
      );
      return;
    }

    final email = widget.email?.trim() ?? '';
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email address is missing'),
          backgroundColor: Color(0xFF1E2320),
        ),
      );
      return;
    }

    final code =
        '${_controller1.text}${_controller2.text}${_controller3.text}${_controller4.text}';

    context.read<AuthBloc>().add(
      VerifyOtp(
        email: email,
        otp: code,
      ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == AuthStatus.otpVerificationSuccess ||
           current.status == AuthStatus.otpVerificationFailure),
      listener: (context, state) {
        if (state.status == AuthStatus.otpVerificationSuccess) {
          context.read<AuthBloc>().add(AuthStatusReset());
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.registrationSuccess,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;
        return state.isOtpLockedOut
            ? _buildLockoutScreen(state)
            : _buildVerifyScreen(state, isLoading: isLoading);
      },
    );
  }

  // ── Lockout screen ──────────────────────────────────────────────────────────

  Widget _buildLockoutScreen(AuthState state) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const AppBackButton(),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Padlock icon
              const PadIcon(),

              const SizedBox(height: AppDimensions.boldFontSize),

              // "Too Many Attempts" heading
              const Text(
                'Too Many Attempts',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deenColor,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Description
              const Text(
                'You have entered an incorrect code too many\ntimes. For your security, this feature is locked.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimensions.fontSizeMedium,
                  color: AppColors.splashTextColour,
                  fontWeight: FontWeight.w500,
                  letterSpacing: AppDimensions.letterSpacing,
                ),
              ),

              const SizedBox(height: 32),

              // Countdown Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 22),
                decoration: BoxDecoration(
                  color: const Color(0xFF131714),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF1F2620),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(state.otpLockoutCountdown),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deenColor,
                        letterSpacing: 2,
                        fontFeatures: [
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'TRY AGAIN IN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6E786B),
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Need help? Contact Support
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.help,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Need help? ',
                      style: TextStyle(
                        fontSize: AppDimensions.fontSizeMedium,
                        color: AppColors.splashTextColour,
                        fontWeight: FontWeight.w500,
                        letterSpacing: AppDimensions.letterSpacing,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Support: support@deenstep.com'),
                            backgroundColor: Color(0xFF1E2320),
                          ),
                        );
                      },
                      child: const Text(
                        'Contact Support',
                        style: TextStyle(
                          fontSize: AppDimensions.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryButton,
                          letterSpacing: AppDimensions.letterSpacing,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Verify screen ───────────────────────────────────────────────────────────

  Widget _buildVerifyScreen(AuthState state, {bool isLoading = false}) {
    final displayEmail = widget.email?.isNotEmpty == true
        ? widget.email!
        : 'user@example.com';

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const AppBackButton(),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Heading
                const Text(
                  'Verify Email',
                  style: TextStyle(
                    fontSize: AppDimensions.heightBetweenButtonAndText,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deenColor,
                  ),
                ),

                const SizedBox(height: AppDimensions.paddingSmall),

                // 2. Subtitle with email
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: AppDimensions.fontSizeMedium,
                      color: AppColors.hintColor,
                      letterSpacing: AppDimensions.letterSpacing,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Enter the 4-digit code sent to your\nemail ',
                      ),
                      TextSpan(
                        text: displayEmail,
                        style: const TextStyle(
                          color: AppColors.deenColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.boldFontSize),

                // 3. Four OTP input boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OtpBox(
                      controller: _controller1,
                      focusNode: _focusNode1,
                      nextFocusNode: _focusNode2,
                      hasError: state.otpHasError, onCodeChanged: () { _onCodeChanged(); },
                    ),
                    OtpBox(
                      controller: _controller2,
                      focusNode: _focusNode2,
                      prevFocusNode: _focusNode1,
                      nextFocusNode: _focusNode3,
                      hasError: state.otpHasError,
                      onCodeChanged: () { _onCodeChanged(); },
                    ),
                    OtpBox(
                      controller: _controller3,
                      focusNode: _focusNode3,
                      prevFocusNode: _focusNode2,
                      nextFocusNode: _focusNode4,
                      hasError: state.otpHasError,
                      onCodeChanged: () { _onCodeChanged(); },
                    ),
                    OtpBox(
                      controller: _controller4,
                      focusNode: _focusNode4,
                      prevFocusNode: _focusNode3,
                      hasError: state.otpHasError,
                      onCodeChanged: () { _onCodeChanged(); },
                    ),
                  ],
                ),

                // Error message row (shown when state.otpHasError is true)
                if (state.otpHasError && state.otpErrorMessage.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    state.otpErrorMessage,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: AppDimensions.fontSizeMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],

                const SizedBox(height: AppDimensions.heightBetweenButtonAndText),

                // 4. Verify Button
                SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeight,
                  child: PrimaryButton(
                    text: 'Verify',
                    isLoading: isLoading,
                    backgroundColor: state.isOtpCodeComplete && !isLoading
                        ? AppColors.primaryButton
                        : AppColors.secondary,
                    onPressed: isLoading ? null : () => _handleVerify(state),
                  ),
                ),

                const SizedBox(height: AppDimensions.heightBetweenButtonAndText),

                // 5. Didn't receive code? Resend Code (with countdown)
                AuthNavigationText(
                  message: "Didn't receive code? ",
                  actionText: state.otpResendCountdown > 0
                      ? 'Resend in 00:${state.otpResendCountdown.toString().padLeft(2, '0')}'
                      : 'Resend Code',
                  actionColor: AppColors.primaryButton,
                  onTap: () {},
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PadIcon extends StatelessWidget {
  const PadIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lockBack,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 0),
            blurRadius: 20,
            spreadRadius: 0,
          )
        ],
        border: Border.all(
          color: AppColors.textFieldBorderColor,
          width: 1,
        ),
      ),
      child: Center(
        child: Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.lockBack,
            border: Border.all(
              color: AppColors.textFieldBorderColor,
              width: 2,
            ),
          ),
          child: Center(
            child: Image.asset(
              AppIcons.lock,
              width: 36,
              height: 36,
            ),
          ),
        ),
      ),
    );
  }
}
