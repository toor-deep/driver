import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/app_images.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/toast_alert.dart';
import '../../../current_user/presentation/bloc/user_cubit.dart';
import '../../domain/entities/auth_user.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/sign_in/sign_in_state.dart';
import '../bloc/sign_up/sign_up_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  late SignUpCubit signUpCubit;

  @override
  void initState() {
    signUpCubit = context.read<SignUpCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Column(
            children: [
              Image(
                image: const AssetImage(AppImages.driverBg),
                height: 0.35.sh,
                width: 0.9.sw,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Spacing.hmed,
                    Text(
                      'Create your account to start using RideMate',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Spacing.hmed,
                    TextFormField(
                      style: Theme.of(context).textTheme.bodySmall,
                      onChanged: (String value) {
                        context.read<SignUpCubit>().usernameChanged(value);
                      },
                      decoration: InputDecoration(
                        label: const Text('Username'),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    Spacing.hmed,
                    TextFormField(
                      style: Theme.of(context).textTheme.bodySmall,
                      onChanged: (String value) {
                        context.read<SignUpCubit>().emailChanged(value);
                      },
                      decoration: InputDecoration(
                        label: const Text('Email'),
                        errorText:
                            signUpCubit.state.emailStatus == EmailStatus.invalid
                                ? 'Invalid email'
                                : null,
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    Spacing.hmed,
                    TextFormField(
                      style: Theme.of(context).textTheme.bodySmall,
                      decoration: InputDecoration(
                        label: const Text('Password'),
                        errorText: signUpCubit.state.passwordStatus ==
                                PasswordStatus.invalid
                            ? 'Invalid password'
                            : null,
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onChanged: (String value) {
                        context.read<SignUpCubit>().passwordChanged(value);
                      },
                    ),
                    Spacing.hmed,
                    TextFormField(
                      style: Theme.of(context).textTheme.bodySmall,
                      onChanged: (String value) {
                        context.read<SignUpCubit>().phoneChanged(value);
                      },
                      decoration: InputDecoration(
                        label: const Text('Phone'),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    Spacing.hmed,
                    TextFormField(
                      style: Theme.of(context).textTheme.bodySmall,
                      onChanged: (String value) {
                        context.read<SignUpCubit>().vehicleNumberChanged(value);
                      },
                      decoration: InputDecoration(
                        label: const Text('Vehicle No.'),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    Spacing.hmed,
                    SizedBox(
                      width: double.infinity,
                      height: 0.06.sh,
                      child: ElevatedButton(
                        onPressed: () {
                          if (context.read<SignUpCubit>().inputValidator() !=
                              true) {
                            showSnackbar('Invalid Input', Colors.red);
                          } else {
                            final signUpCubitState =
                                context.read<SignUpCubit>().state;
                            context.read<AuthCubit>().signUp(
                                signUpCubitState.email ?? "",
                                signUpCubitState.password ?? "", () {
                              context.read<UserCubit>().addUser(AuthUser(
                                  id: '',
                                  email: signUpCubitState.email ?? "",
                                  name: signUpCubitState.userName ?? "",
                                  photoURL: '',
                                  role: 'driver',
                                  isOnline: false,
                                  vehicleNumber: signUpCubitState.vehicleNumber,
                                  phone: signUpCubitState.phone ?? ""));
                              Navigator.pushNamed(
                                context,
                                '/BottomBar',
                              );
                              emailController.clear();
                              phoneNumberController.clear();
                              passwordController.clear();
                            });
                          }
                        },
                        child: state.isLoading == true
                            ? const CircularProgressIndicator()
                            : const Text('Sign Up'),
                      ),
                    ),
                    Spacing.hlg,
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account ? ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            TextSpan(
                              text: 'Sign In',
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, '/SignIn');
                                },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
