import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/features/bottomNavigationBar/presentation/widget/cusotm_bottom_navigation_bar.dart';
import 'package:tourism_app/features/home/data/models/ai_response_model.dart';
import 'package:tourism_app/features/home/manager/predictaimage/cubit/predict_image_with_ai_cubit.dart';
import 'package:tourism_app/features/home/presentation/all_plans_view.dart';
import 'package:tourism_app/features/home/presentation/home_view.dart';
import 'package:tourism_app/features/menu/views/menu_view.dart';
import 'package:tourism_app/features/tourguide/presentation/tourguide_view.dart';

class BottomNavigationBarView extends StatefulWidget {
  const BottomNavigationBarView({super.key});

  @override
  State<BottomNavigationBarView> createState() => _BottomNavigationBarViewState();
}

class _BottomNavigationBarViewState extends State<BottomNavigationBarView> {
  int selectedIndex = 0;
  final ImagePicker _picker = ImagePicker();

  void onNavBarItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    // Check if camera tab is selected (index 2)
    if (index == 2) {
      _openCamera();
    }
  }

  Future<void> _openCamera() async {
    // Reset AI prediction state when opening camera
    PredictImageWithAiCubit.of(context).emit(PredictImageWithAiInitial());

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 85,
      );

      if (photo != null) {
        // Handle the captured photo
        _showPhotoPreview(photo);
      } else {
        // User cancelled camera, go back to previous tab
        setState(() {
          selectedIndex = selectedIndex == 2 ? 0 : selectedIndex;
        });
      }
    } catch (e) {
      // Handle camera error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open camera: $e'),
          backgroundColor: Colors.red,
        ),
      );

      // Go back to home tab if camera fails
      setState(() {
        selectedIndex = 0;
      });
    }
  }

  void _showPhotoPreview(XFile photo) {
    // Reset AI prediction state to initial when opening new photo preview
    final cubit = PredictImageWithAiCubit.of(context);
    cubit.setImage(File(photo.path));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: PhotoPreviewWidget(
          photo: photo,
          onSave: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Photo saved successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // Return to home tab after saving
            setState(() {
              selectedIndex = 0;
            });
          },
          onRetake: () {
            Navigator.of(context).pop();
            _openCamera();
          },
          onCancel: () {
            Navigator.of(context).pop();
            // Return to home tab if cancelled
            setState(() {
              selectedIndex = 0;
            });
          },
          onPredictWithAI: () {
            // Trigger AI prediction (image already set when preview opened)
            cubit.predictImageWithAi(context: context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(child: navBarViews[selectedIndex]),
        ),
        Positioned(
          bottom: 10,
          left: 16,
          right: 16,
          child: CustomNavigationBarWidget(
            selectedIndex: selectedIndex,
            onItemSelected: onNavBarItemTapped,
          ),
        )
      ],
    );
  }
}

List<Widget> navBarViews = [
  HomeView(),
  TourGuideView(),
  CameraPlaceholderView(),
  AllPlansView(),
  MenuView(),
];

// Camera placeholder view for when camera tab is displayed
class CameraPlaceholderView extends StatelessWidget {
  const CameraPlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt,
            size: 100,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Camera Ready',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Opening camera...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }
}

// Photo preview widget with save, retake, cancel, and AI prediction options
class PhotoPreviewWidget extends StatelessWidget {
  final XFile photo;
  final VoidCallback onSave;
  final VoidCallback onRetake;
  final VoidCallback onCancel;
  final VoidCallback onPredictWithAI;

