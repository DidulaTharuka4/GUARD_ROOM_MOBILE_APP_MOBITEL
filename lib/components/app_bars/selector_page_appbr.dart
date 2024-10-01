import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/images.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectorPageAppBarWithShadow extends StatelessWidget
    implements PreferredSizeWidget {
  const SelectorPageAppBarWithShadow({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      decoration:
          const BoxDecoration(color: ApplicationColors.PURE_WHITE, boxShadow: [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0, 4),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ]),
      child: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        backgroundColor: ApplicationColors.PURE_WHITE,
        title: Padding(
          padding: const EdgeInsets.all(0.0),
          child: SvgPicture.asset(
              // 'assets/images/SLTMobitel_Logo.svg',
              ApplicationImages.logo,
              width: screenSize.width / 4.5350,
              height: screenSize.height / 19.2930),
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: IconButton(
        //       onPressed: () {},
        //       icon: SvgPicture.asset('assets/images/Menu_dots.svg',
        //           width: screenSize.width / 52.88,
        //           height: screenSize.height / 43.94),
        //     ),
        //   ),
        // ],

        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton<int>(
                color: ApplicationColors.PURE_WHITE,
                onSelected: (value) {
                  clearToken();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                  // exit(0);
                  // _onSelected(context, result);
                },
                itemBuilder: (BuildContext context) => [
                      PopupMenuItem<int>(
                          value: 1,
                          child: Row(children: [
                            const Text('Logout'),
                            const SizedBox(width: 12),
                            SvgPicture.asset(
                              // 'assets/images/logout-box-line.svg',
                              ApplicationImages.logoutIcon,
                              height: 24,
                              width: 24,
                            )
                          ])),
                      //
                    ]),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
