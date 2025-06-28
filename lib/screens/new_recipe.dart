import 'package:recipe/utils/export.dart';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final GlobalKey<FormState> firstPageformKey = GlobalKey();
  final GlobalKey<FormState> secondPageformKey = GlobalKey();
  final GlobalKey<FormState> thirdPageformKey = GlobalKey();
  final GlobalKey<FormState> fourthPageformKey = GlobalKey();
  int _currentStep = 0;

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }

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
      appBar: AppBar(title: textBold("Create Recipe", 24)),
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
                  child: textBold(
                    _currentStep == 3 ? "Finish" : "Next",
                    20,
                    color: whiteColor,
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
