"use client";

import React from "react";
import Link from "next/link";
import Image from "next/image";
import { useUser, UserButton } from "@clerk/nextjs";
import styles from "./landing.module.css";

export default function LandingPage() {
  const { isSignedIn, isLoaded } = useUser();

  return (
    <main className={styles.page}>
      {/* NAV */}
      <nav className={styles.nav}>
        <div className={styles.navBrand}>
          <span className={styles.navLogo}>JUNCTION</span>
        </div>
        <div className={styles.navLinks}>
          <a href="#solution" className={styles.navLink}>SOLUTION</a>
          <a href="#platform" className={styles.navLink}>PLATFORM</a>
          <a href="#about" className={styles.navLink}>ABOUT</a>
        </div>
        <div style={{ display: "flex", alignItems: "center", gap: 12, minHeight: 38 }}>
          {isLoaded && isSignedIn ? (
            <>
              <Link href="/organizer" className={`btn btn-primary ${styles.navCta}`}>
                OPEN COMMAND CENTER →
              </Link>
              <UserButton
                appearance={{
                  elements: {
                    userButtonAvatarBox: {
                      width: 34,
                      height: 34,
                      border: "2px solid #F5C400",
                      borderRadius: "4px",
                    },
                  },
                }}
              />
            </>
          ) : (
            <>
              <Link href="/login" className="btn btn-outline btn-sm" style={{ fontWeight: 700, letterSpacing: "0.04em", padding: "7px 14px" }}>
                SIGN IN
              </Link>
              <Link href="/sign-up" className={`btn btn-primary ${styles.navCta}`}>
                SIGN UP →
              </Link>
            </>
          )}
        </div>
      </nav>

      {/* HERO — ONE EDITORIAL CANVAS */}
      <section className={styles.hero}>
        {/* Top sweeping yellow curve background SVG */}
        <svg className={styles.topCurve} viewBox="0 0 1440 220" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
          <path d="M -20 100 C 180 230, 480 160, 680 0" stroke="#F5C400" strokeWidth="2.5" opacity="0.85" />
        </svg>

        <div className={styles.heroCanvas}>
          {/* LEFT: illustration — crisp & unmasked, occupying left side */}
          <div className={styles.heroArt} aria-hidden="true">
            <Image
              src="/junction_hero.png"
              alt=""
              fill
              priority
              sizes="54vw"
              className={styles.heroArtImg}
            />
          </div>

          {/* RIGHT: brand typography — in natural negative space, never overlapping art */}
          <div className={styles.heroCopy}>
            <div className={styles.eyebrow}>
              <span className={styles.eyebrowPill}>
                <span className={styles.eyebrowDot} />
                SIMULATED ENVIRONMENT
              </span>
              <span className={styles.eyebrowRule} />
              <span className={styles.eyebrowMeta}>MUMBAI · IPL SEASON 2026</span>
            </div>

            <h1 className={styles.heroTitle}>JUNCTION</h1>

            <h2 className={styles.heroTagline}>
              Orchestrating Every Journey<span className={styles.taglineDot}>.</span>
            </h2>

            <p className={styles.heroBody}>
              Every event creates thousands of journeys.<br />
              JUNCTION helps bring them together.
            </p>

            <div className={styles.heroCtas}>
              {isLoaded && isSignedIn ? (
                <Link href="/organizer" className={styles.ctaPrimary}>
                  ENTER OPERATIONS →
                </Link>
              ) : (
                <Link href="/login" className={styles.ctaPrimary}>
                  ENTER JUNCTION →
                </Link>
              )}
              <Link href="#solution" className={styles.ctaSecondary}>
                SEE HOW IT WORKS
              </Link>
            </div>

            <div className={styles.heroFooter}>
              <span className={styles.footerRule} />
              <span className={styles.footerMeta}>A MORE CONNECTED TOMORROW</span>
              <span className={styles.footerDots}>
                <span className={styles.footerDot} />
                <span className={styles.footerDot} />
                <span className={styles.footerDot} />
              </span>
            </div>
          </div>
        </div>
      </section>

      {/* HOW IT WORKS */}
      <section className={styles.howSection} id="solution">
        <div className={styles.howHeader}>
          <span className={styles.howEyebrow}>THE CORE LOOP</span>
          <h2 className={styles.howHeading}>
            The event is the trigger.<br />The destination is the system.
          </h2>
        </div>
        <div className={styles.loopGrid}>
          {[
            { step: "01", label: "OBSERVE", desc: "Crowd, transport, hotels, restaurants, roads — unified in real time." },
            { step: "02", label: "PREDICT", desc: "Forecast demand pressure at every node up to 60 minutes ahead." },
            { step: "03", label: "SIMULATE", desc: "Run what-if scenarios before pressure becomes a problem." },
            { step: "04", label: "RECOMMEND", desc: "Explainable, structured recommendations with expected impact." },
            { step: "05", label: "DECIDE", desc: "Organizers approve or reject. AI never acts autonomously." },
            { step: "06", label: "GUIDE", desc: "Attendees receive personalised route, stay, and timing guidance." },
          ].map((item) => (
            <div key={item.step} className={styles.loopCard}>
              <span className={styles.loopStep}>{item.step}</span>
              <h3 className={styles.loopLabel}>{item.label}</h3>
              <p className={styles.loopDesc}>{item.desc}</p>
            </div>
          ))}
        </div>
      </section>

      {/* THREE PORTALS */}
      <section className={styles.portalsSection} id="platform">
        <div className={styles.portalsHeader}>
          <span className={styles.portalsEyebrow}>THREE INTERFACES. ONE PLATFORM.</span>
          <h2 className={styles.portalsHeading}>Built for every stakeholder.</h2>
        </div>
        <div className={styles.portalsGrid}>
          <Link href="/organizer" className={styles.portalCard}>
            <div className={styles.portalIcon}>⌘</div>
            <h3 className={styles.portalTitle}>Organizer Command Center</h3>
            <p className={styles.portalDesc}>Destination map, pressure analytics, cascade tracing, what-if simulation, and recommendation approval.</p>
            <span className={styles.portalCta}>
              {isLoaded && isSignedIn ? "Open Command Center →" : "Sign In to Access →"}
            </span>
          </Link>
          <Link href="/attendee" className={styles.portalCard}>
            <div className={styles.portalIcon}>◎</div>
            <h3 className={styles.portalTitle}>Attendee Journey Platform</h3>
            <p className={styles.portalDesc}>Personalised route planning, accommodation recommendations, real-time alerts, food &amp; services guidance.</p>
            <span className={styles.portalCta}>Open Platform →</span>
          </Link>
          <div className={styles.portalCard} style={{ background: '#FFFEEA', borderColor: '#F5C400' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
              <div className={styles.portalIcon}>📱</div>
              <span className="pill pill-live" style={{ fontSize: '10px' }}>● APK READY</span>
            </div>
            <h3 className={styles.portalTitle}>Scan to Install Android App</h3>
            <p className={styles.portalDesc}>Scan with any phone camera on local Wi-Fi or download the release APK for real device testing.</p>
            <div style={{ display: 'flex', alignItems: 'center', gap: '14px', marginTop: '10px' }}>
              <img 
                src="/junction-qr.png" 
                alt="Scan to download APK" 
                style={{ width: '84px', height: '84px', borderRadius: '8px', border: '1px solid #CCCAB8', background: '#fff', padding: '4px' }} 
              />
              <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                <a 
                  href="/junction-attendee.apk" 
                  download 
                  className="btn btn-primary" 
                  style={{ fontSize: '12px', padding: '6px 14px', background: '#111', color: '#fff', textDecoration: 'none', borderRadius: '6px', textAlign: 'center', fontWeight: 'bold' }}
                >
                  ⬇ Download APK
                </a>
                <span style={{ fontSize: '10px', color: '#666', fontFamily: 'monospace' }}>v1.0.0 (49.9 MB)</span>
              </div>
            </div>
          </div>
          <Link href="/partner" className={styles.portalCard}>
            <div className={styles.portalIcon}>◈</div>
            <h3 className={styles.portalTitle}>Partner Portal</h3>
            <p className={styles.portalDesc}>Hotels, restaurants, and service operators update availability and receive event demand signals.</p>
            <span className={styles.portalCta}>
              Open Partner Portal →
            </span>
          </Link>
        </div>
      </section>

      {/* FOOTER */}
      <footer className={styles.footer}>
        <div className={styles.footerBrand}>
          <span className={styles.footerLogo}>JUNCTION</span>
          <span className={styles.footerTagline}>Orchestrating Every Journey</span>
        </div>
        <div className={styles.footerRight}>
          <span className="simulated-env-label tooltip-simulated">
            <span className="simulated-dot" />
            Simulated Environment · Prototype
          </span>
          <span className={styles.footerSmall}>Mumbai · IPL Season 2026 · All data simulated</span>
        </div>
      </footer>
    </main>
  );
}

function DestinationViz() {
  return (
    <svg
      viewBox="0 0 500 440"
      xmlns="http://www.w3.org/2000/svg"
      className={styles.destViz}
      aria-label="Destination intelligence schematic map"
    >
      <defs>
        <radialGradient id="appleWaterHome" cx="0%" cy="100%" r="100%">
          <stop offset="0%" stopColor="#0a1428" />
          <stop offset="100%" stopColor="#060b14" />
        </radialGradient>

        <linearGradient id="appleLandHome" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stopColor="#111624" />
          <stop offset="50%" stopColor="#141a29" />
          <stop offset="100%" stopColor="#0e1320" />
        </linearGradient>

        <linearGradient id="marineDriveGlowHome" x1="0%" y1="0%" x2="100%" y2="0%">
          <stop offset="0%" stopColor="#00f2fe" />
          <stop offset="100%" stopColor="#4facfe" />
        </linearGradient>

        <radialGradient id="halocritDarkHome" cx="50%" cy="50%" r="50%">
          <stop offset="0%" stopColor="#FF453A" stopOpacity="0.45" />
          <stop offset="50%" stopColor="#FF453A" stopOpacity="0.2" />
          <stop offset="100%" stopColor="#FF453A" stopOpacity="0" />
        </radialGradient>
        <radialGradient id="halohighDarkHome" cx="50%" cy="50%" r="50%">
          <stop offset="0%" stopColor="#FF9F0A" stopOpacity="0.4" />
          <stop offset="50%" stopColor="#FF9F0A" stopOpacity="0.18" />
          <stop offset="100%" stopColor="#FF9F0A" stopOpacity="0" />
        </radialGradient>
        <radialGradient id="halowatchDarkHome" cx="50%" cy="50%" r="50%">
          <stop offset="0%" stopColor="#FFD60A" stopOpacity="0.35" />
          <stop offset="50%" stopColor="#FFD60A" stopOpacity="0.15" />
          <stop offset="100%" stopColor="#FFD60A" stopOpacity="0" />
        </radialGradient>
        <radialGradient id="halomainDarkHome" cx="50%" cy="50%" r="50%">
          <stop offset="0%" stopColor="#0A84FF" stopOpacity="0.4" />
          <stop offset="100%" stopColor="#0A84FF" stopOpacity="0" />
        </radialGradient>

        <marker id="arrowAppleRedHome" markerWidth="7" markerHeight="5" refX="7" refY="2.5" orient="auto">
          <polygon points="0 0, 7 2.5, 0 5" fill="#FF453A" />
        </marker>
        <marker id="arrowAppleAmberHome" markerWidth="7" markerHeight="5" refX="7" refY="2.5" orient="auto">
          <polygon points="0 0, 7 2.5, 0 5" fill="#FF9F0A" />
        </marker>
        <marker id="arrowAppleCyanHome" markerWidth="7" markerHeight="5" refX="7" refY="2.5" orient="auto">
          <polygon points="0 0, 7 2.5, 0 5" fill="#0A84FF" />
        </marker>
      </defs>

      {/* 1. MAP BACKGROUND & COASTLINE */}
      <rect width="500" height="440" fill="url(#appleLandHome)" />

      {/* Arabian Sea / Coastline */}
      <path
        d="M 0 0 L 120 0 Q 90 200 75 300 Q 65 370 0 440 Z"
        fill="url(#appleWaterHome)"
        opacity="0.9"
      />
      <path
        d="M 120 0 Q 90 200 75 300 Q 65 370 0 440"
        stroke="#1d4ed8"
        strokeWidth="2.5"
        strokeOpacity="0.4"
        fill="none"
      />

      {/* Apple Dark Micro Grid Pattern */}
      <pattern id="dotsHome" x="0" y="0" width="22" height="22" patternUnits="userSpaceOnUse">
        <path d="M 22 0 L 0 0 0 22" fill="none" stroke="#222b40" strokeWidth="0.5" strokeOpacity="0.3" />
        <circle cx="11" cy="11" r="0.6" fill="#3b4866" opacity="0.3" />
      </pattern>
      <rect width="500" height="440" fill="url(#dotsHome)" />

      {/* Subtle City Blocks */}
      <g opacity="0.25">
        <rect x="170" y="140" width="45" height="35" rx="3" fill="#242e47" />
        <rect x="230" y="150" width="60" height="40" rx="3" fill="#242e47" />
        <rect x="300" y="140" width="50" height="30" rx="3" fill="#242e47" />
        <rect x="385" y="180" width="40" height="50" rx="3" fill="#242e47" />
        <rect x="170" y="250" width="55" height="45" rx="3" fill="#242e47" />
      </g>

      {/* === ROAD CASINGS & HIGHWAYS === */}
      <line x1="320" y1="290" x2="220" y2="350" stroke="#1b2336" strokeWidth="6" strokeLinecap="round" />
      <line x1="320" y1="290" x2="260" y2="295" stroke="#1b2336" strokeWidth="6" strokeLinecap="round" />
      <line x1="320" y1="290" x2="450" y2="240" stroke="#1b2336" strokeWidth="5" strokeLinecap="round" />
      <line x1="320" y1="290" x2="380" y2="130" stroke="#1b2336" strokeWidth="5" strokeLinecap="round" />
      <line x1="220" y1="350" x2="120" y2="380" stroke="#1b2336" strokeWidth="4" strokeLinecap="round" />
      <line x1="450" y1="240" x2="380" y2="130" stroke="#1b2336" strokeWidth="4" strokeLinecap="round" />

      {/* Road Inner Fills */}
      <line x1="320" y1="290" x2="220" y2="350" stroke="#2e3a55" strokeWidth="3" strokeLinecap="round" />
      <line x1="320" y1="290" x2="260" y2="295" stroke="#2e3a55" strokeWidth="3" strokeLinecap="round" />
      <line x1="320" y1="290" x2="450" y2="240" stroke="#2e3a55" strokeWidth="2.5" strokeLinecap="round" />
      <line x1="320" y1="290" x2="380" y2="130" stroke="#2e3a55" strokeWidth="2.5" strokeLinecap="round" />
      <line x1="220" y1="350" x2="120" y2="380" stroke="#2e3a55" strokeWidth="2" strokeLinecap="round" />
      <line x1="450" y1="240" x2="380" y2="130" stroke="#2e3a55" strokeWidth="2" strokeLinecap="round" />

      {/* Marine Drive Coastal Road Glow */}
      <path d="M 80 300 Q 180 330 260 295 Q 310 285 320 290" stroke="url(#marineDriveGlowHome)" strokeWidth="3" fill="none" strokeLinecap="round" />

      {/* === CROWD FLOW ARROWS === */}
      {/* Churchgate → Wankhede */}
      <g className={styles.flowArrow} style={{"--flow-delay":"0s"} as React.CSSProperties}>
        <line x1="235" y1="342" x2="300" y2="298" stroke="#FF453A" strokeWidth="2" strokeDasharray="5,4" markerEnd="url(#arrowAppleRedHome)" opacity="0.85" />
      </g>
      {/* CSMT → Wankhede */}
      <g className={styles.flowArrow} style={{"--flow-delay":"0.5s"} as React.CSSProperties}>
        <line x1="435" y1="248" x2="340" y2="284" stroke="#FF9F0A" strokeWidth="1.8" strokeDasharray="5,4" markerEnd="url(#arrowAppleAmberHome)" opacity="0.8" />
      </g>
      {/* Dadar → Wankhede */}
      <g className={styles.flowArrow} style={{"--flow-delay":"1s"} as React.CSSProperties}>
        <line x1="382" y1="148" x2="330" y2="278" stroke="#FFD60A" strokeWidth="1.6" strokeDasharray="5,4" markerEnd="url(#arrowAppleAmberHome)" opacity="0.7" />
      </g>
      {/* Marine Lines → Wankhede */}
      <g className={styles.flowArrow} style={{"--flow-delay":"1.5s"} as React.CSSProperties}>
        <line x1="274" y1="297" x2="306" y2="290" stroke="#0A84FF" strokeWidth="1.6" strokeDasharray="5,4" markerEnd="url(#arrowAppleCyanHome)" opacity="0.7" />
      </g>

      {/* === PRESSURE HALOS === */}
      <circle cx="220" cy="350" r="54" fill="url(#halocritDarkHome)" className={styles.haloAnimate} />
      <circle cx="320" cy="290" r="68" fill="url(#halomainDarkHome)" className={styles.haloAnimate} style={{"--halo-delay":"0.3s"} as React.CSSProperties} />
      <circle cx="450" cy="240" r="42" fill="url(#halowatchDarkHome)" className={styles.haloAnimate} style={{"--halo-delay":"0.7s"} as React.CSSProperties} />
      <circle cx="370" cy="340" r="32" fill="url(#halohighDarkHome)" className={styles.haloAnimate} style={{"--halo-delay":"1s"} as React.CSSProperties} />

      {/* === HOTEL & POI BADGES === */}
      <g>
        <rect x="156" y="256" width="12" height="12" rx="3" fill="#5E5CE6" stroke="#ffffff" strokeWidth="0.8" />
        <text x="162" y="265" fontSize="7" fill="#ffffff" textAnchor="middle">🛏️</text>
        <rect x="412" y="158" width="12" height="12" rx="3" fill="#5E5CE6" stroke="#ffffff" strokeWidth="0.8" />
        <text x="418" y="167" fontSize="7" fill="#ffffff" textAnchor="middle">🛏️</text>
      </g>

      {/* === RESTAURANT POI BADGES === */}
      <circle cx="192" cy="310" r="5" fill="#FF6482" stroke="#ffffff" strokeWidth="0.8" />
      <circle cx="350" cy="200" r="5" fill="#FF6482" stroke="#ffffff" strokeWidth="0.8" />

      {/* === TAXI/PICKUP ZONE === */}
      <rect x="345" y="325" width="50" height="22" rx="6" fill="#FF9F0A20" stroke="#FF9F0A" strokeWidth="1.5" />
      <text x="370" y="339" fontSize="7.5" fill="#FFD60A" fontFamily="system-ui, -apple-system" textAnchor="middle" fontWeight="700">🚕 TAXI HUB</text>

      {/* === STATION NODES (Apple Maps Dark 3D Badges) === */}
      {/* Churchgate */}
      <circle cx="220" cy="350" r="20" fill="#121827" stroke="#FF453A" strokeWidth="2.5" />
      <circle cx="220" cy="350" r="10" fill="#FF453A" fillOpacity="0.25" />
      <text x="220" y="354" fontSize="10" textAnchor="middle">🚆</text>
      <rect x="180" y="375" width="80" height="16" rx="4" fill="rgba(15, 23, 42, 0.85)" stroke="rgba(255, 255, 255, 0.1)" strokeWidth="0.8" />
      <text x="220" y="386" fontSize="7" fill="#f8fafc" fontFamily="system-ui" fontWeight="700" textAnchor="middle">CHURCHGATE</text>

      {/* Marine Lines */}
      <circle cx="260" cy="295" r="14" fill="#121827" stroke="#0A84FF" strokeWidth="2" />
      <circle cx="260" cy="295" r="7" fill="#0A84FF" fillOpacity="0.25" />
      <text x="260" y="299" fontSize="8" textAnchor="middle">🚇</text>

      {/* CSMT */}
      <circle cx="450" cy="240" r="17" fill="#121827" stroke="#FF9F0A" strokeWidth="2" />
      <circle cx="450" cy="240" r="9" fill="#FF9F0A" fillOpacity="0.25" />
      <text x="450" y="244" fontSize="9" textAnchor="middle">🏛️</text>
      <rect x="420" y="260" width="60" height="16" rx="4" fill="rgba(15, 23, 42, 0.85)" stroke="rgba(255, 255, 255, 0.1)" strokeWidth="0.8" />
      <text x="450" y="271" fontSize="7" fill="#f8fafc" fontFamily="system-ui" fontWeight="700" textAnchor="middle">CSMT · 58%</text>

      {/* Dadar */}
      <circle cx="380" cy="130" r="16" fill="#121827" stroke="#30D158" strokeWidth="2" />
      <circle cx="380" cy="130" r="8" fill="#30D158" fillOpacity="0.25" />
      <text x="380" y="134" fontSize="9" textAnchor="middle">🚉</text>
      <rect x="350" y="96" width="60" height="16" rx="4" fill="rgba(15, 23, 42, 0.85)" stroke="rgba(255, 255, 255, 0.1)" strokeWidth="0.8" />
      <text x="380" y="107" fontSize="7" fill="#f8fafc" fontFamily="system-ui" fontWeight="700" textAnchor="middle">DADAR · 58%</text>

      {/* === WANKHEDE — MAIN EVENT LANDMARK === */}
      <circle cx="320" cy="290" r="26" fill="#0d1424" stroke="#00f2fe" strokeWidth="2.5" />
      <circle cx="320" cy="290" r="18" fill="#10b98133" stroke="#30D158" strokeWidth="1.5" />
      <text x="320" y="295" fontSize="13" textAnchor="middle">🏟️</text>
      <rect x="270" y="322" width="100" height="20" rx="5" fill="#FF453A" stroke="#ffffff" strokeWidth="0.8" />
      <text x="320" y="335" fontSize="8" fill="#ffffff" fontFamily="system-ui" fontWeight="800" textAnchor="middle" letterSpacing="0.04em">
        WANKHEDE STADIUM
      </text>

      {/* === APPLE MAPS DARK LEGEND === */}
      <rect x="12" y="396" width="220" height="34" rx="8" fill="rgba(18, 24, 38, 0.9)" stroke="rgba(255, 255, 255, 0.12)" />
      <circle cx="26" cy="413" r="4" fill="#FF453A" />
      <text x="34" y="416" fontSize="7.5" fill="#f8fafc" fontFamily="system-ui" fontWeight="600">Critical</text>
      <circle cx="76" cy="413" r="4" fill="#FF9F0A" />
      <text x="84" y="416" fontSize="7.5" fill="#f8fafc" fontFamily="system-ui" fontWeight="600">High</text>
      <circle cx="120" cy="413" r="4" fill="#FFD60A" />
      <text x="128" y="416" fontSize="7.5" fill="#f8fafc" fontFamily="system-ui" fontWeight="600">Watch</text>
      <circle cx="166" cy="413" r="4" fill="#30D158" />
      <text x="174" y="416" fontSize="7.5" fill="#f8fafc" fontFamily="system-ui" fontWeight="600">Optimal</text>
    </svg>
  );
}
