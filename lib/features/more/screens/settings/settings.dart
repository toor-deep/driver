
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/dialog.dart';
import '../../../../shared/state/app-theme/app_theme_cubit.dart';
import '../../../auth/presentation/bloc/auth/auth_cubit.dart';


class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isDarkMode = false;
  late ThemeCubit themeCubit;

  @override
  void initState() {
    themeCubit = context.read<ThemeCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
              centerTitle: true,
            ),
            body: Column(children: [
              Padding(
                padding:
                const EdgeInsets.only(left: 30, top: 50, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      title: Text("Dark Mode",
                          style: Theme.of(context).textTheme.bodyMedium),
                      activeColor: Theme.of(context).primaryColor,
                      activeTrackColor: Colors.grey,
                      value: state.isDarkMode,
                      onChanged: (value) {
                        themeCubit.toggleTheme();
                        isDarkMode = value;
                        setState(() {});
                      },
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/ChangePassword');
                      },
                      title: Text("Change Password",
                          style: Theme.of(context).textTheme.bodyMedium),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        showDeleteDialog(
                            context: context,
                            onTap: () {
                              context.read<AuthCubit>().deleteAccount(() {
                                Navigator.of(
                                    appNavigationKey.currentContext!)
                                    .pushNamedAndRemoveUntil('/SignIn',
                                        (Route<dynamic> route) => false);
                              });
                            });
                      },
                      title: Text("Delete Account",
                          style: Theme.of(context).textTheme.bodyMedium),
                      trailing: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            ]));
      },
    );
  }
}
