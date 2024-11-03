import 'package:badgemagic/main.dart';
import 'package:badgemagic/providers/app_localisation.dart';
import 'package:badgemagic/providers/locale_provider.dart';
import 'package:badgemagic/view/widgets/common_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = 'ENGLISH';
  String selectedBadge = 'LSLED';

  final List<String> languages = ['ENGLISH', 'CHINESE'];
  Map<String, String> languageMap = {
    'ENGLISH': 'en',
    'CHINESE': 'zh',
  };
  final List<String> badges = ['LSLED', 'VBLAB'];

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'language'.tr(context),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedLanguage,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLanguage = newValue!;
                      // print(languageMap[selectedLanguage]);
                      Provider.of<LocaleProvider>(context, listen: false)
                          .changeLocale(Locale(languageMap[newValue!]!));
                    });
                  },
                  items:
                      languages.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'select_badge'.tr(context),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedBadge,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedBadge = newValue!;
                    });
                  },
                  items: badges.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      title: 'Badge Magic',
    );
  }
}
