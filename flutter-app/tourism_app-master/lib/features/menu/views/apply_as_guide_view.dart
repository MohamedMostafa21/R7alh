import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourism_app/core/component/app_bar_sharred.dart';
import 'package:tourism_app/core/component/custom_text_form_field.dart';
import 'package:tourism_app/core/component/buttons/custom_text_button.dart';
import 'package:tourism_app/features/menu/manager/cubit/apply_guide_cubit.dart';
import 'package:tourism_app/features/menu/data/models/applied_as_toure_guide.dart';

class ApplyAsGuideView extends StatefulWidget {
  const ApplyAsGuideView({super.key});

  @override
  State<ApplyAsGuideView> createState() => _ApplyAsGuideViewState();
}

class _ApplyAsGuideViewState extends State<ApplyAsGuideView> {
  final _formKey = GlobalKey<FormState>();

  // Available languages list
  final List<String> availableLanguages = [
    'English',
    'Arabic',
    'French',
    'German',
    'Spanish',
    'Italian',
    'Chinese',
    'Japanese',
    'Russian',
    'Portuguese'
  ];

  @override
  void initState() {
    super.initState();
    // Check if user already has an application
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ApplyGuideCubit.of(context).getApplicationStatus(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: shareAppBar(
        context,
        nameAppBar: 'Apply as Tour Guide',
      ),
      body: BlocConsumer<ApplyGuideCubit, ApplyGuideState>(
        listener: (context, state) {
          if (state is ApplyGuideSuccess) {
            _showSuccessDialog();
          } else if (state is ApplyGuideError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.e,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red[600],
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ApplyGuideStatusLoading) {
            return _buildLoadingView();
          } else if (state is ApplyGuideStatusSuccess) {
            return _buildApplicationStatusView(state.application);
          } else {
            return _buildApplicationForm(state);
          }
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
            strokeWidth: 2.5,
          ),
          const SizedBox(height: 16),
          Text(
            'Checking application status...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationStatusView(AppliedAsTourguideModel application) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _getStatusColor(application.status).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getStatusColor(application.status).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  _getStatusIcon(application.status),
                  size: 40,
                  color: _getStatusColor(application.status),
                ),
                const SizedBox(height: 12),
                Text(
                  _getStatusText(application.status),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(application.status),
                  ),
                ),
                if (application.adminComment != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    application.adminComment!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Application Details
          _buildInfoSection(
            'Application Details',
            [
              _buildInfoRow('Name', application.userName ?? 'N/A'),
              _buildInfoRow('Email', application.email ?? 'N/A'),
              _buildInfoRow('Years of Experience', '${application.yearsOfExperience ?? 0} years'),
              _buildInfoRow('Hourly Rate', '\$${application.hourlyRate ?? 0}/hour'),
              _buildInfoRow('Languages', application.languages?.join(', ') ?? 'N/A'),
              _buildInfoRow('Submitted', _formatDate(application.submittedAt)),
              if (application.reviewedAt != null) _buildInfoRow('Reviewed', _formatDate(application.reviewedAt)),
            ],
          ),

          const SizedBox(height: 16),

          // Bio Section
          if (application.bio != null && application.bio!.isNotEmpty)
            _buildInfoSection(
              'Bio',
              [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    application.bio!,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 20),

          // Action Button
          if (application.status == 2) // Rejected status
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Reset state and show form again
                  setState(() {});
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text(
                  'Submit New Application',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildApplicationForm(ApplyGuideState state) {
    final cubit = ApplyGuideCubit.of(context);
    final isLoading = state is ApplyGuideLoading;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.person_add_outlined,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Become a Tour Guide',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Share your knowledge and passion for tourism with travelers from around the world.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Professional Information Section
            _buildFormSection(
              'Professional Information',
              [
                CustomTextFormField(
                  controller: cubit.yearsExperienceController,
                  labelStringText: 'Years of Experience',
                  hintText: 'Enter years of experience in tourism',
                  prefixIcon: const Icon(Icons.work_outline, size: 20),
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 14),
                CustomTextFormField(
                  controller: cubit.hourlyRateController,
                  labelStringText: 'Hourly Rate (USD)',
                  hintText: 'Enter your hourly rate',
                  prefixIcon: const Icon(Icons.attach_money, size: 20),
                  textInputType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Languages Section
            _buildFormSection(
              'Languages',
              [
                Text(
                  'Select languages you speak fluently:',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<ApplyGuideCubit, ApplyGuideState>(
                  builder: (context, state) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableLanguages.map((language) {
                        final isSelected = cubit.selectedLanguages.contains(language);
                        return FilterChip(
                          label: Text(
                            language,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              cubit.addLanguage(language);
                            } else {
                              cubit.removeLanguage(language);
                            }
                          },
                          selectedColor: Theme.of(context).primaryColor.withOpacity(0.15),
                          checkmarkColor: Theme.of(context).primaryColor,
                          backgroundColor: Colors.grey[100],
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.3) : Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                if (cubit.selectedLanguages.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Please select at least one language',
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Bio Section
            _buildFormSection(
              'About You',
              [
                CustomTextFormField(
                  controller: cubit.bioController,
                  labelStringText: 'Bio',
                  hintText: 'Tell us about yourself, your experience, and what makes you a great tour guide...',
                  maxLines: 4,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // File Uploads Section
            _buildFormSection(
              'Documents',
              [
                _buildFileUploadCard(
                  'CV/Resume',
                  'Upload your CV or resume',
                  Icons.description_outlined,
                  cubit.cvFilePath,
                  () => _showFileUploadDialog('CV'),
                ),
                const SizedBox(height: 10),
                _buildFileUploadCard(
                  'Profile Picture',
                  'Upload a professional profile picture',
                  Icons.photo_camera_outlined,
                  cubit.profilePicturePath,
                  () => _showFileUploadDialog('Profile Picture'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                width: double.infinity,
                child: BlocBuilder<ApplyGuideCubit, ApplyGuideState>(
                  builder: (context, state) {
                    return CustomTextButton(
                      onPress: isLoading ? null : _submitApplication,
                      child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Submitting Application...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )
                          : const Text(
                              'Submit Application',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileUploadCard(
    String title,
    String subtitle,
    IconData icon,
    String? filePath,
    VoidCallback onTap,
  ) {
    final hasFile = filePath != null && filePath.isNotEmpty;
    final fileName = hasFile ? _getFileNameFromPath(filePath) : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: hasFile ? Colors.green[300]! : Colors.grey[300]!,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: hasFile ? Colors.green[50] : Colors.grey[50],
        ),
        child: Row(
          children: [
            Icon(
              hasFile ? Icons.check_circle : icon,
              color: hasFile ? Colors.green[600] : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: hasFile ? Colors.green[700] : Colors.grey[700],
                    ),
                  ),
                  Text(
                    hasFile ? 'Selected: ${fileName!.length > 25 ? '${fileName.substring(0, 25)}...' : fileName}' : subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: hasFile ? Colors.green[600] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              hasFile ? Icons.edit : Icons.upload_file,
              color: hasFile ? Colors.green[600] : Colors.grey[600],
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  String _getFileNameFromPath(String path) {
    return path.split('/').last;
  }

  void _submitApplication() {
    if (_formKey.currentState!.validate()) {
      final cubit = ApplyGuideCubit.of(context);
      final validationError = cubit.validateForm();

      if (validationError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              validationError,
              style: const TextStyle(fontSize: 13),
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
        return;
      }

      cubit.submitApplication(context: context);
    }
  }

  void _showFileUploadDialog(String fileType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Upload $fileType',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              fileType == 'CV' ? 'Choose how you want to upload your CV/Resume:' : 'Choose how you want to upload your profile picture:',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            if (fileType == 'CV') ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'PDF files are recommended for CV uploads',
                        style: TextStyle(fontSize: 11, color: Colors.blue[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickFile(fileType, 'camera'),
                    icon: const Icon(Icons.camera_alt, size: 18),
                    label: const Text(
                      'Camera',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickFile(fileType, 'gallery'),
                    icon: const Icon(Icons.photo_library, size: 18),
                    label: const Text(
                      'Gallery',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            if (fileType == 'CV') ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _pickFile(fileType, 'files'),
                  icon: const Icon(Icons.file_present, size: 18),
                  label: const Text(
                    'Browse Files',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  void _pickFile(String fileType, String source) async {
    Navigator.of(context).pop(); // Close dialog first

    final cubit = ApplyGuideCubit.of(context);
    String? filePath;
    String? fileName;

    try {
      if (fileType == 'CV') {
        // Pick PDF file for CV
        if (source == 'files') {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
            allowMultiple: false,
          );

          if (result != null && result.files.single.path != null) {
            filePath = result.files.single.path!;
            fileName = result.files.single.name;
          }
        } else {
          // For camera/gallery, we'll use image picker and suggest user to convert to PDF
          final ImagePicker picker = ImagePicker();
          XFile? image;

          if (source == 'camera') {
            image = await picker.pickImage(
              source: ImageSource.camera,
              imageQuality: 80,
            );
          } else if (source == 'gallery') {
            image = await picker.pickImage(
              source: ImageSource.gallery,
              imageQuality: 80,
            );
          }

          if (image != null) {
            filePath = image.path;
            fileName = image.name;

            // Show info that this is an image, suggest PDF for better results
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Image selected for CV. For best results, consider uploading a PDF file.',
                  style: TextStyle(fontSize: 13),
                ),
                backgroundColor: Colors.orange[600],
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      } else {
        // Pick image for profile picture
        final ImagePicker picker = ImagePicker();
        XFile? image;

        if (source == 'camera') {
          image = await picker.pickImage(
            source: ImageSource.camera,
            imageQuality: 80,
            maxWidth: 1024,
            maxHeight: 1024,
          );
        } else if (source == 'gallery') {
          image = await picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 80,
            maxWidth: 1024,
            maxHeight: 1024,
          );
        }

        if (image != null) {
          filePath = image.path;
          fileName = image.name;
        }
      }

      // If file was selected successfully
      if (filePath != null && fileName != null) {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Processing file...',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        );

        // Simulate processing delay
        await Future.delayed(const Duration(milliseconds: 800));

        // Close loading dialog
        Navigator.of(context).pop();

        // Set the file path in cubit
        if (fileType == 'CV') {
          cubit.setCvFile(filePath);
        } else {
          cubit.setProfilePicture(filePath);
        }

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$fileType selected: ${fileName.length > 30 ? '${fileName.substring(0, 30)}...' : fileName}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        // User cancelled file selection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'File selection cancelled',
              style: TextStyle(fontSize: 13),
            ),
            backgroundColor: Colors.grey[600],
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Handle any errors during file picking
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Error selecting file: ${e.toString()}',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 56,
            ),
            const SizedBox(height: 16),
            const Text(
              'Application Submitted!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your tour guide application has been submitted successfully. We will review it and get back to you soon.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to menu
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(num? status) {
    switch (status) {
      case 0: // Pending
        return Colors.orange;
      case 1: // Approved
        return Colors.green;
      case 2: // Rejected
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(num? status) {
    switch (status) {
      case 0: // Pending
        return Icons.schedule;
      case 1: // Approved
        return Icons.check_circle;
      case 2: // Rejected
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(num? status) {
    switch (status) {
      case 0: // Pending
        return 'Application Under Review';
      case 1: // Approved
        return 'Application Approved';
      case 2: // Rejected
        return 'Application Rejected';
      default:
        return 'Unknown Status';
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
