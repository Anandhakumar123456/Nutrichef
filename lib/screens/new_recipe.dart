import 'package:recipe/utils/export.dart';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final picker = ImagePicker();
  XFile? image;
  File? selectedImage;
  final recipController = TextEditingController();
  final descController = TextEditingController();
  List<Map<String, TextEditingController>> ingredients = [];
  List<TextEditingController> instructions = [];
  XFile? video;
  File? _videoFile;
  VideoPlayerController? _controller;
  int _currentStep = 0;
  GlobalKey<FormState> firstPageformKey = GlobalKey();
  GlobalKey<FormState> secondPageformKey = GlobalKey();
  GlobalKey<FormState> thirdPageformKey = GlobalKey();
  GlobalKey<FormState> fourthPageformKey = GlobalKey();
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  final TextEditingController esttimeController = TextEditingController();

  Future<void> insertRecipeToGlobalCollection(String userId) async {
    try {
      final recipeDoc = FirebaseFirestore.instance.collection('recipes').doc();
      final recipeId = recipeDoc.id;
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId);

      final userSnapshot = await userDoc.get();
      final username = userSnapshot.data()?['username'] ?? 'Unknown';

      if (!userSnapshot.exists) {
        throw Exception('User does not exist.');
      }
      print('$username >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');

      final recipeData = {
        'userId': userId,
        'recipeId': recipeId,
        'username': username,
        'name': recipController.text,
        'description': descController.text,
        'imageUrl': 'https://example.com/static-image.jpg',
        'videoUrl': 'https://example.com/static-video.mp4',
        'nutritions': {
          'carbs': carbsController.text,
          'protein': proteinController.text,
          'calories': caloriesController.text,
          'fat': fatController.text,
        },
        'estimatedtime': esttimeController.text,
        'issaved': false,
        'ratings': "0.0",
        'uploadedby': userId,
        'ingredients':
            ingredients
                .map(
                  (ingredient) => {
                    'name': ingredient['name']?.text ?? '',
                    'quantity': ingredient['quantity']?.text ?? '',
                  },
                )
                .toList(),
        'instructions': instructions.map((i) => i?.text ?? '').toList(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('recipes').add(recipeData);

      print('Recipe added to allRecipes collection successfully!');
    } catch (e) {
      print('Error storing recipe in global collection: $e');
    }
  }

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
    final List<Widget> _pages = [
      firstPage(),
      secondPage(),
      thirdPage(),
      fourthPage(),
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
                  onPressed: () async {
                    bool isValid = false;

                    switch (_currentStep) {
                      case 0:
                        isValid =
                            firstPageformKey.currentState?.validate() ?? false;

                        break;

                      case 1:
                        isValid =
                            secondPageformKey.currentState?.validate() ?? false;

                        break;

                      case 2:
                        isValid =
                            thirdPageformKey.currentState?.validate() ?? false;

                        break;

                      case 3:
                        final userId = FirebaseAuth.instance.currentUser?.uid;
                        // print("User Name >>>>>>>>>>>>>>>>>>>>>>>>>>$userId");
                        isValid =
                            fourthPageformKey.currentState?.validate() ?? false;
                        if (isValid) {
                          if (userId != null) {
                            await insertRecipeToGlobalCollection(userId);
                          } else {
                            print('User not authenticated');
                          }
                        }
                        break;
                    }

                    if (isValid) {
                      if (_currentStep < _pages.length - 1) {
                        _nextStep();
                      } else {
                        showSuccessSnackBar(
                          context,
                          'Recipe submitted successfully!',
                        );
                        Navigator.pop(context);
                      }
                    } else {
                      // Optional: show a snackbar
                      showErrorSnackBar(
                        context,
                        'Please complete the required fields',
                      );
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

  Widget firstPage() {
    Future<void> pickImage() async {
      print("Picking image...");
      image = await picker.pickImage(source: ImageSource.gallery);
      print("${image!.path} >>>>>>>>>>>>>>>>>>>>>>");
      if (image != null) {
        setState(() {
          selectedImage = File(image!.path);
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Form(
          key: firstPageformKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: requestStoragePermission,
                  child:
                      selectedImage == null
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
                              selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 250,
                            ),
                          ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
            ],
          ),
        ),
      ],
    );
  }

  void addIngredient() {
    setState(() {
      ingredients.add({
        'name': TextEditingController(),
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
        InkWell(
          onTap: () {},
          child:
              selectedImage == null
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
                          Icon(Icons.upload_file, size: 40, color: Colors.grey),
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
                      selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 250,
                    ),
                  ),
        ),
        SizedBox(height: 20),
        textBold("Nutritional Information", 17),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: carbsController,
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
              child: TextFormField(
                controller: proteinController,
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
              child: TextFormField(
                controller: caloriesController,
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
              child: TextFormField(
                controller: fatController,
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
                  child: TextFormField(
                    controller: map['name'],
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
                  child: TextFormField(
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
                    textRegular("Add ingredients", 14, color: grey3),
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
        }),

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
                    textRegular("Add instruction", 14, color: grey),
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

  Widget secondPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Form(
          key: secondPageformKey,
          child: Column(
            children: [buildIngredientFields(), buildInstructions()],
          ),
        ),
      ),
    );
  }

  Widget thirdPage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Form(
          key: thirdPageformKey,
          child: Column(
            children: [
              InkWell(
                onTap: () {},
                child:
                    selectedImage == null
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
                            selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 250,
                          ),
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
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: textBold("Estimated Time", 17),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: esttimeController,
                decoration: InputDecoration(
                  hintText: 'Enter estimated time',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fourthPage() {
    String carbs = carbsController.text.trim();
    String protein = proteinController.text.trim();
    String calories = caloriesController.text.trim();
    String fat = fatController.text.trim();
    String esttime = esttimeController.text.trim();

    print(
      'Carbs: $carbs, Protein: $protein, Calories: $calories, Fat: $fat, Estimated Time : $esttime',
    );

    return Padding(
      padding: EdgeInsetsGeometry.all(20),
      child: SingleChildScrollView(
        child: Form(
          key: fourthPageformKey,
          child: Column(
            children: [
              InkWell(
                onTap: () {},
                child:
                    selectedImage == null
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
                            selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 250,
                          ),
                        ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      buildNutrientItem(
                        "assets/icons/wheat.png",
                        "$carbs g Carbs",
                      ),
                      SizedBox(height: 24),
                      buildNutrientItem(
                        "assets/icons/fire.png",
                        " $calories g Kcal",
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      buildNutrientItem(
                        "assets/icons/meat.png",
                        " $protein g Protein",
                      ),
                      SizedBox(height: 24),
                      buildNutrientItem("assets/icons/fat.png", " $fat g Fat"),
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
                      textBold(recipController.text.trim(), 18),
                      SizedBox(height: 10),
                      textRegular("Estimated Time", 14, color: grey3),
                      textBold("$esttime minutes", 16),
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
                      ...ingredients.map((ingredient) {
                        final name = ingredient['name']?.text ?? '';
                        final quantity = ingredient['quantity']?.text ?? '';

                        return Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                textRegular(name, 12),
                                textBold(quantity, 12),
                              ],
                            ),
                          ),
                        );
                      }),
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
                      ...List.generate(instructions.length, (index) {
                        final instruction = instructions[index].text;

                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: textRegular(
                              '${index + 1}. $instruction',
                              12,
                            ),
                          ),
                        );
                      }),
                    ],
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
