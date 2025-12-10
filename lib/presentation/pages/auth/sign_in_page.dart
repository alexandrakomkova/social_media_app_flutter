import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/auth/auth_repository_impl.dart';
import 'package:social_media_app/utils/validator.dart';
import 'package:social_media_app/presentation/pages/auth/bloc/sign_in/sign_in_bloc.dart';
import 'package:social_media_app/presentation/pages/main_screen/main_page.dart';
import 'package:social_media_app/presentation/widget/custom_text_form_field.dart';

import 'package:social_media_app/presentation/pages/auth/sign_up_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInBloc>(
      create: (signInContext) =>
          SignInBloc(
              authRepository: signInContext.read<AuthRepositoryImpl>()
          ),
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
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInState$Failed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }

        if(state is SignInState$Success) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => MainPage(),
            ),
          );
        }
      },
      listenWhen: (previous, current) => previous.status != current.status,
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
                    'Sign In',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 26,),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<SignInBloc, SignInState>(
                          builder: (signInContext, state) {
                            return CustomTextFormField(
                              textFieldKey: const Key(
                                  'signInForm_email_textFormField'),
                              initialValue: state.email,
                              hintText: 'Email',
                              validator: (value) => Validator.validateEmail(value),
                              onChanged: (value) =>
                                  signInContext.read<SignInBloc>().add(
                                      SignInEvent.emailChanged(value)),
                            );
                          },
                        ),
                        const SizedBox(height: 15.0),
                        BlocBuilder<SignInBloc, SignInState>(
                          builder: (signInContext, state) {
                            return CustomTextFormField(
                              textFieldKey: const Key(
                                  'signInForm_password_textFormField'),
                              initialValue: state.password,
                              hintText: 'Password',
                              obscureText: true,
                              validator: (value) => Validator.validatePassword(value),
                              onChanged: (value) =>
                                signInContext.read<SignInBloc>().add(
                                    SignInEvent.passwordChanged(value)
                                ),
                            );
                          },
                        ),
                        const SizedBox(height: 30.0),
                        ElevatedButton(
                          onPressed: () async {
                            context.read<SignInBloc>().add(const SignInEvent.signIn());
                          },
                          child: Text(
                            'Sign in',
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => SignUpPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Don\'t have an account? Sign up now!',
                          ),
                        )
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

