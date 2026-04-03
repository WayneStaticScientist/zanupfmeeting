import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zanupfmeeting/core/utils/toaster_util.dart';
import 'package:zanupfmeeting/features/auth/controllers/auth_controller.dart';
// Assuming these paths remain the same based on your snippet
import 'package:zanupfmeeting/shared/widgets/m_textfield.dart';
import 'package:zanupfmeeting/shared/widgets/primary_button.dart';

class ScreenSignup extends StatefulWidget {
  const ScreenSignup({super.key});

  @override
  State<ScreenSignup> createState() => _ScreenSignupState();
}

class _ScreenSignupState extends State<ScreenSignup>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _authController = Get.find<AuthController>();
  bool _isPasswordVisible = false;

  // Controllers for new fields
  final _dobController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cityController = TextEditingController();
  late AnimationController _logoAnimationController;

  @override
  void initState() {
    super.initState();
    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _dobController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _idNumberController.dispose();
    _passwordController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 6570),
      ), // 18 years ago
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          // Background Decorative Gradients
          Positioned(
            top: -120,
            left: -60,
            child: _buildBlurCircle(colorScheme.primary.withAlpha(40), 300),
          ),
          Positioned(
            bottom: -100,
            right: -60,
            child: _buildBlurCircle(colorScheme.secondary.withAlpha(30), 250),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  // --- MODERN LOGO SPLASH ---
                  Center(child: _buildModernLogo(colorScheme)),

                  const SizedBox(height: 32),

                  // Header
                  Text(
                    "Create Account",
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colorScheme.onSurface,
                      letterSpacing: -1,
                    ),
                  ),
                  Text(
                    "Join the community today.",
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Name Row
                        Row(
                          children: [
                            Expanded(
                              child: MTextfield(
                                label: 'First Name',
                                controller: _firstNameController,
                                icon: Icons.person_outline,
                                colorScheme: colorScheme,
                                validator: (v) =>
                                    v!.isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MTextfield(
                                controller: _lastNameController,
                                label: 'Last Name',
                                icon: Icons.person_outline,
                                colorScheme: colorScheme,
                                validator: (v) =>
                                    v!.isEmpty ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        MTextfield(
                          controller: _emailController,
                          label: 'Email Address',
                          icon: Icons.alternate_email_rounded,
                          colorScheme: colorScheme,
                          validator: (v) =>
                              v!.contains('@') ? null : 'Invalid email',
                        ),
                        const SizedBox(height: 16),

                        MTextfield(
                          controller: _phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone_android_rounded,
                          colorScheme: colorScheme,
                          keyboardType: TextInputType.phone,
                          validator: (v) =>
                              v!.length < 9 ? 'Invalid phone' : null,
                        ),
                        const SizedBox(height: 16),
                        MTextfield(
                          controller: _cityController,
                          label: 'City',
                          icon: Icons.location_city,
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(height: 16),
                        MTextfield(
                          controller: _idNumberController,
                          label: 'National ID Number',
                          icon: Icons.badge_outlined,
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(height: 16),

                        // Date of Birth Field
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: MTextfield(
                              controller: _dobController,
                              label: 'Date of Birth',
                              icon: Icons.calendar_month_outlined,
                              colorScheme: colorScheme,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        MTextfield(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock_open_rounded,
                          isPassword: true,
                          isVisible: _isPasswordVisible,
                          colorScheme: colorScheme,
                          onSuffixIconPressed: () {
                            setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            );
                          },
                          validator: (v) => v!.length < 4 ? 'Too short' : null,
                        ),

                        const SizedBox(height: 32),

                        Obx(
                          () => PrimaryButton(
                            text: 'Sign Up',
                            isLoading: _authController.isLoading.value,
                            onPressed: _register,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Login"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
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

  Widget _buildBlurCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildModernLogo(ColorScheme colorScheme) {
    return SizedBox(
      width: 140,
      height: 140,
      child: AnimatedBuilder(
        animation: _logoAnimationController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer rotating ring
              Transform.rotate(
                angle: _logoAnimationController.value * 2 * 3.1415,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary.withAlpha(60),
                      width: 2,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              // Glassmorphism Center
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colorScheme.primary, colorScheme.primaryContainer],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withAlpha(100),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_mosaic_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),
              // Particle pulses
              ...List.generate(2, (i) {
                double progress =
                    (_logoAnimationController.value + (i * 0.5)) % 1.0;
                return Container(
                  width: 90 + (progress * 50),
                  height: 90 + (progress * 50),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary.withAlpha(
                        255 - (progress * 255).toInt(),
                      ),
                      width: 1,
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) {
      return Toaster.error('please fill in fields required');
    }
    await _authController.register(
      firstName: _firstNameController.text.replaceAll(" ", ''),
      lastName: _lastNameController.text.replaceAll(" ", ''),
      email: _emailController.text,
      phone: _phoneController.text,
      idNumber: _idNumberController.text,
      dob: _dobController.text,
      city: _cityController.text,
      password: _passwordController.text,
    );
  }
}
