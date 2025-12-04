import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/auth/auth_repository_impl.dart';
import 'package:social_media_app/utils/validator.dart';
import 'package:social_media_app/presentation/pages/auth/bloc/sign_up/sign_up_bloc.dart';
import 'package:social_media_app/presentation/pages/auth/sign_in_page.dart';
import 'package:social_media_app/presentation/widget/custom_text_form_field.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpBloc>(
      create: (signUpContext) =>
          SignUpBloc(
            authRepository: signUpContext.read<AuthRepositoryImpl>(),
          ),
      child: _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView({super.key});

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
  listener: (context, _) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SignInPage(),
      ),
    );
  },
      listenWhen: (previous, current) =>
        previous.status != current.status &&
          current.status == SignUpStatus.success,
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
                  'Sign Up',
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
                      BlocBuilder<SignUpBloc, SignUpState>(
                        builder: (signUpContext, state) {
                          return CustomTextFormField(
                            textFieldKey: const Key(
                                'signUpForm_username_textFormField'),
                            initialValue: state.username,
                            hintText: 'Username',
                            validator: (value) => Validator.validateUsername(value),
                            onChanged: (value) =>
                                signUpContext.read<SignUpBloc>().add(
                                    SignUpEvent.usernameChanged(value)
                                ),
                          );
                        },
                      ),
                      const SizedBox(height: 15.0),
                      BlocBuilder<SignUpBloc, SignUpState>(
                        builder: (signUpContext, state) {
                          return CustomTextFormField(
                            textFieldKey: const Key(
                                'signUpForm_email_textFormField'),
                            initialValue: state.email,
                            hintText: 'Email',
                            validator: (value) => Validator.validateEmail(value),
                            onChanged: (value) =>
                                signUpContext.read<SignUpBloc>().add(
                                    SignUpEvent.emailChanged(value)
                                ),
                          );
                        },
                      ),
                      const SizedBox(height: 15.0),
                      BlocBuilder<SignUpBloc, SignUpState>(
                        builder: (signUpContext, state) {
                          return CustomTextFormField(
                            textFieldKey: const Key(
                                'signUpForm_password_textFormField'),
                            initialValue: state.password,
                            hintText: 'Password',
                            obscureText: true,
                            validator: (value) => Validator.validatePassword(value),
                            onChanged: (value) =>
                                signUpContext.read<SignUpBloc>().add(
                                    SignUpEvent.passwordChanged(value)),
                          );
                        },
                      ),
                      const SizedBox(height: 15.0),
                      BlocBuilder<SignUpBloc, SignUpState>(
                        builder: (signUpContext, state) {
                          return CustomTextFormField(
                            textFieldKey: const Key(
                                'signUpForm_repeatPassword_textFormField'),
                            initialValue: state.repeatPassword,
                            hintText: 'Repeat password',
                            obscureText: true,
                            validator: (value) => Validator.validateRepeatPassword(state.password, value),
                            onChanged: (value) =>
                              signUpContext.read<SignUpBloc>().add(SignUpEvent.repeatPasswordChanged(value)),
                          );
                        },
                      ),
                      const SizedBox(height: 30.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            context.read<SignUpBloc>().add(const SignUpEvent.signUp());
                          }
                        },
                        child: Text(
                          'Sign up',
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => SignInPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Already have an account? Sign in now!',
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

