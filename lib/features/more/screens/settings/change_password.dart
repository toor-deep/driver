
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constants.dart';
import '../../../auth/presentation/bloc/auth/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth/auth_state.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
  TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  bool _isObscureCurrent = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Change Password'),
          ),
          body: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.only(top: 40, left: 16, right: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        style: Theme.of(context).textTheme.bodySmall,
                        controller: _currentPasswordController,
                        obscureText: _isObscureCurrent,
                        decoration: InputDecoration(
                          floatingLabelBehavior:
                          FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              const BorderSide(color: Colors.black)),
                          labelText: 'Current Password',
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscureCurrent
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscureCurrent = !_isObscureCurrent;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your current password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        style: Theme.of(context).textTheme.bodySmall,
                        controller: _newPasswordController,
                        obscureText: _isObscureNew,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          floatingLabelBehavior:
                          FloatingLabelBehavior.never,
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscureNew
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscureNew = !_isObscureNew;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        style: Theme.of(context).textTheme.bodySmall,
                        controller: _confirmPasswordController,
                        obscureText: _isObscureConfirm,
                        decoration: InputDecoration(
                          floatingLabelBehavior:
                          FloatingLabelBehavior.never,
                          labelText: 'Confirm Password',
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscureConfirm
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscureConfirm = !_isObscureConfirm;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != _newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      Spacing.hlg,
                      SizedBox(
                        width: double.infinity,
                        height: 0.06.sh,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().changePassword(
                                  _newPasswordController.text);
                            }
                          },
                          child: state.isLoading == true
                              ? const CircularProgressIndicator()
                              : const Text('Change Password'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
