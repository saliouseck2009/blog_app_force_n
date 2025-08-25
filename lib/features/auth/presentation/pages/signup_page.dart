import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/auth_credentials.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../blog/presentation/widgets/custom_text_field.dart';
import '../../../blog/presentation/widgets/action_button.dart';

/// Page d'inscription
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              SignUpAppBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SignUpHeader(),
                      const SizedBox(height: 32),
                      Expanded(
                        child: SignUpForm(
                          formKey: _formKey,
                          firstNameController: _firstNameController,
                          lastNameController: _lastNameController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                        ),
                      ),
                      const SignUpLoginLink(),
                      const SizedBox(height: 16),
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

/// Widget pour la barre d'application
class SignUpAppBar extends StatelessWidget {
  const SignUpAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget pour l'en-tête de la page d'inscription
class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bloggr',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign up',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

/// Widget pour le formulaire d'inscription
class SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignUpForm({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SignUpFirstNameField(controller: firstNameController),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SignUpLastNameField(controller: lastNameController),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SignUpEmailField(controller: emailController),
          const SizedBox(height: 20),
          SignUpPasswordField(controller: passwordController),
          const SizedBox(height: 32),
          SignUpButton(
            formKey: formKey,
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            emailController: emailController,
            passwordController: passwordController,
          ),
        ],
      ),
    );
  }
}

/// Widget pour le champ prénom
class SignUpFirstNameField extends StatelessWidget {
  final TextEditingController controller;

  const SignUpFirstNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'First Name',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: controller,
          hintText: 'First name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Requis';
            }
            return null;
          },
        ),
      ],
    );
  }
}

/// Widget pour le champ nom
class SignUpLastNameField extends StatelessWidget {
  final TextEditingController controller;

  const SignUpLastNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Last Name',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: controller,
          hintText: 'Last name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Requis';
            }
            return null;
          },
        ),
      ],
    );
  }
}

/// Widget pour le champ email
class SignUpEmailField extends StatelessWidget {
  final TextEditingController controller;

  const SignUpEmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: controller,
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'L\'email est requis';
            }
            if (!value.contains('@')) {
              return 'Email invalide';
            }
            return null;
          },
        ),
      ],
    );
  }
}

/// Widget pour le champ mot de passe
class SignUpPasswordField extends StatelessWidget {
  final TextEditingController controller;

  const SignUpPasswordField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: controller,
          hintText: 'Create a password',
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Le mot de passe est requis';
            }
            if (value.length < 6) {
              return 'Le mot de passe doit contenir au moins 6 caractères';
            }
            return null;
          },
        ),
      ],
    );
  }
}

/// Widget pour le bouton d'inscription
class SignUpButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignUpButton({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return ActionButton(
          text: 'Sign up',
          isLoading: state is AuthLoading,
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              final signUpData = SignUpData(
                firstName: firstNameController.text.trim(),
                lastName: lastNameController.text.trim(),
                email: emailController.text.trim(),
                password: passwordController.text,
              );
              context.read<AuthBloc>().add(SignUpEvent(signUpData));
            }
          },
        );
      },
    );
  }
}

/// Widget pour le lien de connexion
class SignUpLoginLink extends StatelessWidget {
  const SignUpLoginLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(color: Colors.grey[600]),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Login',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
