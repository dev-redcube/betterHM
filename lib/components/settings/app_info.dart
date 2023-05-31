import 'package:better_hm/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({Key? key}) : super(key: key);

  void _showAboutDialog(
          BuildContext context, PackageInfo info, String versionText) =>
      showAboutDialog(
        context: context,
        applicationVersion: versionText,
        applicationLegalese: t.app_info.licenseNotice(buildYear: "2023"),
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final PackageInfo? info = snapshot.data;
        String text;
        if (!snapshot.hasData) {
          text = "loading version info";
        } else {
          text = "v${info!.version} (${info.buildNumber})";
        }
        return TextButton(
          child: Text(text),
          onPressed: () {
            _showAboutDialog(context, info!, text);
          },
        );
      },
    );
  }
}
