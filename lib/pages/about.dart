import 'package:flutter/material.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:weather/widgets/nav_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class About extends StatelessWidget {
  About({Key? key}) : super(key: key);

  final CustomWidgets cw = CustomWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      body: NestedScrollView(
        body: Column(
          children: const [
            Padding(padding: EdgeInsets.symmetric(horizontal: 16.0))
          ],
        ),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 180,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(AppLocalizations.of(context)!.about),
                background: const Image(
                  image: AssetImage("assets/dev.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              floating: true,
              pinned: true,
            )
          ];
        },
      ),
    );
  }
}
