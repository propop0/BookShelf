import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_extensions.dart';
import 'providers/auth_controller.dart';
import 'utils/auth_exception_mapper.dart';
import 'widgets/auth_form_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    await ref.read(authControllerProvider.notifier).signUp(
          email: _emailController.text,
          password: _passwordController.text,
        );

    if (!mounted) {
      return;
    }

    final AsyncValue<void> authState = ref.read(authControllerProvider);
    if (authState.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mapAuthException(authState.error!, context.l10n))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(authControllerProvider).isLoading;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.signUp)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AuthFormField(
                  controller: _emailController,
                  label: l10n.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) {
                    final String text = (value ?? '').trim();
                    if (text.isEmpty || !text.contains('@')) {
                      return l10n.validationEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AuthFormField(
                  controller: _passwordController,
                  label: l10n.password,
                  obscureText: true,
                  validator: (String? value) {
                    if ((value ?? '').length < 6) {
                      return l10n.validationPasswordMin;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AuthFormField(
                  controller: _confirmPasswordController,
                  label: l10n.confirmPassword,
                  obscureText: true,
                  validator: (String? value) {
                    if (value != _passwordController.text) {
                      return l10n.validationConfirmPassword;
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.createAccount),
                ),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(l10n.alreadyHaveAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
