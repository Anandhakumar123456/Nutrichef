import 'package:recipe/utils/export.dart';

class CustomStepper extends StatelessWidget {
  final int currentPage;
  final int totalSteps;
  final ValueChanged<int> onStepChanged;

  const CustomStepper({
    super.key,
    required this.currentPage,
    required this.totalSteps,
    required this.onStepChanged,
  });

  @override
  Widget build(BuildContext context) {
    List<int> list = List.generate(totalSteps, (index) => index);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.maxFinite,
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: FlutterStepIndicator(
                height: 28,
                paddingLine: const EdgeInsets.symmetric(horizontal: 0),
                positiveColor: const Color(0xFF00B551),
                progressColor: const Color(0xFFEA9C00),
                negativeColor: const Color(0xFFD5D5D5),
                padding: const EdgeInsets.all(4),
                list: list,
                division: totalSteps,
                page: currentPage,
                onClickItem: onStepChanged, // <- changes current step!
                onChange: (i) {}, // you can remove this or leave empty
              ),
            ),
          ),
        ],
      ),
    );
  }
}
