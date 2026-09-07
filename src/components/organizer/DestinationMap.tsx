"use client";
import { useState } from "react";
import { Resource } from "@/types";
import { getPressureColor, getPressureLabel } from "@/components/ui/PressureIndicator";
import styles from "./DestinationMap.module.css";

interface Props {
  resources: Resource[];
  onSelectResource: (r: Resource) => void;
  selectedId: string | null;
}

const LAYERS = ["Crowd Pressure", "Transport", "Accommodation", "Restaurants", "Venues", "Roads", "Predicted Hotspots"];

const ROAD_PATHS = [
  { d: "M 320 290 L 220 350", id: "road1", name: "Churchgate Link" },
  { d: "M 320 290 L 260 295", id: "road2", name: "Marine Lines Ave" },
  { d: "M 320 290 L 450 240", id: "road3", name: "CSMT Express" },
  { d: "M 320 290 L 380 130", id: "road4", name: "Dadar Arterial" },
  { d: "M 220 350 L 120 395", id: "road5", name: "Nariman Point Way" },
  { d: "M 450 240 L 380 130", id: "road6", name: "Eastern Freeway Link" },
  { d: "M 260 295 L 220 350", id: "road7", name: "Maharshi Karve Rd" },
];

const RESOURCE_NODES = [
  { id: "WANKHEDE",       x: 320, y: 290, radius: 28, label: "WANKHEDE STADIUM", sublabel: "Match Venue · IPL Final", isVenue: true, icon: "🏟️" },
  { id: "CHURCHGATE",     x: 220, y: 350, radius: 18, label: "CHURCHGATE", sublabel: "Western Terminal", icon: "🚆" },
  { id: "CSMT",           x: 450, y: 240, radius: 17, label: "CSMT", sublabel: "Central Main Terminal", icon: "🏛️" },
  { id: "DADAR",          x: 380, y: 130, radius: 16, label: "DADAR", sublabel: "Major Junction", icon: "🚉" },
  { id: "MARINE_LINES",   x: 260, y: 295, radius: 14, label: "MARINE LINES", sublabel: "Suburban Station", icon: "🚇" },
  { id: "TAXI_ZONE",      x: 370, y: 340, radius: 13, label: "TAXI & RIDESHARE", sublabel: "Fleet Hub", icon: "🚕" },
  { id: "WANKHEDE_EXIT",  x: 320, y: 350, radius: 12, label: "GATES 1-7 EXIT", sublabel: "Pedestrian Flow", icon: "🚶" },
];

const HOTEL_MARKERS = [
  { x: 158, y: 258, name: "The Taj Mahal Palace", stars: "5★" },
  { x: 175, y: 265, name: "Trident Nariman Point", stars: "5★" },
  { x: 148, y: 312, name: "The Oberoi Mumbai", stars: "5★" },
  { x: 415, y: 162, name: "ITC Grand Central", stars: "5★" },
];

const RESTAURANT_MARKERS = [
  { x: 192, y: 310, name: "Pizza By The Bay" },
  { x: 350, y: 200, name: "Kyani & Co." },
  { x: 291, y: 256, name: "Gaylord Restaurant" },
];

