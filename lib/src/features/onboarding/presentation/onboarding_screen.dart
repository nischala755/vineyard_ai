import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});
  final Future<void> Function() onComplete;
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  var _page = 0;
  final _slides = const [
    (
      Icons.energy_savings_leaf_outlined,
      'Scan grape leaves',
      'Frame one clear leaf in good daylight for the best diagnosis.'
    ),
    (
      Icons.offline_bolt_outlined,
      'Works offline',
      'Your photo, prediction and scan history remain on this device.'
    ),
    (
      Icons.health_and_safety_outlined,
      'Act with confidence',
      'Use the treatment guide alongside advice from your local agricultural officer.'
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(children: [
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: widget.onComplete, child: const Text('Skip'))),
            Expanded(
                child: PageView.builder(
              controller: _controller,
              itemCount: _slides.length,
              onPageChanged: (value) => setState(() => _page = value),
              itemBuilder: (_, index) {
                final slide = _slides[index];
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(slide.$1,
                          size: 96,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 32),
                      Text(slide.$2,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 14),
                      Text(slide.$3,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge),
                    ]);
              },
            )),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    _slides.length,
                    (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.all(4),
                          width: _page == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: _page == index
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                              borderRadius: BorderRadius.circular(8)),
                        ))),
            const SizedBox(height: 20),
            FilledButton(
                onPressed: () => _page == _slides.length - 1
                    ? widget.onComplete()
                    : _controller.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut),
                child: Text(
                    _page == _slides.length - 1 ? 'Get started' : 'Continue')),
          ]),
        )),
      );
}
