// ignore_for_file: library_prefixes, no_leading_underscores_for_local_identifiers, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe/utils/root.dart';
import 'package:recipe/utils/stepper.dart';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  int _currentStep = 0;

  void _nextStep() {
    // if (image != null) {
    //   setState(() {
    //     _selectedImage = image;
    //     _currentStep++;
    //   });
    // } else if (_currentStep < 2) {
    //   setState(() {
    //     _currentStep++;
    //   });
    // }
    setState(() {
      _currentStep++;
    });
  }

  // void _previousStep() {
  //   if (_currentStep > 0) {
  //     setState(() {
  //       _currentStep--;
  //     });
  //   }
  // }

  void _setStep(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      FirstPage(),
      SecondPage(),
      ThirdPage(),
      FourthPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Recipe",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomStepper(
              currentPage: _currentStep,
              totalSteps: _pages.length,
              onStepChanged: _setStep,
            ),
            Expanded(child: _pages[_currentStep]),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_currentStep < _pages.length - 1) {
                      print("Current Step: $_currentStep");
                      _nextStep();
                    } else {
                      // Handle final submission logic here
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    _currentStep == 3 ? "Finish" : "Next",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
