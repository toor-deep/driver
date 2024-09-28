import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/app_images.dart';
import '../../../shared/constants.dart';
import '../../../shared/image_upload.dart';
import '../../auth/domain/entities/auth_user.dart';
import '../../current_user/presentation/bloc/user_cubit.dart';
import '../../current_user/presentation/bloc/user_state.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late UserCubit userCubit;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isUpdate = true;
  File? _imageFile;
  String? _imageUrl;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _deleteImage() async {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  void initState() {
    super.initState();
    userCubit = context.read<UserCubit>();
    nameController.text = userCubit.state.authUser?.name ?? "";
    emailController.text = userCubit.state.authUser?.email ?? "";
    phoneController.text = userCubit.state.authUser?.phone ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("My Profile"),
            centerTitle: true,
          ),
          body: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image(
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                        image: _imageFile != null
                            ? FileImage(_imageFile!) as ImageProvider
                            : userCubit.state.authUser?.photoURL != null &&
                                    userCubit
                                        .state.authUser!.photoURL!.isNotEmpty
                                ? CachedNetworkImageProvider(
                                    userCubit.state.authUser!.photoURL!)
                                : const AssetImage(AppImages.user)
                                    as ImageProvider,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          showOptions(
                            context: context,
                            onImageSelected: (File imageFile) {
                              context
                                  .read<UserCubit>()
                                  .saveImageToFirebase(imageFile);
                              setState(() {
                                _imageFile = imageFile;
                              });
                            },
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacing.hmed,
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Spacing.hmed,
                    TextFormField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      readOnly: isUpdate,
                      controller: nameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).secondaryHeaderColor)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Name',
                        labelStyle: Theme.of(context).textTheme.bodyMedium,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                    Spacing.hlg,
                    Spacing.hlg,
                    Text(
                      'Email',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Spacing.hmed,
                    TextFormField(
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey.shade400),
                      readOnly: true,
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: Theme.of(context).textTheme.bodyMedium,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).secondaryHeaderColor)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Spacing.hlg,
                    Spacing.hlg,
                    Text(
                      'Phone',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Spacing.hmed,
                    TextFormField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      readOnly: isUpdate,
                      controller: phoneController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Phone',
                        labelStyle: Theme.of(context).textTheme.bodyMedium,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).secondaryHeaderColor)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your phone';
                        }
                        return null;
                      },
                    ),
                    Spacing.hlg,
                    Spacing.hlg,
                    SizedBox(
                      width: double.infinity,
                      height: 0.06.sh,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isUpdate = !isUpdate;
                          });
                          if (isUpdate) {
                            userCubit.updateUser(AuthUser(
                                id: '',
                                email: emailController.text,
                                name: nameController.text,
                                phone: phoneController.text,
                                photoURL: ''));
                          }
                        },
                        child: userCubit.state.isLoading == true
                            ? const CircularProgressIndicator()
                            : Text(isUpdate ? 'Edit' : 'Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}
