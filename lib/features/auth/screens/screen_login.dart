import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:zanupfmeeting/core/utils/toaster_util.dart';
import 'package:zanupfmeeting/shared/widgets/m_textfield.dart';
import 'package:zanupfmeeting/shared/widgets/primary_button.dart';
import 'package:zanupfmeeting/features/auth/screens/screen_signup.dart';
import 'package:zanupfmeeting/features/auth/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _isPasswordVisible = false;
  final _authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _pingController;

  @override
  void initState() {
    super.initState();
    _pingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pingController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          // Background Decorative Elements
          Positioned(
            top: -100,
            right: -50,
            child: _buildCircle(
              colorScheme.primaryContainer.withAlpha(128),
              250,
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _buildCircle(
              colorScheme.secondaryContainer.withAlpha(128),
              200,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Animated Logo with Ping Effect (Layout-neutral)
                  Center(
                    child: SizedBox(
                      width: 200, // Fixed size to contain the expansion
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Ping Animation Rings - These now expand within the 200x200 box
                          ...List.generate(3, (index) {
                            return AnimatedBuilder(
                              animation: _pingController,
                              builder: (context, child) {
                                double progress =
                                    (_pingController.value + (index / 3)) % 1.0;
                                return Container(
                                  width: 80 + (progress * 100),
                                  height: 80 + (progress * 100),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colorScheme.primary.withAlpha(
                                        255 - (progress * 255).toInt(),
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                          // Actual Logo Container
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withAlpha(100),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.groups_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Title Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ZanuPF Meeting",
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Connect with your team instantly.',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Login Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        MTextfield(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email address';
                            }
                            return null;
                          },
                          label: 'Email Address',
                          keyboardType: TextInputType.emailAddress,
                          icon: Icons.email_outlined,
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(height: 20),

                        MTextfield(
                          controller: _passwordController,
                          label: 'Password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          icon: Icons.lock_outline,
                          isPassword: true,
                          isVisible: _isPasswordVisible,
                          colorScheme: colorScheme,
                          onSuffixIconPressed: () {
                            setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            );
                          },
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('Forgot Password?'),
                          ),
                        ),

                        Obx(
                          () => PrimaryButton(
                            text: 'Login',
                            isLoading: _authController.isLoading.value,
                            onPressed: _login,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () =>
                                  Get.to(() => const ScreenSignup()),
                              child: const Text(
                                'Register Now',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) {
      return Toaster.error("Please fill all the fields");
    }
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;
    await _authController.login(email: email, password: password);
  }
}
