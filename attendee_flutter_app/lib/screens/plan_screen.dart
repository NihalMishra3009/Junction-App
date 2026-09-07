import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/types.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/pill_badge.dart';
import '../widgets/motion_tap.dart';
import '../widgets/route_transit_map.dart';

class PlanScreen extends StatefulWidget {
  final AppState appState;

  const PlanScreen({super.key, required this.appState});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  AttendeeRoute? _selectedDetailRoute;
  bool _confirmed = false;
  final Set<int> _expandedStepIndices = {};
  int? _highlightedStepIndex;
  final ScrollController _mainScrollController = ScrollController();
  final ScrollController _detailScrollController = ScrollController();

  @override
  void dispose() {
    _mainScrollController.dispose();
    _detailScrollController.dispose();
    super.dispose();
  }

  Color _crowdColor(String level) {
    if (level == "HIGH") return AppTheme.red;
    if (level == "MEDIUM") return AppTheme.yellowState;
    return AppTheme.green;
  }

  IconData _modeIcon(String mode) {
    switch (mode) {
      case "RAIL":
        return Icons.train_rounded;
      case "BUS":
        return Icons.directions_bus_rounded;
      case "METRO":
        return Icons.subway_rounded;
      case "WALK":
      default:
        return Icons.directions_walk_rounded;
    }
  }

  Color _modeBgColor(String mode) {
    switch (mode) {
      case "RAIL":
        return AppTheme.blueBg;
      case "BUS":
        return AppTheme.yellowStateBg;
      case "METRO":
        return AppTheme.greenBg;
      case "WALK":
      default:
        return AppTheme.paperDark;
    }
  }

  Color _modeFgColor(String mode) {
    switch (mode) {
      case "RAIL":
        return AppTheme.blue;
      case "BUS":
        return AppTheme.yellowState;
      case "METRO":
        return AppTheme.green;
      case "WALK":
      default:
        return AppTheme.ink;
    }
  }

