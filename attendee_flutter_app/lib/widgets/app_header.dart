import 'package:flutter/material.dart';
import '../models/types.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'pill_badge.dart';
import 'motion_tap.dart';
import 'profile_modal.dart';

class AppHeader extends StatelessWidget {
  final AppState appState;

  const AppHeader({super.key, required this.appState});

  void _showScenarioModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SIMULATION SCENARIOS",
                      style: AppTheme.displayFont(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                Text(
                  "Switch destination scenarios to see attendee recommendations and routes adapt.",
                  style: AppTheme.bodyFont(fontSize: 12, color: AppTheme.inkMuted),
                ),
                const SizedBox(height: 16),
                ...ScenarioId.values.map((sc) {
                  final isSelected = appState.activeScenario == sc;
                  return MotionTap(
                    onTap: () {
                      appState.setScenario(sc);
                      Navigator.pop(ctx);
                    },
                    scaleDown: 0.97,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.yellowLight : AppTheme.paper,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        border: Border.all(
                          color: isSelected ? AppTheme.yellow : AppTheme.neutral,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: isSelected ? AppTheme.ink : AppTheme.inkFaint,
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              sc.displayName,
                              style: AppTheme.displayFont(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          PillBadge(
                            text: sc.shortCode,
                            variant: isSelected
                                ? PillVariant.yellow
                                : PillVariant.simulated,
                            fontSize: 9,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                // Closed Loop Simulation Switch
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.paperDark,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Organizer Broadcast",
                            style: AppTheme.displayFont(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "Push Dadar redistribution to attendees",
                            style: AppTheme.bodyFont(
                              fontSize: 11,
                              color: AppTheme.inkMuted,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: appState.isRec1Approved,
                        activeThumbColor: AppTheme.ink,
                        activeTrackColor: AppTheme.yellow,
                        onChanged: (val) {
                          appState.toggleOrganizerRecommendation(val);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showClosedLoopModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "CLOSED-LOOP TELEMETRY",
                      style: AppTheme.displayFont(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                Text(
                  "Human-in-the-loop interaction trace: Attendee decisions dynamically update the destination state.",
                  style: AppTheme.bodyFont(fontSize: 12, color: AppTheme.inkMuted),
                ),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 260),
                  child: appState.closedLoopEvents.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              "No interactions yet. Select routes or change scenarios to see events stream.",
                              style: AppTheme.bodyFont(
                                color: AppTheme.inkMuted,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: appState.closedLoopEvents.length,
                          separatorBuilder: (context, index) => const Divider(height: 12),
                          itemBuilder: (ctx, i) {
                            return Text(
                              appState.closedLoopEvents[i],
                              style: AppTheme.bodyFont(
                                fontSize: 12,
                                color: AppTheme.inkLight,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: AppTheme.paper,
        border: Border(
          bottom: BorderSide(color: AppTheme.neutral, width: 1.0),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Text(
              "JUNCTION",
              style: AppTheme.displayFont(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 6),
            const PillBadge(
              text: "● LIVE",
              variant: PillVariant.live,
              fontSize: 9,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            ),
            const Spacer(),
            // Closed loop icon button
            MotionTap(
              onTap: () => _showClosedLoopModal(context),
              scaleDown: 0.90,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.sync_alt, size: 18, color: AppTheme.ink),
              ),
            ),
            const SizedBox(width: 8),
            // Scenario switcher button
            MotionTap(
              onTap: () => _showScenarioModal(context),
              scaleDown: 0.94,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  border: Border.all(color: AppTheme.neutralDark, width: 1.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      appState.activeScenario.shortCode,
                      style: AppTheme.displayFont(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(Icons.tune, size: 12, color: AppTheme.ink),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Attendee Profile Button
            MotionTap(
              onTap: () => ProfileModal.show(context, appState),
              scaleDown: 0.90,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.ink,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.yellow, width: 1.5),
                  boxShadow: AppTheme.shadowSm,
                ),
                alignment: Alignment.center,
                child: Text(
                  (appState.currentUser?.name.isNotEmpty == true)
                      ? appState.currentUser!.name.substring(0, 1).toUpperCase()
                      : "A",
                  style: AppTheme.displayFont(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.yellow,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
