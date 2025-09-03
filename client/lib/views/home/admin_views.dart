import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tms/views/home/carousel_card.dart';
import 'package:tms/views/home/carousel_section.dart';

class AdminViews extends StatelessWidget {
  const AdminViews({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSection(
      title: "Admin Views",
      cards: [
        CarouselCard(
          title: "Setup",
          subtitle: "ADMIN",
          color: Color(0xffFA6E5A),
          icon: Icons.settings,
          onTap: () => context.push('/admin/setup'),
        ),
      ],
    );
  }
}
