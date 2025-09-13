import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _CarouselList extends HookWidget {
  const _CarouselList({required this.cards});

  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    final scrollController = useCarouselController();
    final showLeftGradient = useState(false);
    final showRightGradient = useState(true);

    useEffect(() {
      void updateGradients() {
        if (scrollController.hasClients) {
          final position = scrollController.position;
          showLeftGradient.value = position.pixels > 0;
          showRightGradient.value = position.pixels < position.maxScrollExtent;
        }
      }

      scrollController.addListener(updateGradients);
      return () => scrollController.removeListener(updateGradients);
    }, [scrollController]);

    return Stack(
      children: [
        // Left gradient indicator
        if (showLeftGradient.value)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 30,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(
                      context,
                    ).scaffoldBackgroundColor.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),

        // Right gradient indicator
        if (showRightGradient.value)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 30,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(
                      context,
                    ).scaffoldBackgroundColor.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),

        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 180),
          child: CarouselView(
            enableSplash: false,
            controller: scrollController,
            itemExtent: 320,
            shrinkExtent: 200,
            itemSnapping: true,
            padding: const EdgeInsets.all(10),
            children: cards,
          ),
        ),
      ],
    );
  }
}

class CarouselSection extends StatelessWidget {
  const CarouselSection({super.key, required this.title, required this.cards});

  final String title;
  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: title),
        _CarouselList(cards: cards),
      ],
    );
  }
}
