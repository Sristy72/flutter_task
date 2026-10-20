import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colours.dart';
import '../../../../core/theme/app_dimentions.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/app_back_button.dart';
import '../widgets/input_textfield.dart';
import '../widgets/or_divider.dart';
import '../widgets/social_button.dart';
import '../widgets/text_widget.dart';
import '../widgets/text_with_navigation_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
    _passwordController.addListener(_onFormChanged);
    _confirmPasswordController.addListener(_onFormChanged);
  }


  bool _isPasswordValid(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[^a-zA-Z0-9\s]').hasMatch(password) &&
        !RegExp(r'\s').hasMatch(password);
  }

  void _onFormChanged() {
    final agreed = context.read<AuthBloc>().state.isTermsAndConditions;

    context.read<AuthBloc>().add(
      SignUpFormChanged(
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        termsCondition: agreed,
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister(AuthState state) {
    if (_fullNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill up all input fields'),
          backgroundColor: Color(0xFF1E2320),
        ),
      );
      return;
    }

    // Validate password requirements
    if (!_isPasswordValid(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password must be at least 8 characters and contain '
                'an uppercase letter, a lowercase letter, a number, '
                'and a special character. Spaces are not allowed.',
          ),
          backgroundColor: Color(0xFF1E2320),
        ),
      );
      return;
    }

    // Confirm password must match
    if (_passwordController.text !=
        _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Color(0xFF1E2320),
        ),
      );
      return;
    }

    // Terms and conditions must be accepted
    if (!state.isTermsAndConditions) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please accept the Privacy Policy and Terms to proceed',
          ),
          backgroundColor: Color(0xFF1E2320),
        ),
      );
      return;
    }

    // Submit registration through BLoC
    context.read<AuthBloc>().add(
      Signup(
        name: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        termsCondition: state.isTermsAndConditions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == AuthStatus.signupSuccess ||
           current.status == AuthStatus.failure),
      listener: (context, state) {
        if (state.status == AuthStatus.signupSuccess) {
          final message = state.successMsg ??
              'Account created successfully! Please verify your email.';
          context.read<AuthBloc>().add(AuthStatusReset());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
                style: const TextStyle(color: AppColors.secondaryButtonColor),
              ),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pushNamed(
            context,
            AppRoutes.verifyEmail,
            arguments: _emailController.text.trim(),
          );
        } else if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMsg ?? 'Registration failed'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;
        final obscurePassword = !state.isPasswordVisible;
        final obscureConfirmPassword = !state.isConfirmPasswordVisible;

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
                    // 2. Heading & Subtitle
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: AppDimensions.boldFontSize,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deenColor,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.radiusSmall),
                    const Text(
                      'Start your consistent steps towards spiritual growth.',
                      style: TextStyle(
                        fontSize: AppDimensions.fontSizeMedium,
                        color: AppColors.splashTextColour,
                        fontWeight: FontWeight.w400,
                        letterSpacing: AppDimensions.letterSpacing,
                      ),
                    ),

                    const SizedBox(height: AppDimensions.boldFontSize),

                    InputTextField(
                      hintText: 'Full Name',
                      controller: _fullNameController,
                      keyboardType: TextInputType.name,
                    ),

                    const SizedBox(height: AppDimensions.backButtonIconSize),

                    // 4. Email Address
                    InputTextField(
                      controller: _emailController,
                      hintText: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: AppDimensions.backButtonIconSize),

                    // 5. Password
                    InputTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      obscureText: obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.eyeColor,
                          size: AppDimensions.backButtonIconSize,
                        ),
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(PasswordVisibilityCheck());
                        },
                      ),
                    ),

                    const SizedBox(height: AppDimensions.backButtonIconSize),

                    // 6. Confirm Password
                    InputTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.eyeColor,
                          size: AppDimensions.backButtonIconSize,
                        ),
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(ConfirmPasswordVisibilityCheck());
                        },
                      ),
                    ),

                    const SizedBox(
                      height: AppDimensions.heightBetweenButtonAndText,
                    ),

                    // 7. Terms & Privacy Checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Checkbox(
                            value: state.isTermsAndConditions,
                            onChanged: isLoading
                                ? null
                                : (value) {
                                    final agreed = value ?? false;
                                    context
                                        .read<AuthBloc>()
                                        .add(TermsAndCondition(agreed));
                                    context.read<AuthBloc>().add(
                                      SignUpFormChanged(
                                        fullName: _fullNameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        confirmPassword:
                                            _confirmPasswordController.text,
                                        termsCondition: agreed,
                                      ),
                                    );
                                  },
                            activeColor: Colors.white,
                            fillColor:
                                WidgetStateProperty.resolveWith<Color>((states) {
                              return Colors.white;
                            }),
                            checkColor: Colors.black,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        Expanded(
                          child: termsAndCondition(),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDimensions.backButtonIconSize),

                    // 8. Register Account Button
                    SizedBox(
                      width: double.infinity,
                      height: AppDimensions.buttonHeight,
                      child: PrimaryButton(
                        text: 'Register Account',
                        isLoading: isLoading,
                        backgroundColor: state.isSignUpFormValid && !isLoading
                            ? AppColors.primaryButton
                            : AppColors.secondary,
                        onPressed: isLoading ? null : () => _handleRegister(state),
                      ),
                    ),

                    const SizedBox(
                      height: AppDimensions.heightBetweenButtonAndText,
                    ),

                    // 9. Have an account? Log In
                    AuthNavigationText(
                      message: 'Have an account? ',
                      actionText: 'Log In',
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      },
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    // 10. OR Divider
                    const OrDivider(),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // 11. Log In With text
                    const TextWidget(text: 'Log In With'),

                    const SizedBox(height: AppDimensions.heightMedium),

                    // 12. Social Buttons (Google & Apple)
                    const SocialButtons(),

                    const SizedBox(
                      height: AppDimensions.heightBetweenButtonAndText,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  RichText termsAndCondition() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: AppDimensions.fontSizeMedium,
          color: AppColors.dontHaveAccountColor,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(text: 'I agree to the '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
              color: AppColors.primaryButton,
              fontWeight: FontWeight.w600,
              fontSize: AppDimensions.fontSizeMedium,
            ),
          ),
          TextSpan(text: ' and '),
          TextSpan(
            text: 'Terms.',
            style: TextStyle(
              color: AppColors.primaryButton,
              fontWeight: FontWeight.w600,
              fontSize: AppDimensions.fontSizeMedium,
            ),
          ),
          TextSpan(text: '\n'),
          TextSpan(
            text: 'Click here to Read.',
            style: TextStyle(
              color: AppColors.primaryButton,
              fontWeight: FontWeight.w600,
              fontSize: AppDimensions.fontSizeMedium,
            ),
          ),
        ],
      ),
    );
  }
}
