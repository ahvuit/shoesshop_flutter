import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoes_shop/config/theme.dart';
import 'package:shoes_shop/core/view_models/locale_provider.dart';
import 'package:shoes_shop/generated/l10n.dart';
import 'package:shoes_shop/ui/route/route_paths.dart';
import 'package:shoes_shop/ui/widgets/profile_menu.dart';
import 'package:shoes_shop/ui/widgets/toggle_language.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Body extends StatefulWidget {
  final LocaleProvider provider;
  const Body({Key? key, required this.provider}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool? isDarkMode;
  int? index1;

  Color colorEN = AppColors.blackGrey;

  Color colorVN = AppColors.blackGrey;

  Future<bool> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('isDarkMode') ?? false;

    return isDarkMode!;
  }

  Future<void> saveThemeMode(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<int> getIndex(isDarkMode) async {
    if(isDarkMode){
      index1 = 0;
    }else{
      index1 = 1;
    }
    return index1!;
  }

  void initialization()  {
    Future.delayed(const Duration(seconds: 1), () async {
      isDarkMode = await getThemeMode();
      index1 = await getIndex(isDarkMode);
    });

  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        ProfileMenu(
          text: S.of(context).language,
          icon: Icons.language,
          widget: ToggleLanguage(provider: widget.provider),
          press: () {},
        ),
        ProfileMenu(
          text: S.of(context).screenMode,
          icon: Icons.mode_night,
          widget: ToggleSwitch(
            minWidth: 50.0,
            initialLabelIndex: (isDarkMode ?? false) ? 0 : 1,
            cornerRadius: 20.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            icons: const [
              Icons.mode_night,
              Icons.sunny,
            ],
            iconSize: 30.0,
            activeBgColors: const [
              [Colors.black87, Colors.black26],
              [Colors.yellow, Colors.orange]
            ],
            animate:
                true, // with just animate set to true, default curve = Curves.easeIn
            curve: Curves
                .bounceInOut, // animate must be set to true when using custom curve
            onToggle: (index) {
              index1 = index!;

            },
          ),
          press: () async {
            if(index1 == 0){
               saveThemeMode(true);
            }else{
               saveThemeMode(false);
            }
          },
        ),
        ProfileMenu(
          text: S.of(context).changePassword,
          icon: Icons.change_circle,
          widget: const Icon(Icons.arrow_forward_ios),
          press: () => {Navigator.pushNamed(context, RoutePaths.changePass)},
        ),
      ],
    );
  }
}
