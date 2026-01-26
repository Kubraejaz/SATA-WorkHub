import 'package:flutter/material.dart';
import 'auth_controller.dart';
import '../dashboards/admin_dashboard.dart';
import '../dashboards/manager_dashboard.dart';
import '../dashboards/employee_dashboard.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final error = await AuthController.instance.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (error != null) {
        _showSnackBar(error, isError: true);
        return;
      }

      // 🔐 EMAIL VERIFICATION CHECK
      if (!AuthController.instance.isEmailVerified()) {
        await AuthController.instance.logout();
        _showSnackBar(
          'Please verify your email before logging in.',
          isError: true,
        );
        return;
      }

      final role = await AuthController.instance.getRole();
      if (!mounted) return;

      Widget destination;
      switch (role) {
        case 1:
          destination = const AdminDashboard();
          break;
        case 2:
          destination = const ManagerDashboard();
          break;
        default:
          destination = const EmployeeDashboard();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => destination),
      );
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),

                // Logo
                 Container( width: 100, height: 100, decoration: BoxDecoration( gradient: const LinearGradient( colors: [Color(0xFF1976D2), Color(0xFF0D47A1)], begin: Alignment.topLeft, end: Alignment.bottomRight, ), borderRadius: BorderRadius.circular(24), boxShadow: [ BoxShadow( color: const Color(0xFF1976D2).withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 10), ), ], ), child: const Icon( Icons.work_outline_rounded, size: 50, color: Colors.white, ), ), const SizedBox(height: 24), 
                 // App Name
                  RichText( text: const TextSpan( children: [ TextSpan( text: 'SATA ', style: TextStyle( fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1976D2), ), ), TextSpan( text: 'WorkHub', style: TextStyle( fontSize: 28, fontWeight: FontWeight.w400, color: Color(0xFF6B7280), ), ), ], ), ), const SizedBox(height: 8), Text( 'Welcome back', style: TextStyle( fontSize: 15, color: Colors.grey[600], ), ),

                  const SizedBox(height: 32),

                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration('Email', Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        v == null || !v.contains('@') ? 'Enter valid email' : null,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: _passwordDecoration(),
                    validator: (v) =>
                        v == null || v.length < 6 ? 'Min 6 characters' : null,
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Sign In',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don’t have an account? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color(0xFF1976D2),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  InputDecoration _passwordDecoration() {
    return InputDecoration(
      labelText: 'Password',
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(_obscurePassword
            ? Icons.visibility_off
            : Icons.visibility),
        onPressed: () =>
            setState(() => _obscurePassword = !_obscurePassword),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }
}
