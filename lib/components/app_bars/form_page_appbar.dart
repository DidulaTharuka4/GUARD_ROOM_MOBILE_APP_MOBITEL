import 'package:Guard_Room_Application/components/buttons/main_button.dart';
import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/images.dart';
import 'package:Guard_Room_Application/constraints/textSizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FormPageAppBarWithShadow extends StatelessWidget
    implements PreferredSizeWidget {
  final String pageTitle;
  final VoidCallback pressForClear;

  const FormPageAppBarWithShadow({
    super.key,
    required this.pageTitle,
    required this.pressForClear,
  });
  // const FormPageAppBarWithShadow({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    SizeConfig.init(context);
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
          backgroundColor: ApplicationColors.PURE_WHITE,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(ApplicationImages.backIcon,
                width: screenSize.width / 52.88,
                height: screenSize.height / 43.94),
          ),
          title: Text(pageTitle,
              style: TextStyle(
                  fontSize: ApplicationTextSizes.pageTitleTextValue(context),
                  fontFamily: 'Poppins', 
                  fontWeight: ApplicationTextWeights.PageTitleTextWeight)),
          actions: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomButton(
                innerText: 'Clear',
                backgroundColor: ApplicationColors.PURE_WHITE,
                onPress: pressForClear,
                // onPress: () {},
                textColor: ApplicationColors.RED_COLOR,
                buttonWidth: 20,
                buttonHeight: 10,
                borderColor: ApplicationColors.PURE_WHITE,
              ),
            )
          ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
