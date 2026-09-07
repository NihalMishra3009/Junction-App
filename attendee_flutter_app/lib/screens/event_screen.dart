import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/types.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/pill_badge.dart';
import '../widgets/motion_tap.dart';

class EventScreen extends StatelessWidget {
  final AppState appState;

  const EventScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final isDelay = appState.activeScenario == ScenarioId.EVENT_DELAY;
    final event = appState.eventInfo;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "MATCH & VENUE GUIDE",
            style: AppTheme.metaText(fontSize: 12, color: AppTheme.inkMuted),
          ).animate().fadeIn(duration: 250.ms),
          const SizedBox(height: 6),
          Text(
            "Event Information",
            style: AppTheme.displayFont(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ).animate().fadeIn(duration: 300.ms, delay: 50.ms).slideY(begin: 0.08, end: 0),
          const SizedBox(height: 16),

          // Main Event Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(color: AppTheme.neutral, width: 1.0),
              boxShadow: AppTheme.shadowSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const PillBadge(
                      text: "● LIVE",
                      variant: PillVariant.live,
                      fontSize: 10,
                    ),
                    if (isDelay)
                      const PillBadge(
                        text: "DELAYED +30 MIN",
                        variant: PillVariant.critical,
                        fontSize: 10,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  event.name,
                  style: AppTheme.displayFont(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.venue,
                  style: AppTheme.bodyFont(
                    fontSize: 13,
                    color: AppTheme.inkMuted,
                  ),
                ),
                const SizedBox(height: 20),

                // Timetable Grid
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.paper,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "GATE OPEN",
                              style: AppTheme.metaText(
                                fontSize: 9,
                                color: AppTheme.inkFaint,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isDelay ? "19:30" : "18:00",
                              style: AppTheme.displayFont(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "MATCH START",
                              style: AppTheme.metaText(
                                fontSize: 9,
                                color: AppTheme.inkFaint,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isDelay ? "20:00" : "19:30",
                              style: AppTheme.displayFont(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDelay ? AppTheme.red : AppTheme.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "EST END",
                              style: AppTheme.metaText(
                                fontSize: 9,
                                color: AppTheme.inkFaint,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isDelay ? "23:00" : "22:30",
                              style: AppTheme.displayFont(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 350.ms, delay: 80.ms)
              .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

          const SizedBox(height: 20),

          // Allocated Gate Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(color: AppTheme.neutral, width: 1.0),
              boxShadow: AppTheme.shadowSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "YOUR ALLOCATED GATE",
                  style: AppTheme.metaText(fontSize: 11, color: AppTheme.inkMuted),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.yellowLight,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    border: Border.all(color: AppTheme.yellow),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.meeting_room, size: 20, color: AppTheme.ink),
                      const SizedBox(width: 10),
                      Text(
                        event.allocatedGate,
                        style: AppTheme.displayFont(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Arrive at least 30 minutes before match time. Expect security queue screening at peak arrival waves.",
                  style: AppTheme.bodyFont(
                    fontSize: 12,
                    color: AppTheme.inkMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 350.ms, delay: 150.ms)
              .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

          const SizedBox(height: 20),

          // Venue Guidelines
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(color: AppTheme.neutral, width: 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "VENUE POLICIES",
                  style: AppTheme.metaText(fontSize: 11, color: AppTheme.inkMuted),
                ),
                const SizedBox(height: 12),
                _buildPolicyItem(Icons.shopping_bag_outlined, "Bag Policy", "Only small handbags (under 30x30cm) permitted."),
                const SizedBox(height: 8),
                _buildPolicyItem(Icons.water_drop_outlined, "Water Bottles", "Sealed clear bottles allowed; refills inside."),
                const SizedBox(height: 8),
                _buildPolicyItem(Icons.confirmation_number_outlined, "Return Rail Pass", "Pre-purchase return transit tickets to avoid queues."),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 350.ms, delay: 220.ms)
              .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPolicyItem(IconData icon, String title, String desc) {
    return MotionTap(
      onTap: () {},
      scaleDown: 0.98,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppTheme.paperDark,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 14, color: AppTheme.ink),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTheme.bodyFont(fontSize: 12, color: AppTheme.inkLight),
                  children: [
                    TextSpan(
                      text: "$title: ",
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: desc),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
