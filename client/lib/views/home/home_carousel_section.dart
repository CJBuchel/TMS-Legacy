import 'package:flutter/material.dart';

import 'home_carousel_card.dart';

class HomeCarouselSection extends StatelessWidget {
  const HomeCarouselSection({
    super.key,
    required this.title,
    required this.cards,
  });

  final String title;
  final List<HomeCarouselCard> cards;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 130,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cards.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return cards[index];
            },
          ),
        ),
      ],
    );
  }
}
