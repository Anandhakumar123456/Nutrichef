// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/auth/auth_services.dart';
import 'package:recipe/screens/home.dart';
import 'package:recipe/screens/auth/signin.dart';
import 'package:recipe/utils/root.dart';
import 'package:recipe/utils/widgets.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void signUp() async {
    try {
      await authService.value.signUp(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      print("SignUp failed >>>>>>>>>>>>>. Reason: ${e.message}");
    }
  }

  @override
  void initState() {
    super.initState();

    passwordController.addListener(() {
      setState(() {});
    });
    confirmPasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Create an account row
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 70,
                      horizontal: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textBold('Create an account', 38),
                        SizedBox(height: 10),
                        textRegular(
                          "Let’s help you set up your account, it won’t take long.",
                          18,
                        ),
                        SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textBold("Email", 17),
                              SizedBox(height: 8),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your email";
                                  }
                                  if (!RegExp(
                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                                  ).hasMatch(value)) {
                                    return "Please enter a valid email address";
                                  }
                                  return null;
                                },
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              textBold("Password", 17),
                              SizedBox(height: 8),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your password";
                                  }
                                  if (value.length < 6) {
                                    return "Password must be at least 6 characters";
                                  }
                                  return null;
                                },
                                controller: passwordController,
                                obscureText: _obscurePassword,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  suffixIcon:
                                      passwordController.text.isNotEmpty
                                          ? IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword =
                                                    !_obscurePassword;
                                              });
                                            },
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                          )
                                          : null,
                                  hintText: "Password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              textBold("Confirm Password", 17),
                              SizedBox(height: 8),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please confirm your password";
                                  }
                                  if (value != passwordController.text) {
                                    return "Passwords do not match";
                                  }
                                  return null;
                                },
                                controller: confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  suffixIcon:
                                      confirmPasswordController.text.isNotEmpty
                                          ? IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _obscureConfirmPassword =
                                                    !_obscureConfirmPassword;
                                              });
                                            },
                                            icon: Icon(
                                              _obscureConfirmPassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                          )
                                          : null,

                                  hintText: "Confirm Password",

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 40),
                              primaryButton('Sign Up', () {
                                if (_formKey.currentState!.validate()) {
                                  signUp();
                                }
                              }, true),
                            ],
                          ),
                        ),
                        SizedBox(height: 14),
                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 2,
                                endIndent: 9,
                                indent: 5,
                                color: Colors.grey,
                              ),
                            ),
                            textBold("Or Sign In With ", 15, color: grey),
                            Expanded(
                              child: Divider(
                                indent: 5,
                                thickness: 2,
                                endIndent: 1,
                                color: grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        // Social Login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                print("Signed is with Google Successfully");
                              },
                              child: Container(
                                height: 44,
                                width: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset("assets/google.png"),
                                ),
                              ),
                            ),
                            SizedBox(width: 25),
                            GestureDetector(
                              onTap: () {
                                print("Signed is with Facebook Successfully");
                              },
                              child: Container(
                                height: 44,
                                width: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset("assets/facebook.png"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        // Sign in redirection
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textBold("Already a member? ", 14),
                            GestureDetector(
                              onTap: () {
                                print("Clicked Successfully");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignInPage(),
                                  ),
                                );
                              },
                              child: textBold("Sign In", 14, color: orange),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
