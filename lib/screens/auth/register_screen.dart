import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:maji_freshi/services/auth_service.dart';
import 'package:maji_freshi/utils/app_colors.dart';
import 'package:maji_freshi/screens/auth/login_screen.dart';
import 'package:maji_freshi/screens/auth/otp_screen.dart';
import 'package:maji_freshi/widgets/primary_button.dart';
import 'package:maji_freshi/screens/home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _phoneNumber = '';
  bool _isLoading = false;

  void _handleSignUp() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name')),
      );
      return;
    }
    if (_phoneNumber.isEmpty || _phoneNumber.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        onCodeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                verificationId: verificationId,
                phoneNumber: _phoneNumber,
                name: _nameController.text.trim(),
                email: _emailController.text.trim(),
              ),
            ),
          );
        },
        onVerificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification Failed: ${e.message}')),
          );
        },
        onCodeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _handleGoogleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential != null && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign-In Failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Maji Fresh',
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sign up to start ordering fresh water directly to your doorstep.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Full Name',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'John Doe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Phone Number',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            IntlPhoneField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              initialCountryCode: 'KE',
              onChanged: (phone) {
                _phoneNumber = phone.completeNumber;
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Email Address',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Optional',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'john@example.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 40),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      PrimaryButton(
                        text: 'Sign Up',
                        onPressed: _handleSignUp,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: const [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text("OR",
                                style: TextStyle(color: Colors.grey)),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: _handleGoogleLogin,
                        icon: Image.asset(
                          'assets/images/google_logo.png', // Ensure you have this asset or use an Icon
                          height: 24,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.g_mobiledata, size: 24),
                        ),
                        label: const Text(
                          'Sign up with Google',
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: Colors.grey),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'By signing up, you agree to our Terms of Service and Privacy Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
