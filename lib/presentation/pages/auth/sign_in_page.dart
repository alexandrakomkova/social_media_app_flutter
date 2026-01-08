import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';
import 'package:social_media_app/l10n/l10n.dart';
import 'package:social_media_app/presentation/pages/auth/bloc/sign_in/sign_in_bloc.dart';
import 'package:social_media_app/presentation/pages/auth/sign_up_page.dart';
import 'package:social_media_app/presentation/pages/main_screen/main_page.dart';
import 'package:social_media_app/utils/validator.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInBloc>(
      create: (context) =>
          SignInBloc(authRepository: context.read<AuthRepository>()),
      child: const _SignInView(),
    );
  }
}

class _SignInView extends StatefulWidget {
  const _SignInView();

  @override
  State<_SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<_SignInView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInState$Failed) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }

        if (state is SignInState$Success) {
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (_) => MainPage()));
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.signInPageLabel,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 26),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<SignInBloc, SignInState>(
                          builder: (signInContext, state) {
                            return TextFormField(
                              key: const Key('signInForm_email_textFormField'),
                              initialValue: state.email,
                              validator: (value) => Validator(
                                context: context,
                              ).validateEmail(value),
                              onChanged: (value) => signInContext
                                  .read<SignInBloc>()
                                  .add(SignInEvent.emailChanged(value)),
                              decoration: InputDecoration(
                                hintText: l10n.emailHintText,
                                border: Theme.of(
                                  context,
                                ).inputDecorationTheme.border,
                                errorStyle: Theme.of(
                                  context,
                                ).inputDecorationTheme.errorStyle,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15.0),
                        BlocBuilder<SignInBloc, SignInState>(
                          builder: (signInContext, state) {
                            return TextFormField(
                              key: const Key(
                                'signInForm_password_textFormField',
                              ),
                              decoration: InputDecoration(
                                hintText: l10n.passwordHintText,
                                border: Theme.of(
                                  context,
                                ).inputDecorationTheme.border,
                                errorStyle: Theme.of(
                                  context,
                                ).inputDecorationTheme.errorStyle,
                              ),
                              initialValue: state.password,
                              obscureText: true,
                              validator: (value) => Validator(
                                context: context,
                              ).validatePassword(value),
                              onChanged: (value) => signInContext
                                  .read<SignInBloc>()
                                  .add(SignInEvent.passwordChanged(value)),
                            );
                          },
                        ),
                        const SizedBox(height: 30.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<SignInBloc>().add(
                                const SignInEvent.signIn(),
                              );
                            }
                          },
                          child: Text(l10n.signInButton),
                        ),
                        const SizedBox(height: 10.0),
                        ElevatedButton(
                          onPressed: () async {
                            context.read<SignInBloc>().add(
                              const SignInEvent.signInWithGoogle(),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/google-icon.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 8),
                              Text(l10n.signInWithGoogleText),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => SignUpPage()),
                            );
                          },
                          child: Text(l10n.dontHaveAccountTextButton),
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