  const PhotoPreviewWidget({
    super.key,
    required this.photo,
    required this.onSave,
    required this.onRetake,
    required this.onCancel,
    required this.onPredictWithAI,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Photo Analysis',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Photo preview
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Image display
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(photo.path),
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 250,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.error_outline,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // AI Prediction Section
                  BlocBuilder<PredictImageWithAiCubit, PredictImageWithAiState>(
                    builder: (context, state) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.psychology,
                                  color: Theme.of(context).primaryColor,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'AI Analysis',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (state is PredictImageWithAiInitial) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.auto_awesome,
                                      size: 40,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Discover what\'s in your photo!',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Tap "Analyze with AI" to get intelligent insights',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ] else if (state is PredictImageWithAiLoading) ...[
                              _buildProfessionalLoadingAnimation(context),
                            ] else if (state is PredictImageWithAiSuccess && ConstantsModels.aiResonseModel != null) ...[
                              _buildAIResult(context, ConstantsModels.aiResonseModel!),
                            ] else if (state is PredictImageWithAIError) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 32,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Analysis Failed',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red[700],
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      state.e,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.red[600],
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton(
                                      onPressed: onPredictWithAI,
                                      child: Text('Try Again'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // AI Prediction Button
                BlocBuilder<PredictImageWithAiCubit, PredictImageWithAiState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: state is PredictImageWithAiLoading ? null : onPredictWithAI,
                        icon: state is PredictImageWithAiLoading
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.psychology),
                        label: Text(
                          state is PredictImageWithAiLoading ? 'Analyzing...' : 'Analyze with AI',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // Save and Retake buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onRetake,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Retake'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Theme.of(context).primaryColor),
                          foregroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onSave,
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Safe area bottom padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildProfessionalLoadingAnimation(BuildContext context) {
    return ProfessionalAILoadingWidget();
  }

  Widget _buildAIResult(BuildContext context, AiResonseModel result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.withOpacity(0.1),
            Colors.blue.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Analysis Complete!',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (result.name != null && result.name!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.label,
                        color: Theme.of(context).primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Detected Object:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    result.name!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (result.predictedCaption != null && result.predictedCaption!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description,
                        color: Theme.of(context).primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'AI Description:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    result.predictedCaption!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Professional AI Loading Animation Widget
class ProfessionalAILoadingWidget extends StatefulWidget {
  const ProfessionalAILoadingWidget({super.key});

  @override
  State<ProfessionalAILoadingWidget> createState() => _ProfessionalAILoadingWidgetState();
}

class _ProfessionalAILoadingWidgetState extends State<ProfessionalAILoadingWidget> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _fadeController;

  int currentStep = 0;
  late Timer _stepTimer;

  final List<Map<String, dynamic>> loadingSteps = [
    {
      'title': 'Preparing Image',
      'subtitle': 'Optimizing photo for analysis...',
      'icon': Icons.image_outlined,
      'color': Colors.blue,
    },
    {
      'title': 'AI Processing',
      'subtitle': 'Identifying objects and features...',
      'icon': Icons.psychology_outlined,
      'color': Colors.purple,
    },
    {
      'title': 'Generating Insights',
      'subtitle': 'Creating intelligent description...',
      'icon': Icons.auto_awesome_outlined,
      'color': Colors.orange,
    },
    {
      'title': 'Finalizing Results',
      'subtitle': 'Almost ready to show you the magic!',
      'icon': Icons.check_circle_outline,
      'color': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _startStepAnimation();
  }

  void _startStepAnimation() {
    _stepTimer = Timer.periodic(const Duration(milliseconds: 1200), (timer) {
      if (mounted) {
        setState(() {
          currentStep = (currentStep + 1) % loadingSteps.length;
        });
        _fadeController.reset();
        _fadeController.forward();
      }
    });
    _fadeController.forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    _stepTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStepData = loadingSteps[currentStep];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Animated AI Brain Icon
          AnimatedBuilder(
            animation: Listenable.merge([_rotationController, _scaleController]),
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_scaleController.value * 0.1),
                child: Transform.rotate(
                  angle: _rotationController.value * 2 * 3.14159,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          currentStepData['color'].withOpacity(0.3),
                          currentStepData['color'].withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: currentStepData['color'].withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.psychology,
                      size: 40,
                      color: currentStepData['color'],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Animated Progress Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(loadingSteps.length, (index) {
              return AnimatedBuilder(
                animation: _scaleController,
                builder: (context, child) {
                  final isActive = index == currentStep;
                  final scale = isActive ? 1.0 + (_scaleController.value * 0.3) : 1.0;

                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 12 : 8,
                      height: isActive ? 12 : 8,
                      decoration: BoxDecoration(
                        color: isActive ? currentStepData['color'] : Colors.grey[300],
                        shape: BoxShape.circle,
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: currentStepData['color'].withOpacity(0.4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          const SizedBox(height: 20),

          // Animated Step Information
          FadeTransition(
            opacity: _fadeController,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      currentStepData['icon'],
                      color: currentStepData['color'],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      currentStepData['title'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: currentStepData['color'],
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  currentStepData['subtitle'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Animated Progress Bar
          Container(
            width: double.infinity,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(2),
            ),
            child: AnimatedBuilder(
              animation: _scaleController,
              builder: (context, child) {
                final progress = (currentStep + 1) / loadingSteps.length;
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          currentStepData['color'],
                          currentStepData['color'].withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: currentStepData['color'].withOpacity(0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Progress Percentage
          AnimatedBuilder(
            animation: _fadeController,
            builder: (context, child) {
              final progress = ((currentStep + 1) / loadingSteps.length * 100).round();
              return Text(
                '$progress% Complete',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}
