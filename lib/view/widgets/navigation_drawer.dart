import 'package:badgemagic/constants.dart';
import 'package:badgemagic/providers/app_localisation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class BMDrawer extends StatelessWidget {
  const BMDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: Center(
              child: Text(
                'title'.tr(context),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.edit),
            title: Text(
              'create_badge'.tr(context),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            onTap: () {
              // Check if the HomeScreen is already in the navigation stack
              if (Navigator.canPop(context) &&
                  ModalRoute.of(context)?.settings.name == '/') {
                // If it's already in the stack, pop to it
                Navigator.popUntil(context, ModalRoute.withName('/'));
              } else {
                // Otherwise, navigate to HomeScreen
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => route.isFirst,
                );
              }
            },
          ),
          ListTile(
            dense: true,
            leading: Image.asset(
              "assets/icons/signature.png",
              height: 18,
              color: Colors.black,
            ),
            title: Text(
              'draw_badge'.tr(context),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/drawBadge',
                (route) => route.isFirst,
              );
            },
          ),
          ListTile(
            dense: true,
            leading: Image.asset(
              "assets/icons/r_save.png",
              height: 18,
              color: Colors.black,
            ),
            title: Text(
              'saved_badges'.tr(context),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/savedBadge',
                (route) => route.isFirst,
              );
            },
          ),
          ListTile(
            dense: true,
            leading: Image.asset(
              "assets/icons/r_save.png",
              height: 18,
              color: Colors.black,
            ),
            title: Text(
              'saved_cliparts'.tr(context),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/savedClipart',
                (route) => route.isFirst,
              );
            },
          ),
          ListTile(
            dense: true,
            leading: Image.asset(
              "assets/icons/setting.png",
              height: 18,
              color: Colors.black,
            ),
            title: Text(
              'settings'.tr(context),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/settings',
                (route) => route.isFirst,
              );
            },
          ),
          ListTile(
            dense: true,
            leading: Image.asset(
              "assets/icons/r_team.png",
              height: 18,
              color: Colors.black,
            ),
            title: Text(
              'about'.tr(context),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/aboutUs',
                (route) => route.isFirst,
              );
            },
          ),
          const Divider(),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: Text(
                  'Other',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            dense: true,
            leading: Image.asset(
              "assets/icons/r_price.png",
              height: 18,
              color: Colors.black,
            ),
            title: Text(
              'buy_bages'.tr(context),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              openUrl('https://badgemagic.fossasia.org/shop/');
            },
          ),
          ListTile(
            dense: true,
            leading: const Icon(
              Icons.share,
              color: Colors.black,
            ),
            title: Text(
              'share'.tr(context),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              //share the playstore url of the app with a text
              Share.share(
                  'Badge Magic is an Android app to control LED name badges. This app provides features to portray names, graphics and simple animations on LED badges.You can also download it from below link https://play.google.com/store/apps/details?id=org.fossasia.badgemagic ');
            },
          ),
          ListTile(
            dense: true,
            leading: const Icon(
              Icons.star,
              color: Colors.black,
            ),
            title: Text(
              'rate'.tr(context),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              openUrl(
                  'https://play.google.com/store/apps/details?id=org.fossasia.badgemagic');
            },
          ),
          ListTile(
            dense: true,
            leading: Image.asset(
              "assets/icons/r_virus.png",
              height: 18,
              color: Colors.black,
            ),
            title: Text(
              'feedback'.tr(context),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              openUrl('https://github.com/fossasia/badgemagic-android/issues');
            },
          ),
          ListTile(
            dense: true,
            leading: Image.asset(
              "assets/icons/r_insurance.png",
              height: 18,
              color: Colors.black,
            ),
            title: Text(
              'privacy_policy'.tr(context),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              openUrl('https://badgemagic.fossasia.org/privacy/');
            },
          ),
        ],
      ),
    );
  }
}
