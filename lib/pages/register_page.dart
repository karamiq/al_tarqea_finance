import 'package:al_tarqea_finance/common_lib.dart';
import 'package:al_tarqea_finance/data/services/clients/_clients.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../utils/widgets/form_fields/profile_image_form_field.dart';
import '../utils/widgets/buttons/filled_loading_button.dart';
import '../data/providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  DateTime? _selectedDateOfBirth;
  final ValueNotifier<File?> _imageNotifier = ValueNotifier<File?>(null);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final accentColor = Theme.of(context).colorScheme.secondary;
    final bgGradient = LinearGradient(
      colors: [primaryColor, accentColor, Colors.pinkAccent, Colors.lightBlueAccent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: Padding(
          padding: Insets.smallAll,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 12,
                shadowColor: accentColor.withOpacity(0.3),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ProfileImageFormField(
                          initialValue: _imageNotifier.value,
                          imageNotifier: _imageNotifier,
                          accentColor: accentColor,
                          primaryColor: primaryColor,
                          validator: (file) {
                            if (file == null) return 'يرجى اختيار صورة شخصية';
                            return null;
                          },
                        ),
                        Text(
                          'إنشاء حساب',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: primaryColor,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomTextFormField(
                          controller: _firstNameController,
                          labelText: 'الاسم الأول',
                          hintText: 'أدخل الاسم الأول',
                          prefixIcon: const Icon(Icons.person_outline, color: Colors.deepPurple),
                          fillColor: Colors.white.withOpacity(0.95),
                          validator: context.validator.minLength(2).build(),
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: _lastNameController,
                          labelText: 'اسم العائلة',
                          hintText: 'أدخل اسم العائلة',
                          prefixIcon: const Icon(Icons.person, color: Colors.deepPurple),
                          fillColor: Colors.white.withOpacity(0.95),
                          validator: context.validator.minLength(2).build(),
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          readOnly: true,
                          onTap: () async {
                            _selectedDateOfBirth = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (_selectedDateOfBirth != null) {
                              _dateOfBirthController.text =
                                  DateFormat('yyyy-MM-dd').format(_selectedDateOfBirth!);
                            }
                          },
                          controller: _dateOfBirthController,
                          labelText: 'تاريخ الميلاد',
                          hintText: 'أدخل تاريخ الميلاد',
                          prefixIcon: const Icon(Icons.cake, color: Colors.deepPurple),
                          fillColor: Colors.white.withOpacity(0.95),
                          validator: context.validator.minLength(2).build(),
                        ),
                        const SizedBox(height: 28),
                        FilledLoadingButton(
                          isLoading: ref.watch(signupProvider).isLoading,
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                _imageNotifier.value != null &&
                                _selectedDateOfBirth != null) {
                              final result = await ref.read(signupProvider.notifier).run(
                                    _firstNameController.text.trim(),
                                    _lastNameController.text.trim(),
                                    _imageNotifier.value!,
                                  );
                              result.whenDataOrError(
                                data: (data) {
                                  context.push(RoutesDocument.utilityBills);
                                },
                                error: (e, t) {},
                              );
                            }
                          },
                          child: const Text('إنشاء حساب',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        const SizedBox(height: 18),
                        TextButton(
                          onPressed: () {
                            context.push(RoutesDocument.login);
                          },
                          child: const Text('لديك حساب بالفعل؟ سجل الدخول',
                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.deepPurple)),
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

  // _pickImage is no longer needed; image picking is handled in ProfileImageFormField
}
