import 'package:flutter/material.dart';
import 'package:medfind_flutter/Presentation/Screens/config/size_config.dart';

import 'Presentation/_Shared/routes.dart';
import 'Presentation/_Shared/theme.dart';

void main() {
  runApp(const MedFindApp());
}

class MedFindApp extends StatelessWidget {
  const MedFindApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.initialize(context);
    return MaterialApp.router(
      routeInformationParser: MedfindRouter.router.routeInformationParser,
      routerDelegate: MedfindRouter.router.routerDelegate,
      debugShowCheckedModeBanner: false,
      title: 'MedFind',
      theme: getAppTheme(),
    );
  }
}