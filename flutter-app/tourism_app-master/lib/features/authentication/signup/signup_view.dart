import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/features/authentication/login/login_view.dart';
import 'package:tourism_app/features/authentication/signup/manager/cubit/sign_up_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late SignUpCubit signUpCubit;

  @override
  void initState() {
    super.initState();
    signUpCubit = SignUpCubit();
  }

  @override
  void dispose() {
    signUpCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => signUpCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text(
            'Create Account',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1E293B),
          elevation: 0,
          centerTitle: true,
          shadowColor: Colors.black12,
        ),
        body: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              context.navigateToPage(LoginView());
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: const Text('Account created successfully!'),
              //     backgroundColor: Colors.green[600],
              //     behavior: SnackBarBehavior.floating,
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //   ),
              // );
            } else if (state is SignUpError) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text(state.e),
              //     backgroundColor: Colors.red[600],
              //     behavior: SnackBarBehavior.floating,
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //   ),
              // );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProfilePictureWidget(
                      profileImage: signUpCubit.profileImage,
                      onImageSelected: (image) => signUpCubit.updateProfileImage(image),
                    ),
                    const SizedBox(height: 32),
                    RequiredTextFieldWidget(
                      controller: signUpCubit.firstNameController,
                      label: 'First Name',
                      hintText: 'Enter your first name',
                      icon: Icons.person_outline,
                      validator: signUpCubit.validateFirstName,
                    ),
                    const SizedBox(height: 24),
                    OptionalTextFieldWidget(
                      controller: signUpCubit.lastNameController,
                      label: 'Last Name',
                      hintText: 'Enter your last name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 24),
                    EmailFieldWidget(
                      controller: signUpCubit.emailController,
                      validator: signUpCubit.validateEmail,
                    ),
                    const SizedBox(height: 24),
                    PasswordFieldWidget(
                      controller: signUpCubit.passwordController,
                      isPasswordVisible: signUpCubit.isPasswordVisible,
                      onVisibilityToggle: () => signUpCubit.togglePasswordVisibility(),
                      validator: signUpCubit.validatePassword,
                    ),
                    const SizedBox(height: 24),
                    DateOfBirthFieldWidget(
                      controller: signUpCubit.dateOfBirthController,
                      onDateSelected: (date) => signUpCubit.updateDateOfBirth(date),
                      //   validator: signUpCubit.validateDateOfBirth,
                    ),
                    const SizedBox(height: 24),
                    GenderFieldWidget(
                      selectedGender: signUpCubit.selectedGender,
                      onGenderChanged: (value) => signUpCubit.updateGender(value!),
                    ),
                    const SizedBox(height: 24),
                    OptionalTextFieldWidget(
                      controller: signUpCubit.countryController,
                      label: 'Country',
                      hintText: 'Enter your country',
                      icon: Icons.public_outlined,
                    ),
                    const SizedBox(height: 24),
                    OptionalTextFieldWidget(
                      controller: signUpCubit.phoneNumberController,
                      label: 'Phone Number',
                      hintText: 'Enter your phone number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 48),
                    //state is SignUpLoading ? null :
                    SignUpButtonWidget(
                      onPressed: () => _handleSignUp(),
                      //  isLoading: state is SignUpLoading,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      signUpCubit.createAccount(context: context);
    }
  }
}

class ProfilePictureWidget extends StatelessWidget {
  final File? profileImage;
  final Function(File?) onImageSelected;

  const ProfilePictureWidget({
    super.key,
    required this.profileImage,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipOval(
            child: profileImage != null
                ? Image.file(
                    profileImage!,
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
                  )
                : Container(
                    color: const Color(0xFFF1F5F9),
                    child: Icon(
                      Icons.person_outline,
                      size: 50,
                      color: Colors.grey[400],
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImageButton(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: Icons.camera_alt_outlined,
              label: 'Camera',
            ),
            const SizedBox(width: 16),
            _buildImageButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: Icons.photo_library_outlined,
              label: 'Gallery',
            ),
            if (profileImage != null) ...[
              const SizedBox(width: 16),
              _buildImageButton(
                onPressed: () => onImageSelected(null),
                icon: Icons.delete_outline,
                label: 'Remove',
                isDestructive: true,
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildImageButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    bool isDestructive = false,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red[50] : const Color(0xFFF1F5F9),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDestructive ? Colors.red[200]! : const Color(0xFFE2E8F0),
            ),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: isDestructive ? Colors.red[600] : const Color(0xFF64748B),
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDestructive ? Colors.red[600] : const Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      onImageSelected(File(pickedFile.path));
    }
  }
}

class RequiredTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const RequiredTextFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Color(0xFFDC2626)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
            prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDC2626)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return '$label is required';
                }
                return null;
              },
        ),
      ],
    );
  }
}

class OptionalTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;

  const OptionalTextFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
            prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}

class EmailFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const EmailFieldWidget({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Email',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Color(0xFFDC2626)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            hintText: 'user@example.com',
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
            prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF64748B), size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDC2626)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
        ),
      ],
    );
  }
}

class PasswordFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isPasswordVisible;
  final VoidCallback onVisibilityToggle;
  final String? Function(String?)? validator;

  const PasswordFieldWidget({
    super.key,
    required this.controller,
    required this.isPasswordVisible,
    required this.onVisibilityToggle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Password',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Color(0xFFDC2626)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !isPasswordVisible,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF64748B), size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: const Color(0xFF64748B),
                size: 20,
              ),
              onPressed: onVisibilityToggle,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDC2626)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
        ),
      ],
    );
  }
}

class DateOfBirthFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(DateTime) onDateSelected;

  const DateOfBirthFieldWidget({
    super.key,
    required this.controller,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Date of Birth',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Color(0xFFDC2626)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            hintText: 'Select your date of birth',
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
            prefixIcon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF64748B), size: 20),
            suffixIcon: const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDC2626)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          onTap: () => _selectDate(context),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Date of birth is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF3B82F6),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }
}

class GenderFieldWidget extends StatelessWidget {
  final int selectedGender;
  final ValueChanged<int?> onGenderChanged;

  const GenderFieldWidget({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedGender,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
              isExpanded: true,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1E293B),
              ),
              items: const [
                DropdownMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.male, color: Color(0xFF64748B), size: 20),
                      SizedBox(width: 12),
                      Text('Male'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.female, color: Color(0xFF64748B), size: 20),
                      SizedBox(width: 12),
                      Text('Female'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Color(0xFF64748B), size: 20),
                      SizedBox(width: 12),
                      Text('Other'),
                    ],
                  ),
                ),
              ],
              onChanged: onGenderChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class SignUpButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const SignUpButtonWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
