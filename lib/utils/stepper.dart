import 'package:recipe/utils/export.dart';

String _imageFile = 'assets/1.png';
List recipeData = [
  {
    'username': "username",
    'title': "title",
    'description': "description",
    'imageUrl': ' ',
    'videoUrl': ' ',
    'nutrition': {
      'carbs': '75g',
      'proties': '45g',
      'kacl': '45g',
      'fat': '65g',
    },
    'ingredients': [
      {'name': 'Tomato', 'quantity': '2'},
      {'name': 'Salt', 'quantity': '1 tsp'},
    ],
    'steps': ['Boil pasta.', 'Add tomato sauce.', 'Mix well and serve.'],
    'estimatedTime': ' ',
  },
];

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

class FirstPage extends StatefulWidget {
  final File? imageFile;
  const FirstPage({super.key, this.imageFile});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final picker = ImagePicker();
  XFile? image;
  File? _imageFile;
  final recipController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    // Dispose of any controllers or resources here
    recipController.dispose();
    descController.dispose();
  }

  Future<void> pickImage() async {
    print("Picking image...");
    image = await picker.pickImage(source: ImageSource.gallery);
    print("${image!.path} >>>>>>>>>>>>>>>>>>>>>>");
    if (image != null) {
      setState(() {
        _imageFile = File(image!.path);
      });
    }
  }

  Future<void> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted ||
        await Permission.photos.request().isGranted) {
      // Permission granted
      pickImage();
    } else {
      // Permission denied
      showErrorSnackBar(context, 'Storage permission denied.');
      print('Storage permission denied.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: requestStoragePermission,
                child:
                    _imageFile == null
                        ? DottedBorder(
                          options: RectDottedBorderOptions(
                            color: Colors.grey,
                            strokeWidth: 1,
                            dashPattern: [6, 3],
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 250,
                            padding: EdgeInsets.all(12),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload_file,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10),
                                textBold("Upload Image", 16),
                                textRegular(
                                  "(You can upload up to 5 images)",
                                  12,
                                  color: grey,
                                ),
                              ],
                            ),
                          ),
                        )
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 250,
                          ),
                        ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    textBold("Recipe Name", 17),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: recipController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter recipe name";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Recipe Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    textBold("Description", 17),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: descController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter recipe details";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Enter the detail of your recipe",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child: SizedBox(
        //     width: double.infinity,
        //     child: ElevatedButton(
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: primaryColor,
        //         padding: EdgeInsets.symmetric(vertical: 16),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //       ),
        //       onPressed: () {
        //         if (_formKey.currentState?.validate() ?? false) {
        //           // Handle form submission
        //           print("Recipe Name: ${recipController.text}");
        //           print("Description: ${descController.text}");
        //           if (_imageFile != null) {
        //             print("Image Path: ${_imageFile!.path}");
        //           } else {
        //             print("No image selected");
        //           }
        //           // Navigate to the next step or save the recipe
        //         } else {
        //           // Show validation errors
        //           ScaffoldMessenger.of(context).showSnackBar(
        //             SnackBar(content: Text('Please fill all fields')),
        //           );
        //         }
        //       },
        //       child: Text(
        //         "Continue",
        //         style: GoogleFonts.poppins(
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold,
        //           color: Colors.white,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<Map<String, TextEditingController>> ingredients = [];
  List<TextEditingController> instructions = [];
  String _imageFile = 'assets/1.png'; // Placeholder for image file

  @override
  void initState() {
    super.initState();
    addIngredient(); // Start with one
    addInstruction(); // Start with one
  }

  void addIngredient() {
    setState(() {
      ingredients.add({
        'ingredient': TextEditingController(),
        'quantity': TextEditingController(),
      });
    });
  }

  void addInstruction() {
    setState(() {
      instructions.add(TextEditingController());
    });
  }

  Widget buildIngredientFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            _imageFile,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 250,
          ),
        ),
        SizedBox(height: 20),
        Text(
          "Nutritional Information",
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  icon: Image.asset('assets/icons/wheat.png'),
                  hintText: 'Enter carbs ',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                onSubmitted: (value) {
                  if (value.isEmpty) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Enter protein')));
                  }
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  icon: Image.asset('assets/icons/meat.png'),
                  hintText: 'Enter protein',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  icon: Image.asset('assets/icons/fire.png'),
                  hintText: 'Enter kalories',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                onSubmitted: (value) {
                  if (value.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a quantity')),
                    );
                  }
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  icon: Image.asset('assets/icons/fat.png'),
                  hintText: 'Enter fat',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24),

        textBold("Ingerdients", 17),
        const SizedBox(height: 10),
        ...ingredients.map((map) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: map['ingredient'],
                    decoration: InputDecoration(
                      hintText: 'Enter an ingredient',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onSubmitted: (value) {
                      if (value.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter a quantity')),
                        );
                      }
                    },
                    keyboardType: TextInputType.text,
                    controller: map['quantity'],
                    decoration: InputDecoration(
                      hintText: 'Quantity',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        GestureDetector(
          onTap: addIngredient,
          child: DottedBorder(
            options: RectDottedBorderOptions(
              color: Colors.grey,
              strokeWidth: 1,
              dashPattern: [6, 3],
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: grey3),
                    const SizedBox(width: 8),
                    textRegular("Add new ingredients", 14, color: grey3),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [textBold("How To", 17)],
        ),
        const SizedBox(height: 10),
        ...instructions.map((controller) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                textBold("${instructions.indexOf(controller) + 1}. ", 16),
                const SizedBox(width: 5),
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter instructions';";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter instructions',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),

        const SizedBox(height: 10),
        GestureDetector(
          onTap: addInstruction,
          child: DottedBorder(
            options: RectDottedBorderOptions(
              color: Colors.grey,
              strokeWidth: 1,
              dashPattern: [6, 3],
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: grey3),
                    SizedBox(width: 8),
                    textRegular("Add new instruction", 14, color: grey),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [buildIngredientFields(), buildInstructions()]),
      ),
    );
  }
}

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  final picker = ImagePicker();
  XFile? video;
  File? _videoFile;
  VideoPlayerController? _controller;

  Future<void> pickVideo() async {
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      _videoFile = File(pickedVideo.path);
      _controller = VideoPlayerController.file(_videoFile!)
        ..initialize().then((_) {
          setState(() {});
          _controller!.setLooping(false);
        });
    }
  }

  void _togglePlayPause() {
    if (_controller != null && _controller!.value.isInitialized) {
      setState(() {
        _controller!.value.isPlaying
            ? _controller!.pause()
            : _controller!.play();
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                _imageFile,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250,
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: textBold("Video", 17),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: pickVideo,
              child:
                  _videoFile == null
                      ? DottedBorder(
                        options: RectDottedBorderOptions(
                          color: Colors.grey,
                          strokeWidth: 1,
                          dashPattern: [6, 3],
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 250,
                          padding: EdgeInsets.all(12),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.video_call,
                                size: 40,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 10),
                              textBold("Upload Video", 16),
                              textRegular(
                                "(Your video size limit is 700 MB)",
                                12,
                                color: grey,
                              ),
                            ],
                          ),
                        ),
                      )
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 250,
                              width: double.infinity,
                              child:
                                  _controller != null &&
                                          _controller!.value.isInitialized
                                      ? VideoPlayer(_controller!)
                                      : const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                            ),
                            if (_controller != null &&
                                _controller!.value.isInitialized)
                              Positioned(
                                child: IconButton(
                                  icon: Icon(
                                    _controller!.value.isPlaying
                                        ? Icons.pause_circle_outline
                                        : Icons.play_circle_outline,
                                    size: 50,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  onPressed: _togglePlayPause,
                                ),
                              ),
                          ],
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class FourthPage extends StatefulWidget {
  const FourthPage({super.key});

  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                _imageFile,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    buildNutrientItem("assets/icons/wheat.png", "65g Carbs"),
                    SizedBox(height: 24),
                    buildNutrientItem("assets/icons/fire.png", " 345g Kcal"),
                  ],
                ),
                Column(
                  children: [
                    buildNutrientItem("assets/icons/meat.png", " 26g Protein"),
                    SizedBox(height: 24),
                    buildNutrientItem("assets/icons/fat.png", " 12g Fat"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textRegular("Recipe Name", 14, color: grey3),
                    textBold("Chicken Ramen", 18),
                    SizedBox(height: 10),
                    textRegular("Estimated Time", 14, color: grey3),
                    textBold("45 minutes", 16),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textBold("Ingredients", 18),
                    SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.4),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textRegular("Chicken broth", 12),
                            textBold("8 cups", 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textBold("How to prepare", 18),
                    SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.4),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: textRegular(
                          "1. In a large pot, bring the chicken broth to a boil.",
                          12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
