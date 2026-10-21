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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onFormChanged);
    _passwordController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    context.read<AuthBloc>().add(
      LoginFormChanged(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
          backgroundColor: Color(0xFF1E2320),
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
      Login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          final message = state.successMsg ??
              (state.isGuest ? 'Logged in as Guest' : 'Welcome back!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
                style: const TextStyle(color: AppColors.secondaryButtonColor),
              ),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.navBar,
            (route) => false,
          );
        } else if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMsg ?? 'Login failed'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;
        final obscurePassword = !state.isLoginPasswordVisible;

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
                    // 1. Heading & Subtitle
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: AppDimensions.boldFontSize,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deenColor,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.radiusSmall),
                    const Text(
                      'Sign in to continue your spiritual journey.',
                      style: TextStyle(
                        fontSize: AppDimensions.fontSizeMedium,
                        color: AppColors.splashTextColour,
                        fontWeight: FontWeight.w400,
                        letterSpacing: AppDimensions.letterSpacing,
                      ),
                    ),

                    const SizedBox(height: AppDimensions.boldFontSize),

                    // 3. Email Field
                    InputTextField(
                      controller: _emailController,
                      hintText: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: AppDimensions.backButtonIconSize),

                    // 4. Password Field
                    InputTextField(
                      hintText: 'Password',
                      obscureText: obscurePassword,
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
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
                              .add(LoginPasswordVisibilityCheck());
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 5. Forgot password?
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // Handle forgot password
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSizeMedium,
                            fontWeight: FontWeight.w400,
                            color: AppColors.forgotPassColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // 6. Log In Button
                    SizedBox(
                      width: double.infinity,
                      height: AppDimensions.buttonHeight,
                      child: PrimaryButton(
                        text: 'Log In',
                        isLoading: isLoading,
                        backgroundColor: state.isLoginFormValid && !isLoading
                            ? AppColors.primaryButton
                            : AppColors.secondary,
                        onPressed: isLoading ? null : _handleLogin,
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    // 7. Don't have an account? Sign Up
                    AuthNavigationText(
                      message: "Don't have an account? ",
                      actionText: 'Sign Up',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.signup);
                      },
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    // 8. OR Divider
                    const OrDivider(),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // 9. Log In With text
                    const TextWidget(text: 'Log In With'),

                    const SizedBox(height: AppDimensions.heightMedium),

                    // 10. Social Buttons (Google & Apple)
                    SocialButtons(
                      onGoogleTap: isLoading
                          ? null
                          : () {
                              context
                                  .read<AuthBloc>()
                                  .add(GoogleSignInRequested());
                            },
                    ),

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
}
