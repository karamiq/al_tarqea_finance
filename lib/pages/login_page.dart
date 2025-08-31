import 'package:al_tarqea_finance/data/models/requests_models/login_request_model.dart';
import 'package:al_tarqea_finance/router/app_router.dart';
import 'package:al_tarqea_finance/utils/extensions.dart';
import 'package:al_tarqea_finance/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:al_tarqea_finance/utils/widgets/form_fields/custom_text_form_field.dart';
// ...existing code...
import 'package:al_tarqea_finance/utils/widgets/buttons/filled_loading_button.dart';
import 'package:al_tarqea_finance/data/providers/auth_provider.dart';
import 'package:riverpod_state/riverpod_state.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

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
          padding: const EdgeInsets.all(16),
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
                        Text(
                          'تسجيل الدخول',
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
                        const SizedBox(height: 28),
                        FilledLoadingButton(
                          isLoading: ref.watch(loginProvider).isLoading,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final result = await ref.read(loginProvider.notifier).run(LoginRequestModel(
                                    firstName: _firstNameController.text.trim(),
                                    lastName: _lastNameController.text.trim(),
                                  ));
                              result.whenDataOrError(
                                  data: (data) {
                                    context.push(RoutesDocument.utilityBills);
                                  },
                                  error: (e, t) {});
                            }
                          },
                          child: const Text('تسجيل الدخول',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        const SizedBox(height: 18),
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).push('/register');
                          },
                          child: const Text("ليس لديك حساب؟ سجل الآن",
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
}
