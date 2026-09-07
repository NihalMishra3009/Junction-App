"use client";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useApp } from "@/state/AppContext";
import styles from "./organizer.module.css";
import { SCENARIOS } from "@/data/mockScenarios";
import { ScenarioId } from "@/types";

const NAV = [
  { group: "OVERVIEW", items: [{ href: "/organizer", label: "Dashboard", icon: "▣" }] },
  { group: "DESTINATION", items: [
    { href: "/organizer/map", label: "Live Map", icon: "◉" },
    { href: "/organizer/capacity", label: "Capacity", icon: "◈" },
    { href: "/organizer/predictions", label: "Predictions", icon: "◇" },
  ]},
  { group: "DECISIONS", items: [
    { href: "/organizer/recommendations", label: "Recommendations", icon: "◆" },
    { href: "/organizer/simulation", label: "Simulation", icon: "◎" },
  ]},
  { group: "EVENT", items: [
    { href: "/organizer/event", label: "Event", icon: "★" },
  ]},
];

export default function OrganizerLayout({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  const { activeScenario, setScenario } = useApp();

  return (
    <div className={styles.shell}>
      {/* SIDEBAR */}
      <aside className={styles.sidebar}>
        <div className={styles.sidebarHeader}>
          <Link href="/" className={styles.sidebarLogo}>JUNCTION</Link>
        </div>
        <nav className={styles.sidebarNav}>
          {NAV.map(group => (
            <div key={group.group} className={styles.navGroup}>
              <span className={styles.navGroupLabel}>{group.group}</span>
              {group.items.map(item => {
                const isActive = item.href === "/organizer"
                  ? pathname === "/organizer"
                  : pathname.startsWith(item.href);
                return (
                  <Link
                    key={item.href}
                    href={item.href}
                    className={`${styles.navItem} ${isActive ? styles.navItemActive : ""}`}
                  >
                    <span className={styles.navIcon}>{item.icon}</span>
                    {item.label}
                  </Link>
                );
              })}
            </div>
          ))}
        </nav>
        <div className={styles.sidebarFooter}>
          <div className={styles.scenarioSelector}>
            <span className={styles.scenarioLabel}>SCENARIO</span>
            <select
              className={`select ${styles.scenarioSelect}`}
              value={activeScenario}
              onChange={e => setScenario(e.target.value as ScenarioId)}
            >
              {Object.values(SCENARIOS).map(s => (
                <option key={s.id} value={s.id}>{s.label}</option>
              ))}
            </select>
          </div>
          <div className={styles.simulatedEnv}>
            <span className="simulated-dot" />
            <span>SIMULATED ENVIRONMENT</span>
          </div>
        </div>
      </aside>

      {/* MAIN */}
      <div className={styles.main}>
        {/* HEADER */}
        <header className={styles.header}>
          <div className={styles.headerEvent}>
            <span className={styles.headerEventName}>Mumbai Indians vs Delhi Capitals</span>
            <span className={styles.headerEventMeta}>Wankhede Stadium · 33,000 expected attendees</span>
          </div>
          <div className={styles.headerRight}>
            <div className={styles.headerBadges}>
              <span className="pill pill-live">● LIVE</span>
              <span className="pill pill-simulated">SIMULATED</span>
              <span className={styles.headerTime}>19:30–22:30</span>
            </div>
            <button 
              onClick={() => {
                const modal = document.getElementById('qr-modal');
                if (modal) modal.style.display = 'flex';
              }}
              className="btn btn-yellow btn-sm"
              style={{ display: 'flex', alignItems: 'center', gap: '6px', fontWeight: 'bold' }}
            >
              <span>📱</span> Install App (QR)
            </button>
            <Link href="/attendee" className="btn btn-outline btn-sm">
              Attendee View →
            </Link>
          </div>
        </header>
        <div className={styles.content}>
          {children}
        </div>

        {/* POPUP QR SCANNER MODAL */}
        <div 
          id="qr-modal" 
          style={{
            display: 'none',
            position: 'fixed',
            inset: 0,
            backgroundColor: 'rgba(0,0,0,0.65)',
            backdropFilter: 'blur(4px)',
            zIndex: 9999,
            alignItems: 'center',
            justifyContent: 'center',
          }}
          onClick={(e) => {
            if (e.target === e.currentTarget) {
              e.currentTarget.style.display = 'none';
            }
          }}
        >
          <div style={{
            background: '#F6F5F1',
            borderRadius: '16px',
            padding: '28px',
            maxWidth: '380px',
            width: '90%',
            boxShadow: '0 20px 40px rgba(0,0,0,0.2)',
            border: '2px solid #F5C400',
            textAlign: 'center',
            position: 'relative',
          }}>
            <button 
              onClick={() => {
                const modal = document.getElementById('qr-modal');
                if (modal) modal.style.display = 'none';
              }}
              style={{
                position: 'absolute',
                top: '12px',
                right: '12px',
                background: '#E7E5DE',
                border: 'none',
                borderRadius: '50%',
                width: '28px',
                height: '28px',
                cursor: 'pointer',
                fontWeight: 'bold',
                fontSize: '14px',
              }}
            >
              ✕
            </button>
            <span className="pill pill-live" style={{ fontSize: '10px' }}>● ANDROID RELEASE READY</span>
            <h2 style={{ fontSize: '18px', fontWeight: '800', marginTop: '10px', marginBottom: '6px' }}>
              Scan to Install Junction
            </h2>
            <p style={{ fontSize: '12px', color: '#666', marginBottom: '16px' }}>
              Scan this QR code with any Android phone camera to download and test the app instantly.
            </p>
            <div style={{
              background: '#fff',
              padding: '12px',
              borderRadius: '12px',
              display: 'inline-block',
              border: '1px solid #CCCAB8',
              boxShadow: '0 4px 12px rgba(0,0,0,0.06)',
            }}>
              <img 
                src="/junction-qr.png" 
                alt="Scan to download APK" 
                style={{ width: '200px', height: '200px', display: 'block' }} 
              />
            </div>
            <div style={{ marginTop: '16px' }}>
              <a 
                href="/junction-attendee.apk" 
                download 
                className="btn btn-primary" 
                style={{ display: 'block', padding: '10px', background: '#111', color: '#fff', borderRadius: '8px', textDecoration: 'none', fontWeight: '700', fontSize: '13px' }}
              >
                ⬇ Direct Download APK (49.9 MB)
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
