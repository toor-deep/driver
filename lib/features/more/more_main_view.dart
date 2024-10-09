import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/constants.dart';
import '../../shared/dialog.dart';
import '../auth/presentation/bloc/auth/auth_cubit.dart';

class MoreOptionsScreen extends StatelessWidget {
  const MoreOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More Options"),
        automaticallyImplyLeading: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OptionTile(
              icon: Icons.person,
              title: 'Profile',
              onTap: () {
                Navigator.pushNamed(context, '/MyProfile');
              },
            ),
            const Divider(),
            OptionTile(
              icon: Icons.history,
              title: 'History',
              onTap: () {
                Navigator.pushNamed(context, '/RideHistory');
              },
            ),
            const Divider(),
            OptionTile(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pushNamed(context, '/Settings');
              },
            ),
            const Divider(),
            OptionTile(
              icon: Icons.account_balance_wallet,
              title: 'My Wallet',
              onTap: () {
                Navigator.pushNamed(context, '/MyWallet');
              },
            ),
            const Divider(),
            OptionTile(
              icon: Icons.policy,
              title: 'Privacy Policy',
              onTap: () {
                Navigator.pushNamed(context, '/Privacy');
              },
            ),
            const Divider(),
            OptionTile(
              icon: Icons.description,
              title: 'Terms of Service',
              onTap: () {
                Navigator.pushNamed(context, '/Terms');
              },
            ),
            const Divider(),
            OptionTile(
              icon: Icons.logout,
              title: 'LogOut',
              onTap: () {
                showDeleteDialog(
                    context: context,
                    onTap: () {
                      context.read<AuthCubit>().signOut(() {
                        Navigator.of(appNavigationKey.currentContext!)
                            .pushNamedAndRemoveUntil(
                                '/SignIn', (Route<dynamic> route) => false);
                      });
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
