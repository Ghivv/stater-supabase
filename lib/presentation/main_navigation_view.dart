import 'package:flutter/material.dart';
import 'package:reusekit/core/widget/hyper_ui/navigation/qnavigation.dart';
import 'package:reusekit/presentation/profile_view.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  @override
  Widget build(BuildContext context) {
    return QNavigation(
      mode: QNavigationMode.nav0,
      menus: [
        NavigationMenu(
          icon: Icons.dashboard,
          label: "Dashboard",
          view: Container(
            color: Colors.red,
          ),
        ),
        NavigationMenu(
          icon: Icons.list,
          label: "Order",
          view: Container(
            color: Colors.red,
          ),
        ),
        NavigationMenu(
          icon: Icons.favorite,
          label: "Favorite",
          view: Container(
            color: Colors.red,
          ),
        ),
        NavigationMenu(
          icon: Icons.person,
          label: "Profile",
          view: ProfileView(),
        ),
      ],
    );
  }
}