export default function DestinationMap({ resources, onSelectResource, selectedId }: Props) {
  const [activeLayers, setActiveLayers] = useState(new Set(["Crowd Pressure", "Transport", "Venues", "Roads"]));

  const toggleLayer = (l: string) =>
    setActiveLayers(prev => { const n = new Set(prev); n.has(l) ? n.delete(l) : n.add(l); return n; });

  const getResource = (id: string) => resources.find(r => r.id === id);

  return (
    <div className={styles.mapWrap}>
      {/* APPLE MAPS DARK FLOATING LAYER TOOLBAR */}
      <div className={styles.layerBar}>
        <div className={styles.appleBadge}>
          <span className={styles.appleDot}></span>
          <span>APPLE MAPS DARK</span>
        </div>
        <div className={styles.buttonGroup}>
          {LAYERS.map(l => (
            <button
              key={l}
              className={`${styles.layerBtn} ${activeLayers.has(l) ? styles.layerActive : ""}`}
              onClick={() => toggleLayer(l)}
            >
              {l}
            </button>
          ))}
        </div>
      </div>

      {/* SVG MAP CANVAS */}
      <div className={styles.svgWrap}>
        <svg viewBox="0 80 520 340" xmlns="http://www.w3.org/2000/svg" className={styles.svg}>
          <defs>
            {/* Apple Maps Dark Gradient Definitions */}
            <radialGradient id="appleWater" cx="0%" cy="100%" r="100%">
              <stop offset="0%" stopColor="#0a1428" />
              <stop offset="100%" stopColor="#060b14" />
            </radialGradient>

            <linearGradient id="appleLand" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stopColor="#111624" />
              <stop offset="50%" stopColor="#141a29" />
              <stop offset="100%" stopColor="#0e1320" />
            </linearGradient>

            <linearGradient id="marineDriveGlow" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" stopColor="#00f2fe" />
              <stop offset="100%" stopColor="#4facfe" />
            </linearGradient>

            <radialGradient id="halocritDark" cx="50%" cy="50%" r="50%">
              <stop offset="0%" stopColor="#FF453A" stopOpacity="0.45" />
              <stop offset="50%" stopColor="#FF453A" stopOpacity="0.2" />
              <stop offset="100%" stopColor="#FF453A" stopOpacity="0" />
            </radialGradient>
            <radialGradient id="halohighDark" cx="50%" cy="50%" r="50%">
              <stop offset="0%" stopColor="#FF9F0A" stopOpacity="0.4" />
              <stop offset="50%" stopColor="#FF9F0A" stopOpacity="0.18" />
              <stop offset="100%" stopColor="#FF9F0A" stopOpacity="0" />
            </radialGradient>
            <radialGradient id="halowatchDark" cx="50%" cy="50%" r="50%">
              <stop offset="0%" stopColor="#FFD60A" stopOpacity="0.35" />
              <stop offset="50%" stopColor="#FFD60A" stopOpacity="0.15" />
              <stop offset="100%" stopColor="#FFD60A" stopOpacity="0" />
            </radialGradient>
            <radialGradient id="halonormalDark" cx="50%" cy="50%" r="50%">
              <stop offset="0%" stopColor="#30D158" stopOpacity="0.25" />
              <stop offset="100%" stopColor="#30D158" stopOpacity="0" />
            </radialGradient>

            {/* Neon Glow Filters */}
            <filter id="neonGlowBlue" x="-20%" y="-20%" width="140%" height="140%">
              <feGaussianBlur stdDeviation="3" result="blur" />
              <feMerge>
                <feMergeNode in="blur" />
                <feMergeNode in="SourceGraphic" />
              </feMerge>
            </filter>
            <filter id="neonGlowRed" x="-30%" y="-30%" width="160%" height="160%">
              <feGaussianBlur stdDeviation="4" result="blur" />
              <feMerge>
                <feMergeNode in="blur" />
                <feMergeNode in="SourceGraphic" />
              </feMerge>
            </filter>

            {/* Apple Maps Arrow Markers */}
            <marker id="arrAppleCyan" markerWidth="7" markerHeight="5" refX="7" refY="2.5" orient="auto">
              <polygon points="0 0, 7 2.5, 0 5" fill="#0A84FF" />
            </marker>
            <marker id="arrAppleRed" markerWidth="7" markerHeight="5" refX="7" refY="2.5" orient="auto">
              <polygon points="0 0, 7 2.5, 0 5" fill="#FF453A" />
            </marker>
            <marker id="arrAppleAmber" markerWidth="7" markerHeight="5" refX="7" refY="2.5" orient="auto">
              <polygon points="0 0, 7 2.5, 0 5" fill="#FF9F0A" />
            </marker>
          </defs>

          {/* 1. MAP BACKGROUND & TERRAIN */}
          <rect x="0" y="80" width="520" height="340" fill="url(#appleLand)" />

          {/* Arabian Sea / Coastline Geometry */}
          <path
            d="M 0 80 L 130 80 Q 95 200 80 300 Q 70 370 0 420 Z"
            fill="url(#appleWater)"
            opacity="0.9"
          />
          {/* Luminous Coastline Edge */}
          <path
            d="M 130 80 Q 95 200 80 300 Q 70 370 0 420"
            stroke="#1d4ed8"
            strokeWidth="2.5"
            strokeOpacity="0.4"
            fill="none"
          />
          <path
            d="M 130 80 Q 95 200 80 300 Q 70 370 0 420"
            stroke="#60a5fa"
            strokeWidth="0.8"
            strokeOpacity="0.6"
            fill="none"
          />

          {/* Apple Dark Micro Grid Pattern */}
          <pattern id="appleGrid" x="0" y="0" width="24" height="24" patternUnits="userSpaceOnUse">
            <path d="M 24 0 L 0 0 0 24" fill="none" stroke="#222b40" strokeWidth="0.5" strokeOpacity="0.3" />
            <circle cx="12" cy="12" r="0.6" fill="#3b4866" opacity="0.3" />
          </pattern>
          <rect x="0" y="80" width="520" height="340" fill="url(#appleGrid)" />

          {/* Subtle City Blocks / Building Footprints */}
          <g opacity="0.25">
            <rect x="180" y="140" width="45" height="35" rx="3" fill="#242e47" />
            <rect x="235" y="150" width="60" height="40" rx="3" fill="#242e47" />
            <rect x="305" y="140" width="50" height="30" rx="3" fill="#242e47" />
            <rect x="390" y="180" width="40" height="50" rx="3" fill="#242e47" />
            <rect x="230" y="220" width="45" height="35" rx="3" fill="#242e47" />
            <rect x="180" y="250" width="55" height="45" rx="3" fill="#242e47" />
            <rect x="360" y="270" width="65" height="40" rx="3" fill="#242e47" />
          </g>

          {/* 2. ROAD NETWORK (Apple Maps Dual-Stroke Illuminated Casing) */}
          {activeLayers.has("Roads") && (
            <g className={styles.roadsLayer}>
              {/* Under-glow / Road Base */}
              {ROAD_PATHS.map(p => (
                <path key={`base-${p.id}`} d={p.d} stroke="#1b2336" strokeWidth="6" fill="none" strokeLinecap="round" />
              ))}
              {/* Arterial Fill */}
              {ROAD_PATHS.map(p => (
                <path key={`fill-${p.id}`} d={p.d} stroke="#2e3a55" strokeWidth="3.5" fill="none" strokeLinecap="round" />
              ))}
              {/* Center Line Glow */}
              {ROAD_PATHS.map(p => (
                <path key={`center-${p.id}`} d={p.d} stroke="#475569" strokeWidth="1" strokeDasharray="3,3" fill="none" strokeLinecap="round" />
              ))}
              {/* Marine Drive Coastal Ribbon */}
              <path
                d="M 85 300 Q 185 335 260 295 Q 310 285 320 290"
                stroke="url(#marineDriveGlow)"
                strokeWidth="3.5"
                fill="none"
                strokeLinecap="round"
                filter="url(#neonGlowBlue)"
              />
              <text x="135" y="338" fontSize="7" fill="#60a5fa" fontFamily="system-ui, -apple-system, sans-serif" fontWeight="600" opacity="0.8">
                MARINE DRIVE PROMENADE
              </text>
            </g>
          )}

          {/* 3. CROWD FLOW ARROWS & PULSE BEAMS */}
          {activeLayers.has("Crowd Pressure") && (
            <g className={styles.flowLayer}>
              {/* Churchgate -> Wankhede High Flow */}
              <line x1="235" y1="342" x2="305" y2="300" stroke="#FF453A" strokeWidth="2.5" strokeDasharray="5,4" markerEnd="url(#arrAppleRed)" className={styles.flowLine} filter="url(#neonGlowRed)" />
              {/* CSMT -> Wankhede */}
              <line x1="435" y1="248" x2="345" y2="286" stroke="#FF9F0A" strokeWidth="2" strokeDasharray="5,4" markerEnd="url(#arrAppleAmber)" className={styles.flowLine} style={{"--d":"0.4s"} as React.CSSProperties} />
              {/* Dadar -> Wankhede */}
              <line x1="382" y1="150" x2="332" y2="278" stroke="#FFD60A" strokeWidth="1.8" strokeDasharray="5,4" markerEnd="url(#arrAppleAmber)" className={styles.flowLine} style={{"--d":"0.8s"} as React.CSSProperties} />
              {/* Marine Lines -> Wankhede */}
              <line x1="274" y1="296" x2="308" y2="290" stroke="#0A84FF" strokeWidth="1.8" strokeDasharray="5,4" markerEnd="url(#arrAppleCyan)" className={styles.flowLine} style={{"--d":"1.2s"} as React.CSSProperties} />
            </g>
          )}

          {/* 4. APPLE MAPS PRESSURE RADAR HALOS */}
          {activeLayers.has("Crowd Pressure") && resources.map(r => {
            const node = RESOURCE_NODES.find(n => n.id === r.id);
            if (!node) return null;
            const haloid = r.pressureLevel === "CRITICAL" ? "halocritDark" : r.pressureLevel === "HIGH" ? "halohighDark" : r.pressureLevel === "WATCH" ? "halowatchDark" : "halonormalDark";
            const haloR = node.radius * 3.2;
            return r.pressureLevel !== "NORMAL" ? (
              <circle key={`halo-${r.id}`} cx={node.x} cy={node.y} r={haloR} fill={`url(#${haloid})`} className={styles.haloAnimate} />
            ) : null;
          })}

          {/* 5. PREDICTED HOTSPOTS */}
          {activeLayers.has("Predicted Hotspots") && (
            <g>
              <circle cx="220" cy="350" r="50" fill="#FF453A15" stroke="#FF453A" strokeWidth="1.5" strokeDasharray="4,3" className={styles.pulseHotspot} />
              <circle cx="370" cy="340" r="32" fill="#FF9F0A15" stroke="#FF9F0A" strokeWidth="1.5" strokeDasharray="4,3" className={styles.pulseHotspot} />
              <text x="220" y="415" fontSize="7" fill="#FF453A" fontFamily="system-ui, -apple-system" fontWeight="700" textAnchor="middle">
                ⚠️ CRITICAL PREDICTED SURGE (+15m)
              </text>
            </g>
          )}

          {/* 6. ACCOMMODATION / HOTELS (Apple Maps Purple POI Badges) */}
          {activeLayers.has("Accommodation") && HOTEL_MARKERS.map((h, i) => (
            <g key={`hotel-${i}`} className={styles.poiBadge}>
              <circle cx={h.x + 6} cy={h.y + 6} r="10" fill="#5E5CE6" opacity="0.2" />
              <rect x={h.x} y={h.y} width="13" height="13" rx="4" fill="#5E5CE6" stroke="#ffffff" strokeWidth="1" />
              <text x={h.x + 6.5} y={h.y + 9.5} fontSize="7.5" fill="#ffffff" fontFamily="system-ui" textAnchor="middle" fontWeight="800">🛏️</text>
              <text x={h.x + 6.5} y={h.y + 21} fontSize="6.5" fill="#bf5af2" fontFamily="system-ui" textAnchor="middle" fontWeight="600">{h.name.split(" ")[0]}</text>
            </g>
          ))}

          {/* 7. RESTAURANTS / DINING (Apple Maps Coral POI Badges) */}
          {activeLayers.has("Restaurants") && RESTAURANT_MARKERS.map((r, i) => (
            <g key={`rest-${i}`} className={styles.poiBadge}>
              <circle cx={r.x} cy={r.y} r="8" fill="#FF6482" opacity="0.2" />
              <circle cx={r.x} cy={r.y} r="6" fill="#FF6482" stroke="#ffffff" strokeWidth="0.8" />
              <text x={r.x} y={r.y + 2.5} fontSize="6" fill="#ffffff" fontFamily="system-ui" textAnchor="middle" fontWeight="800">🍽️</text>
              <text x={r.x} y={r.y + 14} fontSize="6" fill="#ff9aa2" fontFamily="system-ui" textAnchor="middle" fontWeight="600">{r.name.split(" ")[0]}</text>
            </g>
          ))}

          {/* 8. TAXI / RIDESHARE ZONE (Apple Maps Amber Capsule) */}
          {activeLayers.has("Transport") && (
            <g>
              <rect x="345" y="325" width="50" height="22" rx="6" fill="#FF9F0A20" stroke="#FF9F0A" strokeWidth="1.5" />
              <text x="370" y="339" fontSize="8" fill="#FFD60A" fontFamily="system-ui, -apple-system" textAnchor="middle" fontWeight="700">🚕 TAXI HUB</text>
            </g>
          )}

          {/* 9. RESOURCE NODES & STATIONS (Apple Maps Dark 3D Badges) */}
          {RESOURCE_NODES.map(node => {
            const r = getResource(node.id);
            const p = r?.pressure || 50;
            const color = getPressureColor(p);
            const isSelected = selectedId === node.id;
            const isVenue = node.isVenue;

            return (
              <g
                key={node.id}
                className={styles.node}
                onClick={() => r && onSelectResource(r)}
                style={{ cursor: "pointer" }}
              >
                {/* Selection Ring Glow */}
                {isSelected && (
                  <circle
                    cx={node.x}
                    cy={node.y}
                    r={node.radius + 10}
                    fill="none"
                    stroke="#0A84FF"
                    strokeWidth="2.5"
                    strokeDasharray="6,4"
                    className={styles.selectedRing}
                  />
                )}

                {isVenue ? (
                  /* Iconic Stadium Landmark Pin */
                  <g>
                    <circle cx={node.x} cy={node.y} r={node.radius} fill="#0d1424" stroke="#00f2fe" strokeWidth="2.5" filter="url(#neonGlowBlue)" />
                    {/* Inner Pitch / Field Green */}
                    <circle cx={node.x} cy={node.y} r={node.radius - 8} fill="#10b98133" stroke="#30D158" strokeWidth="1.5" />
                    <text x={node.x} y={node.y + 6} fontSize="15" textAnchor="middle">🏟️</text>
                    
                    {/* Live Match Badge */}
                    <rect x={node.x - 34} y={node.y - node.radius - 12} width="68" height="15" rx="4" fill="#FF453A" stroke="#ffffff" strokeWidth="0.8" />
                    <text x={node.x} y={node.y - node.radius - 2} fontSize="7.5" fill="#ffffff" fontFamily="system-ui" fontWeight="800" textAnchor="middle" letterSpacing="0.05em">
                      ● LIVE VENUE
                    </text>
                  </g>
                ) : (
                  /* Apple Maps Transit / Infrastructure Capsule */
                  <g>
                    {/* Outer glow container */}
                    <circle cx={node.x} cy={node.y} r={node.radius} fill="#121827" stroke={color} strokeWidth="2" />
                    <circle cx={node.x} cy={node.y} r={node.radius * 0.55} fill={color} fillOpacity="0.25" />
                    <text x={node.x} y={node.y + 4} fontSize="9" textAnchor="middle">{node.icon || "📍"}</text>
                  </g>
                )}

                {/* Node Label Capsule */}
                <g transform={`translate(${node.x}, ${node.y + node.radius + 12})`}>
                  <rect
                    x="-42"
                    y="-8"
                    width="84"
                    height="18"
                    rx="5"
                    fill="rgba(15, 23, 42, 0.85)"
                    stroke="rgba(255, 255, 255, 0.12)"
                    strokeWidth="0.8"
                  />
                  <text
                    x="0"
                    y="1"
                    fontSize="7"
                    fill="#f8fafc"
                    fontFamily="system-ui, -apple-system, sans-serif"
                    fontWeight="700"
                    textAnchor="middle"
                    letterSpacing="0.02em"
                  >
                    {node.label}
                  </text>
                  {r && (
                    <text
                      x="0"
                      y="8"
                      fontSize="6.5"
                      fill={color}
                      fontFamily="system-ui, -apple-system, sans-serif"
                      textAnchor="middle"
                      fontWeight="800"
                    >
                      {p}% · {getPressureLabel(p)}
                    </text>
                  )}
                </g>
              </g>
            );
          })}
        </svg>
      </div>
    </div>
  );
}
