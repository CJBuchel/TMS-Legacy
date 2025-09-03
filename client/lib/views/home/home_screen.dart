import 'package:flutter/material.dart';
import 'package:tms/views/home/home_carousel_card.dart';
import 'package:tms/views/home/home_carousel_section.dart';

/// Pastel colors
/// 0xff8E97FD blue/purple
/// 0xffFFC97E yellow
/// 0xffFA6E5A red
/// 0xff6CB28E green
/// 0xffD291BC violet
/// 0xff2ACAC8 cyan
/// 0xFF828282 grey
/// 0xFF2D7F9D steel blue

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            HomeCarouselSection(
              title: 'Admin',
              cards: [
                HomeCarouselCard(
                  title: 'Setup',
                  color: const Color(0xff8E97FD),
                  onTap: () {
                    // Navigate to setup page
                  },
                ),
                HomeCarouselCard(
                  title: 'Users',
                  color: const Color(0xffFFC97E),
                  onTap: () {},
                ),
                HomeCarouselCard(
                  title: 'Events',
                  color: const Color(0xffFA6E5A),
                  onTap: () {},
                ),
              ],
            ),
            HomeCarouselSection(
              title: 'Judging',
              cards: [
                HomeCarouselCard(
                  title: 'Scoresheet',
                  color: const Color(0xff6CB28E),
                  onTap: () {},
                ),
                HomeCarouselCard(
                  title: 'Leaderboard',
                  color: const Color(0xffD291BC),
                  onTap: () {},
                ),
              ],
            ),
            HomeCarouselSection(
              title: 'Scoring',
              cards: [
                HomeCarouselCard(
                  title: 'Live Scoring',
                  color: const Color(0xff2ACAC8),
                  onTap: () {},
                ),
                HomeCarouselCard(
                  title: 'Results',
                  color: const Color(0xFF828282),
                  onTap: () {},
                ),
              ],
            ),
          ]),
        ),
      ],
    );
  }
}
