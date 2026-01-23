import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';
import 'package:social_media_app/l10n/l10n.dart';
import 'package:social_media_app/presentation/pages/auth/bloc/sign_up/sign_up_bloc.dart';
import 'package:social_media_app/presentation/pages/auth/sign_in_page.dart';
import 'package:social_media_app/utils/validator.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpBloc>(
      create: (context) =>
          SignUpBloc(authRepository: context.read<AuthRepository>()),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<SignUpBloc>().state;

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpState$Failed) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }

        if (state is SignUpState$Success) {
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (_) => SignInPage()));
        }
      },
      listenWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      child: Scaffold(
        appBar: AppBar(),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.signUpPageLabel,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 26),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          key: const Key('signUpForm_username_textFormField'),
                          decoration: InputDecoration(
                            hintText: l10n.usernameHintText,
                            border: Theme.of(
                              context,
                            ).inputDecorationTheme.border,
                            errorStyle: Theme.of(
                              context,
                            ).inputDecorationTheme.errorStyle,
                          ),
                          initialValue: state.username,
                          validator: Validator(
                            context: context,
                          ).validateUsername,
                          onChanged: (value) => context.read<SignUpBloc>().add(
                            SignUpEvent.usernameChanged(value),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        TextFormField(
                          key: const Key('signUpForm_email_textFormField'),
                          initialValue: state.email,
                          decoration: InputDecoration(
                            hintText: l10n.emailHintText,
                            border: Theme.of(
                              context,
                            ).inputDecorationTheme.border,
                            errorStyle: Theme.of(
                              context,
                            ).inputDecorationTheme.errorStyle,
                          ),
                          validator: Validator(context: context).validateEmail,
                          onChanged: (value) => context.read<SignUpBloc>().add(
                            SignUpEvent.emailChanged(value),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        TextFormField(
                          key: const Key('signUpForm_password_textFormField'),
                          initialValue: state.password,
                          decoration: InputDecoration(
                            hintText: l10n.passwordHintText,
                            border: Theme.of(
                              context,
                            ).inputDecorationTheme.border,
                            errorStyle: Theme.of(
                              context,
                            ).inputDecorationTheme.errorStyle,
                          ),
                          obscureText: true,
                          validator: Validator(
                            context: context,
                          ).validatePassword,
                          onChanged: (value) => context.read<SignUpBloc>().add(
                            SignUpEvent.passwordChanged(value),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        TextFormField(
                          key: const Key(
                            'signUpForm_repeatPassword_textFormField',
                          ),
                          initialValue: state.repeatPassword,
                          decoration: InputDecoration(
                            hintText: l10n.repeatPasswordHintText,
                            border: Theme.of(
                              context,
                            ).inputDecorationTheme.border,
                            errorStyle: Theme.of(
                              context,
                            ).inputDecorationTheme.errorStyle,
                          ),
                          obscureText: true,
                          validator: (value) => Validator(
                            context: context,
                          ).validateRepeatPassword(state.password, value),
                          onChanged: (value) => context.read<SignUpBloc>().add(
                            SignUpEvent.repeatPasswordChanged(value),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<SignUpBloc>().add(
                                const SignUpEvent.signUp(),
                              );
                            }
                          },
                          child: Text(l10n.signUpButton),
                        ),
                        const SizedBox(height: 10.0),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => SignInPage()),
                            );
                          },
                          child: Text(l10n.alreadyHaveAccountTextButton),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
