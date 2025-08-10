import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/views/home/bloc/home_bloc.dart';
import 'package:money_management_app/views/home/bloc/home_state.dart';
import 'circle_icon_button.dart';

class HeaderActions extends StatelessWidget {
  const HeaderActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Row(
          spacing: 0,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(context.read<HomeBloc>().avatar),
            ),
            const Spacer(),
            CircleIconButton(icon: Icons.notifications_none, onPressed: () {}),
            CircleIconButton(
              icon: Icons.settings,
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            CircleIconButton(
              icon: Icons.logout,
              onPressed: () {
                Navigator.pushNamed(context, '/logout');
              },
            ),
          ],
        );
      },
    );
  }
}
