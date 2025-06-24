import 'package:flutter/material.dart';
import 'package:recipe/utils/root.dart';
import 'package:recipe/utils/widgets.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textBold("Reset Password", 32),
              SizedBox(height: 10),
              textRegular(
                "Enter your email to receive a password reset link.",
                16,
              ),
              SizedBox(height: 40),
              textBold("Email", 17),
              SizedBox(height: 8),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 30),
              primaryButton("Send Reset Link", () {
                if (emailController.text.isEmpty) {
                  showErrorSnackBar(context, "Email is required.");
                  return;
                }
                showSuccessSnackBar(context, "Reset link sent successfully.");
              }, false),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: textBold("Back to Sign in", 14, color: orange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
