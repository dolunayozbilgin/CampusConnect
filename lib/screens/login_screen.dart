import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import 'event_feed_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Please enter your university email';
    }
    if (!email.contains('@') || !email.endsWith('.edu')) {
      return 'Use a valid university email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  void _openFeed() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const EventFeedScreen()),
      (route) => false,
    );
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Welcome back!'),
        content: Text('Logged in as ${_emailController.text.trim()}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _openFeed();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App header
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 32),

                // Brand: logo tile + app name
                Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'CampusConnect',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Title + subtitle
                const Text(
                  'Your campus,\nconnected.',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Discover events and meet students who share your interests.',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Email
                const Text(
                  'University email',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'you@university.edu',
                    suffixIcon: Icon(Icons.mail_outline, size: 20),
                  ),
                ),

                const SizedBox(height: 20),

                // Password
                const Text(
                  'Password',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: _validatePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Forgot password (left aligned)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {},
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Log in button with arrow icon
                FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('Log in'),
                ),
                const SizedBox(height: 20),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'New to CampusConnect?',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
