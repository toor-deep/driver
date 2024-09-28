import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/app_images.dart';
import '../../current_user/presentation/bloc/user_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool isOnline = true;
  late AnimationController _controller;
  late UserCubit userCubit;
  @override
  void initState() {
    super.initState();
    userCubit = context.read<UserCubit>();
    userCubit.fetchUser();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    // Dispose of the AnimationController
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          isOnline ? "Online" : "Offline",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
              width: 0.1.sw,
              height: 0.1.sh,
              child: SwitchListTile(
                value: isOnline,
                activeTrackColor: Theme.of(context).primaryColor,
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    isOnline = value;
                  });
                },
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Stack(children: [
            _buildBody(),
          ])
        ],
      ),
    );
  }

  Widget _buildBody() {
    return AnimatedBuilder(
      animation:
          CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(120 * _controller.value),
            _buildContainer(150 * _controller.value),
            // _buildContainer(250 * _controller.value),
            // _buildContainer(300 * _controller.value),
            // _buildContainer(350 * _controller.value),
            const Align(
                child: Image(
              image: AssetImage(AppImages.erickshaw),
              height: 35,
              width: 35,
            )),
          ],
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            Theme.of(context).primaryColor.withOpacity(1 - _controller.value),
      ),
    );
  }
}