  void _showRouteSelectedToast(BuildContext context, String routeLabel) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(left: 36, right: 36, bottom: 84),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(milliseconds: 2000),
        animation: CurvedAnimation(
          parent: AnimationController(
            vsync: ScaffoldMessenger.of(context),
            duration: const Duration(milliseconds: 300),
          )..forward(),
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.greenBg,
            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
            border: Border.all(
              color: AppTheme.green.withValues(alpha: 0.6),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded, size: 16, color: AppTheme.green),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  "Route choice synced: $routeLabel",
                  style: AppTheme.displayFont(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.green,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routes = widget.appState.routes;
    final isRecApproved = widget.appState.isRec1Approved;

    if (_selectedDetailRoute != null) {
      return _buildDetailView(_selectedDetailRoute!);
    }

    return SingleChildScrollView(
      controller: _mainScrollController,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PLAN YOUR JOURNEY",
            style: AppTheme.metaText(fontSize: 12, color: AppTheme.inkMuted),
          ).animate().fadeIn(duration: 250.ms),
          const SizedBox(height: 8),

          // Origin / Destination Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(color: AppTheme.neutral, width: 1.0),
              boxShadow: AppTheme.shadowSm,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.ink,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ORIGIN",
                          style: AppTheme.metaText(fontSize: 9, color: AppTheme.inkFaint),
                        ),
                        Text(
                          "Harbour Line Area",
                          style: AppTheme.displayFont(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 3.5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 16,
                      child: VerticalDivider(
                        color: AppTheme.neutralDark,
                        thickness: 1.5,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.yellow,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "DESTINATION",
                          style: AppTheme.metaText(fontSize: 9, color: AppTheme.inkFaint),
                        ),
                        Text(
                          "Wankhede Stadium (Gate 3 South)",
                          style: AppTheme.displayFont(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 350.ms, delay: 50.ms)
              .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

          const SizedBox(height: 16),

          // Active Recommendation Notice
          if (isRecApproved)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.yellowLight,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppTheme.yellow, width: 1.0),
              ),
              child: Row(
                children: [
                  const Text("◆", style: TextStyle(fontSize: 14, color: AppTheme.ink)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ORGANIZER RECOMMENDATION ACTIVE",
                          style: AppTheme.displayFont(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "Dadar Station corridor with AC Event Shuttle is recommended due to Churchgate capacity limits.",
                          style: AppTheme.bodyFont(
                            fontSize: 12,
                            color: AppTheme.inkLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 350.ms)
                .scaleXY(begin: 0.95, end: 1.0, curve: Curves.easeOutBack),

          Text(
            "COMPARE ROUTE OPTIONS (CHOOSE ONE)",
            style: AppTheme.metaText(fontSize: 11, color: AppTheme.inkMuted),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 10),

          // Route Cards
          ...List.generate(routes.length, (index) {
            final r = routes[index];
            final isSelectedChoice = widget.appState.attendeeSelectedRouteId == r.id;

            return MotionTap(
              onTap: () {
                setState(() {
                  _selectedDetailRoute = r;
                  _confirmed = isSelectedChoice;
                  _expandedStepIndices.clear();
                });
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_detailScrollController.hasClients) {
                    _detailScrollController.jumpTo(0.0);
                  }
                });
              },
              scaleDown: 0.96,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(
                    color: isSelectedChoice
                        ? AppTheme.green
                        : r.recommended
                            ? AppTheme.yellow
                            : AppTheme.neutral,
                    width: isSelectedChoice || r.recommended ? 1.5 : 1.0,
                  ),
                  boxShadow: AppTheme.shadowSm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            PillBadge(
                              text: r.type == "FASTEST"
                                  ? "FASTEST"
                                  : r.type == "BALANCED"
                                      ? "BALANCED ★"
                                      : "LOW CROWD",
                              variant: r.recommended
                                  ? PillVariant.yellow
                                  : r.type == "FASTEST"
                                      ? PillVariant.predicted
                                      : PillVariant.simulated,
                              fontSize: 10,
                            ),
                            if (isSelectedChoice) ...[
                              const SizedBox(width: 6),
                              const PillBadge(
                                text: "SELECTED",
                                variant: PillVariant.live,
                                fontSize: 9,
                              ),
                            ],
                          ],
                        ),
                        Text(
                          "${r.totalTime} min",
                          style: AppTheme.displayFont(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          r.crowdLevel == "HIGH"
                              ? "High crowd"
                              : r.crowdLevel == "MEDIUM"
                                  ? "Medium crowd"
                                  : "Low crowd",
                          style: AppTheme.displayFont(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _crowdColor(r.crowdLevel),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text("·", style: TextStyle(color: AppTheme.inkMuted)),
                        ),
                        Text(
                          "${r.transfers} transfer${r.transfers != 1 ? 's' : ''}",
                          style: AppTheme.bodyFont(
                            fontSize: 12,
                            color: AppTheme.inkMuted,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text("·", style: TextStyle(color: AppTheme.inkMuted)),
                        ),
                        Text(
                          "${r.walkingTime} min walk",
                          style: AppTheme.bodyFont(
                            fontSize: 12,
                            color: AppTheme.inkMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      r.explanation,
                      style: AppTheme.bodyFont(
                        fontSize: 12,
                        color: AppTheme.inkLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Quick leg snapshot
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.paper,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...r.steps.map((step) {
                                    return Row(
                                      children: [
                                        Icon(_modeIcon(step.mode), size: 14, color: _modeFgColor(step.mode)),
                                        const SizedBox(width: 4),
                                        Text(
                                          step.platform != null ? "${step.platform}" : "${step.duration}m",
                                          style: AppTheme.metaText(fontSize: 9, color: AppTheme.ink),
                                        ),
                                        if (step != r.steps.last) ...[
                                          const SizedBox(width: 6),
                                          const Icon(Icons.chevron_right, size: 12, color: AppTheme.inkFaint),
                                          const SizedBox(width: 6),
                                        ],
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "View Details →",
                            style: AppTheme.displayFont(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.ink,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Embedded Map Preview inside Route Card
                    RouteTransitMap(
                      route: r,
                      height: 140,
                      isInteractive: false,
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 350.ms, delay: Duration(milliseconds: 140 + (index * 70)))
                .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
          }),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDetailView(AttendeeRoute route) {
    final isSelectedChoice = widget.appState.attendeeSelectedRouteId == route.id;

    return SingleChildScrollView(
      key: ValueKey("detail_${route.id}"),
      controller: _detailScrollController,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MotionTap(
            onTap: () => setState(() {
              _selectedDetailRoute = null;
              _highlightedStepIndex = null;
            }),
            scaleDown: 0.94,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back, size: 16, color: AppTheme.ink),
                const SizedBox(width: 6),
                Text(
                  "Back to all route options",
                  style: AppTheme.displayFont(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 200.ms),
          const SizedBox(height: 12),

          // Interactive Multi-Modal Transit Map with Live Simulation & Zoom
          RouteTransitMap(
            route: route,
            height: 230,
            isInteractive: true,
            highlightedStepIndex: _highlightedStepIndex,
          ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: 14),

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
                    PillBadge(
                      text: route.label.toUpperCase(),
                      variant: route.recommended
                          ? PillVariant.yellow
                          : PillVariant.simulated,
                      fontSize: 11,
                    ),
                    Text(
                      "${route.totalTime} MIN",
                      style: AppTheme.displayFont(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        "DETAILED STEP-BY-STEP NAVIGATION",
                        style: AppTheme.metaText(fontSize: 10, color: AppTheme.inkMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Tap to highlight",
                      style: AppTheme.metaText(fontSize: 9, color: AppTheme.inkFaint),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Enhanced Steps list with platforms, distances, line names, and stops
                ...List.generate(route.steps.length, (i) {
                  final step = route.steps[i];
                  final isLast = i == route.steps.length - 1;
                  final isExpanded = _expandedStepIndices.contains(i);

                  final isStepHighlighted = _highlightedStepIndex == i;

                  return MotionTap(
                    onTap: () {
                      setState(() {
                        if (_highlightedStepIndex == i) {
                          _highlightedStepIndex = null;
                        } else {
                          _highlightedStepIndex = i;
                        }
                      });
                    },
                    scaleDown: 0.98,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isStepHighlighted ? AppTheme.yellowLight.withValues(alpha: 0.45) : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        border: isStepHighlighted
                            ? Border.all(color: AppTheme.yellow, width: 1.2)
                            : null,
                      ),
                      padding: isStepHighlighted ? const EdgeInsets.all(6) : EdgeInsets.zero,
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left transit icon and continuous timeline vertical indicator
                            Column(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: isStepHighlighted ? AppTheme.yellow : _modeBgColor(step.mode),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isStepHighlighted
                                          ? AppTheme.ink
                                          : _modeFgColor(step.mode).withValues(alpha: 0.3),
                                      width: isStepHighlighted ? 1.8 : 1.2,
                                    ),
                                  ),
                                  child: Icon(
                                    _modeIcon(step.mode),
                                    size: 16,
                                    color: isStepHighlighted ? AppTheme.ink : _modeFgColor(step.mode),
                                  ),
                                ),
                                if (!isLast)
                                  Expanded(
                                    child: Container(
                                      width: 2,
                                      color: isStepHighlighted ? AppTheme.yellow : AppTheme.neutralDark,
                                      margin: const EdgeInsets.symmetric(vertical: 4),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            // Step details body
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 22),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // From -> To Title
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${step.from} → ${step.to}",
                                            style: AppTheme.displayFont(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        if (isStepHighlighted)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppTheme.ink,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              "MAP ACTIVE",
                                              style: AppTheme.metaText(fontSize: 8, color: AppTheme.yellow),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),

                                    // Platform, Distance & Duration Chips
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 4,
                                      children: [
                                        if (step.platform != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppTheme.ink,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              step.platform!,
                                              style: const TextStyle(
                                                color: AppTheme.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        if (step.distance != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppTheme.paperDark,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              step.distance!,
                                              style: AppTheme.metaText(fontSize: 10, color: AppTheme.ink),
                                            ),
                                          ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppTheme.paperDark,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            "${step.duration} min",
                                            style: AppTheme.metaText(fontSize: 10, color: AppTheme.inkMuted),
                                          ),
                                        ),
                                        if (step.frequency != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppTheme.yellowLight,
                                              borderRadius: BorderRadius.circular(4),
                                              border: Border.all(color: AppTheme.yellow.withValues(alpha: 0.6)),
                                            ),
                                            child: Text(
                                              step.frequency!,
                                              style: AppTheme.metaText(fontSize: 9, color: AppTheme.ink),
                                            ),
                                          ),
                                      ],
                                    ),

                                    if (step.lineName != null) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        step.lineName!,
                                        style: AppTheme.bodyFont(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.inkLight,
                                        ),
                                      ),
                                    ],

                                    if (step.instruction != null) ...[
                                      const SizedBox(height: 6),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: AppTheme.paper,
                                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                                          border: Border.all(color: AppTheme.neutral),
                                        ),
                                        child: Text(
                                          step.instruction!,
                                          style: AppTheme.bodyFont(
                                            fontSize: 12,
                                            color: AppTheme.inkLight,
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                    ],

                                    // Expandable intermediate stops list
                                    if (step.stops != null && step.stops!.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      MotionTap(
                                        onTap: () {
                                          setState(() {
                                            if (isExpanded) {
                                              _expandedStepIndices.remove(i);
                                            } else {
                                              _expandedStepIndices.add(i);
                                            }
                                          });
                                        },
                                        scaleDown: 0.98,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppTheme.paperDark,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                                size: 14,
                                                color: AppTheme.ink,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${step.stops!.length} intermediate stops",
                                                style: AppTheme.displayFont(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (isExpanded)
                                        Container(
                                          margin: const EdgeInsets.only(top: 6),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: AppTheme.paper,
                                            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                                            border: Border.all(color: AppTheme.neutral),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: List.generate(step.stops!.length, (sIdx) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 2),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("• ", style: TextStyle(color: AppTheme.inkMuted)),
                                                    Expanded(
                                                      child: Text(
                                                        step.stops![sIdx],
                                                        style: AppTheme.bodyFont(fontSize: 11, color: AppTheme.ink),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                          ),
                                        ).animate().fadeIn(duration: 200.ms),
                                    ],

                                    if (step.crowdStatus != null) ...[
                                      const SizedBox(height: 6),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(top: 2),
                                            child: Icon(Icons.people_outline, size: 12, color: AppTheme.inkMuted),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              step.crowdStatus!,
                                              style: AppTheme.bodyFont(fontSize: 11, color: AppTheme.inkMuted),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: Duration(milliseconds: 100 + (i * 80)))
                      .slideX(begin: 0.04, end: 0);
                }),

                // Final Stadium Entry Destination Badge
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.yellowLight,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    border: Border.all(color: AppTheme.yellow, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppTheme.yellow,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.stadium_rounded, size: 18, color: AppTheme.ink),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "DESTINATION: WANKHEDE STADIUM",
                              style: AppTheme.displayFont(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Direct Gate 3 (South Entrance) dedicated security lane.",
                              style: AppTheme.bodyFont(fontSize: 11, color: AppTheme.inkLight),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 350.ms),

                const Divider(height: 32, thickness: 1.0),
                const SizedBox(height: 8),

                // Route Stats Grid
                Text(
                  "TRANSIT CONDITIONS",
                  style: AppTheme.metaText(fontSize: 11, color: AppTheme.inkMuted),
                ),
                const SizedBox(height: 10),

                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildStatBox("Crowd", route.crowdLevel, _crowdColor(route.crowdLevel))),
                        const SizedBox(width: 8),
                        Expanded(child: _buildStatBox("Congestion", route.congestionLevel, AppTheme.ink)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildStatBox("Transfers", "${route.transfers}", AppTheme.ink)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildStatBox("Walking", "${route.walkingTime} min", AppTheme.ink)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildStatBox("Reliability", route.reliability, AppTheme.ink)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildStatBox("Route Score", "${route.score}/100", AppTheme.ink)),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Why Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.paperDark,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "WHY THIS ROUTE?",
                        style: AppTheme.metaText(
                          fontSize: 10,
                          color: AppTheme.ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        route.explanation,
                        style: AppTheme.bodyFont(
                          fontSize: 12,
                          color: AppTheme.inkLight,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                if (_confirmed && isSelectedChoice)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.greenBg,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      border: Border.all(color: AppTheme.green.withValues(alpha: 0.5), width: 1.2),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 16, color: AppTheme.green),
                        const SizedBox(width: 8),
                        Text(
                          "ROUTE SELECTED & SYNCED",
                          style: AppTheme.displayFont(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: AppTheme.green,
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 250.ms)
                      .scaleXY(begin: 0.96, end: 1.0, curve: Curves.easeOutBack)
                else
                  MotionTap(
                    onTap: () {
                      widget.appState.selectAttendeeRoute(route.id);
                      setState(() {
                        _confirmed = true;
                      });
                      _showRouteSelectedToast(context, route.label);
                    },
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
                        "CHOOSE THIS ROUTE",
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
              .fadeIn(duration: 350.ms)
              .slideY(begin: 0.05, end: 0, curve: Curves.easeOutCubic),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.paper,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTheme.metaText(fontSize: 9, color: AppTheme.inkFaint),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTheme.displayFont(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
