import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/types.dart';
import '../theme/app_theme.dart';
import 'motion_tap.dart';

/// Real interactive Leaflet Map for Mumbai transit routes (Wadala -> CSMT/Dadar -> Wankhede Stadium)
/// Built using flutter_map (official Leaflet engine in Flutter) with CartoDB Positron / OSM tiles
/// matching the clean cream & yellow paper theme of the app.
class RouteTransitMap extends StatefulWidget {
  final AttendeeRoute route;
  final double height;
  final bool isInteractive;
  final int? highlightedStepIndex;
  final VoidCallback? onExpand;

  const RouteTransitMap({
    super.key,
    required this.route,
    this.height = 240,
    this.isInteractive = true,
    this.highlightedStepIndex,
    this.onExpand,
  });

  @override
  State<RouteTransitMap> createState() => _RouteTransitMapState();
}

class _RouteTransitMapState extends State<RouteTransitMap>
    with SingleTickerProviderStateMixin {
  late final MapController _mapController;
  late final AnimationController _simController;
  bool _isSimulating = false;
  double _simProgress = 0.0;

  // Real geographic coordinates of Mumbai stations & stadium
  static const LatLng originCoords = LatLng(19.0195, 72.8590); // Wadala East
  static const LatLng vadalaStationCoords = LatLng(19.0165, 72.8580); // Vadala Road Station
  static const LatLng kurlaStationCoords = LatLng(19.0657, 72.8793); // Kurla Interchange
  static const LatLng dadarStationCoords = LatLng(19.0180, 72.8430); // Dadar Central
  static const LatLng marineLinesCoords = LatLng(18.9442, 72.8236); // Marine Lines Station
  static const LatLng csmtStationCoords = LatLng(18.9400, 72.8353); // CSMT Station
  static const LatLng wankhedeGate3Coords = LatLng(18.9389, 72.8258); // Wankhede Stadium Gate 3

  // Intermediate Real Railway GeoPoints along Mumbai Harbour Line
  static const List<LatLng> harbourLineCoords = [
    LatLng(19.0165, 72.8580), // Vadala Road
    LatLng(19.0002, 72.8553), // Sewri
    LatLng(18.9868, 72.8524), // Cotton Green
    LatLng(18.9774, 72.8488), // Reay Road
    LatLng(18.9663, 72.8438), // Dockyard Road
    LatLng(18.9525, 72.8398), // Sandhurst Road
    LatLng(18.9400, 72.8353), // CSMT Station
  ];

  // Intermediate Real Railway GeoPoints along Western Line
  static const List<LatLng> westernLineCoords = [
    LatLng(19.0180, 72.8430), // Dadar West
    LatLng(18.9950, 72.8300), // Lower Parel
    LatLng(18.9820, 72.8240), // Mahalakshmi
    LatLng(18.9690, 72.8190), // Mumbai Central
    LatLng(18.9550, 72.8180), // Grant Road
    LatLng(18.9490, 72.8200), // Charni Road
    LatLng(18.9442, 72.8236), // Marine Lines
  ];

  // Road Shuttle route Dadar -> Wankhede
  static const List<LatLng> shuttleCorridorCoords = [
    LatLng(19.0180, 72.8430), // Dadar TT Circle
    LatLng(19.0010, 72.8320), // Prabhadevi / Senapati Bapat Marg
    LatLng(18.9700, 72.8200), // Haji Ali / Pedder Road
    LatLng(18.9530, 72.8120), // Marine Drive North
    LatLng(18.9389, 72.8258), // Wankhede Stadium
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _simController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8500),
    );

    _simController.addListener(() {
      if (mounted) {
        setState(() {
          _simProgress = _simController.value;
        });
      }
    });

    _simController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _isSimulating = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _simController.dispose();
    super.dispose();
  }

  void _startSimulation() {
    setState(() {
      _isSimulating = true;
      _simProgress = 0.0;
    });
    _simController.forward(from: 0.0);
  }

  LatLng _getSimulatedLocation(List<LatLng> fullPath) {
    if (fullPath.isEmpty) return originCoords;
    final int count = fullPath.length - 1;
    if (count <= 0) return fullPath.first;

    final double segProgress = _simProgress * count;
    final int index = math.min(segProgress.floor(), count - 1);
    final double t = segProgress - index;

    final LatLng p1 = fullPath[index];
    final LatLng p2 = fullPath[index + 1];

    return LatLng(
      p1.latitude + (p2.latitude - p1.latitude) * t,
      p1.longitude + (p2.longitude - p1.longitude) * t,
    );
  }

  String _getCurrentSimulationMode(List<LatLng> fullPath) {
    if (fullPath.isEmpty) return "WALK";
    final int count = fullPath.length - 1;
    if (count <= 0) return "WALK";

    final double segProgress = _simProgress * count;
    final int index = math.min(segProgress.floor(), count - 1);

    if (widget.route.type == "FASTEST") {
      if (index == 0) return "WALK"; // Walk to Vadala
      if (index >= 1 && index < fullPath.length - 2) return "RAIL"; // Harbour train
      return "WALK"; // Walk CSMT -> Gate 3
    } else if (widget.route.type == "BALANCED") {
      if (index == 0) return "WALK"; // Walk to Kurla
      if (index == 1) return "RAIL"; // Central rail to Dadar
      if (index >= 2 && index < fullPath.length - 1) return "BUS"; // AC Shuttle to Stadium
      return "WALK";
    } else {
      // LOW_CROWD
      if (index == 0) return "WALK"; // Walk to Skywalk
      if (index >= 1 && index < fullPath.length - 2) return "RAIL"; // Western line
      return "WALK"; // Marine Drive walk to Gate 3
    }
  }

  IconData _getSimulatedIcon(String mode) {
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

  Color _getSimulatedModeColor(String mode) {
    switch (mode) {
      case "RAIL":
        return const Color(0xFF2563EB); // Royal Blue
      case "BUS":
        return const Color(0xFFEA580C); // Shuttle Orange
      case "METRO":
        return const Color(0xFF16A34A); // Green
      case "WALK":
      default:
        return AppTheme.ink; // Dark Ink
    }
  }

  String _getSimulatedLabel(String mode) {
    switch (mode) {
      case "RAIL":
        return widget.route.type == "FASTEST" ? "Harbour Fast Train" : "Suburban Local";
      case "BUS":
        return "AC Event Shuttle";
      case "WALK":
      default:
        return "Walking to Station";
    }
  }

  List<LatLng> _getFullRoutePoints() {
    if (widget.route.type == "FASTEST") {
      return [
        originCoords,
        ...harbourLineCoords,
        wankhedeGate3Coords,
      ];
    } else if (widget.route.type == "BALANCED") {
      return [
        originCoords,
        kurlaStationCoords,
        dadarStationCoords,
        ...shuttleCorridorCoords,
      ];
    } else {
      return [
        originCoords,
        ...westernLineCoords,
        wankhedeGate3Coords,
      ];
    }
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom + 0.8);
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom - 0.8);
  }

  void _resetBounds() {
    _mapController.move(
      const LatLng(18.9800, 72.8420), // Center of South Mumbai Corridor
      11.8,
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeType = widget.route.type;
    final isFastest = routeType == "FASTEST";
    final isBalanced = routeType == "BALANCED";
    final fullPoints = _getFullRoutePoints();

    // Map Center point (between Wadala & Wankhede)
    final LatLng mapCenter = const LatLng(18.9800, 72.8420);

    return Container(
      height: widget.height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E3DF),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.neutral, width: 1.0),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Stack(
        children: [
          // Real OpenStreetMap / CartoDB Light Vector-style Tiles
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: mapCenter,
              initialZoom: widget.height > 180 ? 11.6 : 10.8,
              minZoom: 9.0,
              maxZoom: 18.0,
              interactionOptions: InteractionOptions(
                flags: widget.isInteractive
                    ? InteractiveFlag.all
                    : InteractiveFlag.none,
              ),
            ),
            children: [
              // 100% Free OpenStreetMap with Pure True Black & Charcoal Grey OLED Matrix Filter
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.junction.attendee.app',
                maxZoom: 19,
                tileBuilder: (context, tileWidget, tile) {
                  return ColorFiltered(
                    colorFilter: const ColorFilter.matrix(<double>[
                      // Pure Black & Grey Monochrome Inversion (R = G = B everywhere, zero tint)
                      -0.18, -0.60, -0.06, 0, 218,
                      -0.18, -0.60, -0.06, 0, 218,
                      -0.18, -0.60, -0.06, 0, 218,
                       0.00,  0.00,  0.00, 1,   0,
                    ]),
                    child: tileWidget,
                  );
                },
              ),

              // Polyline Layer for Transit Paths
              PolylineLayer(
                polylines: [
                  // 1. Walk from Origin -> First Station (Dashed Neon Blue/Yellow)
                  if (isFastest)
                    Polyline(
                      points: const [originCoords, vadalaStationCoords],
                      color: widget.highlightedStepIndex == 0
                          ? AppTheme.yellow
                          : const Color(0xFF38BDF8),
                      strokeWidth: widget.highlightedStepIndex == 0 ? 5.0 : 3.5,
                      pattern: const StrokePattern.dotted(),
                    )
                  else if (isBalanced)
                    Polyline(
                      points: const [originCoords, kurlaStationCoords],
                      color: widget.highlightedStepIndex == 0
                          ? AppTheme.yellow
                          : const Color(0xFF38BDF8),
                      strokeWidth: widget.highlightedStepIndex == 0 ? 5.0 : 3.5,
                      pattern: const StrokePattern.dotted(),
                    )
                  else
                    Polyline(
                      points: const [originCoords, LatLng(19.0180, 72.8430)],
                      color: widget.highlightedStepIndex == 0
                          ? AppTheme.yellow
                          : const Color(0xFF38BDF8),
                      strokeWidth: widget.highlightedStepIndex == 0 ? 5.0 : 3.5,
                      pattern: const StrokePattern.dotted(),
                    ),

                  // 2. Railway Track Line (Blue for Harbour, Orange for Shuttle, Green for Western)
                  if (isFastest)
                    Polyline(
                      points: harbourLineCoords,
                      color: widget.highlightedStepIndex == 1
                          ? AppTheme.yellow
                          : const Color(0xFF3B82F6),
                      strokeWidth: widget.highlightedStepIndex == 1 ? 7.0 : 5.0,
                    )
                  else if (isBalanced) ...[
                    Polyline(
                      points: const [kurlaStationCoords, dadarStationCoords],
                      color: widget.highlightedStepIndex == 1
                          ? AppTheme.yellow
                          : const Color(0xFFFACC15),
                      strokeWidth: 5.0,
                    ),
                    Polyline(
                      points: shuttleCorridorCoords,
                      color: widget.highlightedStepIndex == 2
                          ? AppTheme.yellow
                          : const Color(0xFFFB923C),
                      strokeWidth: widget.highlightedStepIndex == 2 ? 7.0 : 5.5,
                    ),
                  ] else
                    Polyline(
                      points: westernLineCoords,
                      color: widget.highlightedStepIndex == 1
                          ? AppTheme.yellow
                          : const Color(0xFF10B981),
                      strokeWidth: widget.highlightedStepIndex == 1 ? 7.0 : 5.0,
                    ),

                  // 3. Walk from CSMT/Marine Lines -> Wankhede Stadium Gate 3
                  if (isFastest)
                    Polyline(
                      points: const [csmtStationCoords, wankhedeGate3Coords],
                      color: widget.highlightedStepIndex == 2
                          ? AppTheme.yellow
                          : const Color(0xFF38BDF8),
                      strokeWidth: widget.highlightedStepIndex == 2 ? 5.0 : 3.5,
                      pattern: const StrokePattern.dotted(),
                    )
                  else if (!isBalanced)
                    Polyline(
                      points: const [marineLinesCoords, wankhedeGate3Coords],
                      color: widget.highlightedStepIndex == 2
                          ? AppTheme.yellow
                          : const Color(0xFF38BDF8),
                      strokeWidth: widget.highlightedStepIndex == 2 ? 5.0 : 3.5,
                      pattern: const StrokePattern.dotted(),
                    ),
                ],
              ),

              // Marker Layer for Stations & Stadium Pins
              MarkerLayer(
                markers: [
                  // Origin Marker
                  Marker(
                    point: originCoords,
                    width: 90,
                    height: 40,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.ink,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "📍 Origin",
                            style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stations
                  if (isFastest) ...[
                    _buildStationMarker(vadalaStationCoords, "Vadala Rd"),
                    _buildStationMarker(csmtStationCoords, "CSMT (P1)"),
                  ] else if (isBalanced) ...[
                    _buildStationMarker(kurlaStationCoords, "Kurla"),
                    _buildStationMarker(dadarStationCoords, "Dadar Shuttle Bay"),
                  ] else ...[
                    _buildStationMarker(marineLinesCoords, "Marine Lines"),
                  ],

                  // Destination Stadium Pin (Wankhede Stadium Gate 3)
                  Marker(
                    point: wankhedeGate3Coords,
                    width: 120,
                    height: 55,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.yellow,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppTheme.ink, width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Text(
                            "🏟️ Wankhede Gate 3",
                            style: TextStyle(
                              color: AppTheme.ink,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppTheme.ink,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.yellow, width: 2),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Moving Attendee Live Avatar with Dynamic Transit Icon (Walk -> Train -> Bus)
                  if (_isSimulating) () {
                    final currentMode = _getCurrentSimulationMode(fullPoints);
                    final modeColor = _getSimulatedModeColor(currentMode);
                    final modeIcon = _getSimulatedIcon(currentMode);
                    final modeLabel = _getSimulatedLabel(currentMode);

                    return Marker(
                      point: _getSimulatedLocation(fullPoints),
                      width: 100,
                      height: 52,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.ink,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: modeColor, width: 1.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Text(
                              modeLabel,
                              style: TextStyle(
                                color: modeColor == AppTheme.ink ? AppTheme.yellow : modeColor,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: modeColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2.2),
                              boxShadow: [
                                BoxShadow(
                                  color: modeColor.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              modeIcon,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }(),
                ],
              ),
            ],
          ),

          // Top Header Overlay (Real Live Map Indicator)
          Positioned(
            top: 10,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.ink.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppTheme.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${widget.route.label.toUpperCase()} REAL TRANSIT MAP",
                        style: AppTheme.metaText(fontSize: 9, color: AppTheme.white),
                      ),
                    ],
                  ),
                ),

                // Live simulation action button
                if (widget.isInteractive)
                  MotionTap(
                    onTap: _isSimulating ? null : _startSimulation,
                    scaleDown: 0.94,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isSimulating ? AppTheme.green : AppTheme.yellow,
                        borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isSimulating ? Icons.directions_walk : Icons.play_arrow_rounded,
                            size: 12,
                            color: AppTheme.ink,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isSimulating ? "IN TRANSIT..." : "LIVE SIMULATE",
                            style: AppTheme.displayFont(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Map Zoom & Center Control Buttons
          if (widget.isInteractive)
            Positioned(
              right: 10,
              bottom: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildControlBtn(Icons.add, _zoomIn),
                  const SizedBox(height: 4),
                  _buildControlBtn(Icons.remove, _zoomOut),
                  const SizedBox(height: 4),
                  _buildControlBtn(Icons.center_focus_strong_outlined, _resetBounds),
                ],
              ),
            ),

          // Real Leaflet Tile Attribution & Legend Pill
          Positioned(
            left: 10,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                border: Border.all(color: AppTheme.neutralDark, width: 0.8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLegendItem("🚶 Walk", const Color(0xFF1E293B)),
                  const SizedBox(width: 8),
                  _buildLegendItem(
                    isBalanced ? "🚌 Shuttle" : "🚆 Rail",
                    isBalanced ? const Color(0xFFEA580C) : const Color(0xFF2563EB),
                  ),
                  const SizedBox(width: 8),
                  _buildLegendItem("🏟️ Wankhede", AppTheme.yellow),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Marker _buildStationMarker(LatLng point, String name) {
    return Marker(
      point: point,
      width: 80,
      height: 36,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: AppTheme.neutralDark, width: 0.6),
            ),
            child: Text(
              name,
              style: const TextStyle(fontSize: 7.5, fontWeight: FontWeight.bold, color: AppTheme.ink),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: AppTheme.ink,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTheme.metaText(fontSize: 8, color: AppTheme.ink),
        ),
      ],
    );
  }

  Widget _buildControlBtn(IconData icon, VoidCallback onTap) {
    return MotionTap(
      onTap: onTap,
      scaleDown: 0.92,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppTheme.neutralDark, width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 14, color: AppTheme.ink),
      ),
    );
  }
}
