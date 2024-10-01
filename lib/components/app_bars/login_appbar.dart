import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LoginPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SvgPicture.asset(
            'assets/images/Footer.svg',
            fit: BoxFit.cover,
          ),
        ),
        AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100.0);
}
