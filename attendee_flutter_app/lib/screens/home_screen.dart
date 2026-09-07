import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/types.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/pill_badge.dart';
import '../widgets/motion_tap.dart';

class HomeScreen extends StatelessWidget {
  final AppState appState;

  const HomeScreen({super.key, required this.appState});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "GOOD MORNING";
    if (hour < 17) return "GOOD AFTERNOON";
    return "GOOD EVENING";
  }

  @override
  Widget build(BuildContext context) {
    final alerts = appState.alerts;
    final topAlert = alerts.isNotEmpty ? alerts.first : null;
    final hasRec = appState.hasAttendeeRecommendation;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Event Card
          Text(
            _getGreeting(),
            style: AppTheme.metaText(fontSize: 12, color: AppTheme.inkMuted),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 8),

          Container(
            width: double.infinity,
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
                    Text(
                      "33,000 Expected",
                      style: AppTheme.metaText(
                        fontSize: 10,
                        color: AppTheme.inkMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  appState.eventInfo.name,
                  style: AppTheme.displayFont(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${appState.eventInfo.venue} · ${appState.eventInfo.startTime} · ${appState.eventInfo.allocatedGate}",
                  style: AppTheme.bodyFont(
                    fontSize: 13,
                    color: AppTheme.inkMuted,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 50.ms)
              .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

          const SizedBox(height: 16),

          // Alert / Recommendation Banner
          if (topAlert != null || hasRec)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: hasRec ? AppTheme.yellowLight : AppTheme.redBg,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(
                  color: hasRec ? AppTheme.yellow : AppTheme.red.withValues(alpha: 0.3),
                  width: 1.2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: hasRec ? AppTheme.ink : AppTheme.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      hasRec ? "★" : "!",
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasRec
                              ? "ORGANIZER RECOMMENDATION"
                              : topAlert?.title.toUpperCase() ?? "ALERT",
                          style: AppTheme.displayFont(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                            color: hasRec ? AppTheme.ink : AppTheme.red,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hasRec
                              ? appState.attendeeRecommendationMessage
                              : topAlert?.message ?? "",
                          style: AppTheme.bodyFont(
                            fontSize: 13,
                            color: AppTheme.inkLight,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        MotionTap(
                          onTap: () => appState.setTabIndex(0),
                          scaleDown: 0.94,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.yellow,
                              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                            ),
                            child: Text(
                              "See Options →",
                              style: AppTheme.displayFont(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 100.ms)
                .scaleXY(begin: 0.96, end: 1.0, curve: Curves.easeOutBack),

          // Your Journey Card
          Container(
            width: double.infinity,
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
                    Text(
                      "YOUR JOURNEY",
                      style: AppTheme.metaText(
                        fontSize: 11,
                        color: AppTheme.inkMuted,
                      ),
                    ),
                    if (appState.attendeeSelectedRouteId != null)
                      const PillBadge(
                        text: "ROUTE CONFIRMED",
                        variant: PillVariant.live,
                        fontSize: 9,
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "FROM",
                            style: AppTheme.metaText(
                              fontSize: 10,
                              color: AppTheme.inkFaint,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Harbour Line Area",
                            style: AppTheme.displayFont(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.arrow_forward, size: 16, color: AppTheme.inkMuted),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TO",
                            style: AppTheme.metaText(
                              fontSize: 10,
                              color: AppTheme.inkFaint,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Wankhede Stadium",
                            style: AppTheme.displayFont(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.paper,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          appState.attendeeSelectedRouteId != null
                              ? "Active: ${appState.attendeeSelectedRouteId} Route"
                              : "Balanced Route · ★ Recommended",
                          style: AppTheme.bodyFont(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.inkLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        appState.attendeeSelectedRouteId == "FASTEST"
                            ? "24 min"
                            : appState.attendeeSelectedRouteId == "LOW_CROWD"
                                ? "48 min"
                                : "31 min",
                        style: AppTheme.displayFont(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                MotionTap(
                  onTap: () => appState.setTabIndex(0), // Plan Tab (Index 0)
                  scaleDown: 0.96,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.yellow,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.yellow.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      appState.attendeeSelectedRouteId != null
                          ? "CHANGE ROUTE"
                          : "VIEW JOURNEY OPTIONS",
                      style: AppTheme.displayFont(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 150.ms)
              .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

          const SizedBox(height: 24),

          // Quick Actions Grid
          Text(
            "QUICK ACTIONS",
            style: AppTheme.metaText(fontSize: 11, color: AppTheme.inkMuted),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 10),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.8,
            children: [
              _buildQuickCard(
                icon: "◇",
                label: "Plan Journey",
                subtext: "Fastest & balanced routes",
                onTap: () => appState.setTabIndex(0), // Plan Tab (Index 0)
                delay: 220,
              ),
              _buildQuickCard(
                icon: "◈",
                label: "Find Stay",
                subtext: "Usable hotel inventory",
                onTap: () => appState.setTabIndex(1), // Stay Tab (Index 1)
                delay: 260,
              ),
              _buildQuickCard(
                icon: "◆",
                label: "Food & Dining",
                subtext: "Wait times & deals",
                onTap: () => appState.setTabIndex(3), // Food Tab (Index 3)
                delay: 300,
              ),
              _buildQuickCard(
                icon: "★",
                label: "Event Info",
                subtext: "Gate 3 & timetable",
                onTap: () => appState.setTabIndex(4), // Event Tab (Index 4)
                delay: 340,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Alerts List
          Text(
            "DESTINATION ALERTS",
            style: AppTheme.metaText(fontSize: 11, color: AppTheme.inkMuted),
          ).animate().fadeIn(delay: 380.ms),
          const SizedBox(height: 10),

          ...List.generate(alerts.length, (i) {
            final a = alerts[i];
            PillVariant variant;
            if (a.severity == AlertSeverity.CRITICAL) {
              variant = PillVariant.critical;
            } else if (a.severity == AlertSeverity.HIGH) {
              variant = PillVariant.high;
            } else {
              variant = PillVariant.watch;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                border: Border.all(color: AppTheme.neutral, width: 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PillBadge(
                        text: a.category.name,
                        variant: variant,
                        fontSize: 9,
                      ),
                      Text(
                        a.timestamp,
                        style: AppTheme.metaText(
                          fontSize: 10,
                          color: AppTheme.inkFaint,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    a.title,
                    style: AppTheme.displayFont(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    a.message,
                    style: AppTheme.bodyFont(
                      fontSize: 12,
                      color: AppTheme.inkMuted,
                    ),
                  ),
                  if (a.actionLabel != null) ...[
                    const SizedBox(height: 10),
                    MotionTap(
                      onTap: () {
                        if (a.actionRoute == "stay") {
                          appState.setTabIndex(1); // Stay Tab
                        } else {
                          appState.setTabIndex(0); // Plan Tab
                        }
                      },
                      scaleDown: 0.94,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.paper,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          border: Border.all(color: AppTheme.neutralDark),
                        ),
                        child: Text(
                          "${a.actionLabel} →",
                          style: AppTheme.displayFont(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 350.ms, delay: Duration(milliseconds: 400 + (i * 60)))
                .slideX(begin: 0.05, end: 0, curve: Curves.easeOutCubic);
          }),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildQuickCard({
    required String icon,
    required String label,
    required String subtext,
    required VoidCallback onTap,
    required int delay,
  }) {
    return MotionTap(
      onTap: onTap,
      scaleDown: 0.94,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: AppTheme.neutral, width: 1.0),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  icon,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.ink,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Icon(Icons.chevron_right, size: 16, color: AppTheme.inkFaint),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTheme.displayFont(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtext,
              style: AppTheme.bodyFont(fontSize: 10, color: AppTheme.inkMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 350.ms, delay: Duration(milliseconds: delay))
        .scaleXY(begin: 0.92, end: 1.0, curve: Curves.easeOutBack);
  }
}
