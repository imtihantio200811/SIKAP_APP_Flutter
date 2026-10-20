import 'package:flutter/material.dart';

import '../components/onboarding_actions.dart';
import '../components/onboarding_background.dart';
import '../components/onboarding_description.dart';
import '../components/onboarding_preview_card.dart';
import '../components/onboarding_step_header.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.onSkip,
    required this.onContinue,
    required this.onBack,
  });

  final VoidCallback onSkip;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final pageWidth = constraints.maxWidth < 402
              ? constraints.maxWidth
              : 402.0;

          return Stack(
            children: [
              const Positioned.fill(child: OnboardingBackground()),
              Center(
                child: SizedBox(
                  width: pageWidth,
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
                          child: Column(
                            children: [
                              OnboardingStepHeader(onSkip: onSkip),
                              const SizedBox(height: 8),
                              const OnboardingPreviewCard(),
                              const SizedBox(height: 24),
                              const _StepIndicator(),
                              const SizedBox(height: 23),
                              const OnboardingDescription(),
                              const Spacer(),
                              const SizedBox(height: 28),
                              OnboardingActions(
                                onContinue: onContinue,
                                onBack: onBack,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StepDot(active: false),
        SizedBox(width: 8),
        _StepDot(active: true),
        SizedBox(width: 8),
        _StepDot(active: false),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: active ? 28 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF123966) : const Color(0xFFD8E0FF),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
