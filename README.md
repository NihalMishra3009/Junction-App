# 🏟️ JUNCTION — Mega-Event Hospitality & Destination Orchestration

[![Version](https://img.shields.io/badge/Release-v1.0.0-0A84FF?style=for-the-badge)](https://github.com/NihalMishra3009/Junction-App/releases/tag/v1.0.0)
[![Next.js](https://img.shields.io/badge/Next.js%2016-React%2019-000000?style=for-the-badge&logo=next.js&logoColor=white)](https://nextjs.org)
[![Flutter](https://img.shields.io/badge/Flutter-Android%20%26%20Web-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)

**Junction** is an intelligent, destination-wide event orchestration platform designed for mega-events (e.g., IPL Finals, World Cups, Concerts). It combines accommodation, multi-modal transportation, venue operations, and crowd pressure prediction to deliver real-time decision support for organizers and personalized smart journey guidance for attendees.

---

## 📱 Quick Install on Any Phone (QR Scanner & APK Download)

Scan the QR code with any smartphone camera or click the download button below to install the **Junction Attendee App (v1.0.0)** instantly on your Android phone:

<div align="center">
  <img src="public/junction-qr.png" width="230" alt="Scan QR Code to Download & Install Junction Attendee App" />
  <br />
  <sub><b>👆 Point your phone camera at this QR code to download & install APK instantly</b></sub>
  <br /><br />
  <a href="https://github.com/NihalMishra3009/Junction-App/raw/main/public/junction-attendee.apk">
    <img src="https://img.shields.io/badge/Download-Android%20APK%20(Direct%20Download)-0A84FF?style=for-the-badge&logo=android&logoColor=white" height="42" />
  </a>
  <a href="https://github.com/NihalMishra3009/Junction-App/releases/tag/v1.0.0">
    <img src="https://img.shields.io/badge/GitHub-Release%20v1.0.0-238636?style=for-the-badge&logo=github&logoColor=white" height="42" />
  </a>
  <br /><br />
  <p><b>Direct APK Download Link:</b><br /><code>https://github.com/NihalMishra3009/Junction-App/raw/main/public/junction-attendee.apk</code></p>
</div>

---

## 🎯 App Workflow & Core Architecture

The core principle behind Junction is **"The event is the trigger; the destination is the system."**

```text
┌─────────────────────────────────────────────────────────────┐
│                      1. OBSERVE                             │
│   Gather destination state (Transport, Stays, Venues, Gates)│
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                 2. UNDERSTAND CAPACITY                      │
│   Map bottlenecks, track load thresholds & road pressure    │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                  3. PREDICT DEMAND                          │
│   Forecast crowd surge (+15m, +30m, +60m intervals)         │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│             4. RECOMMEND & SIMULATE (Human-in-Loop)         │
│   Generate dynamic interventions (Shuttles, Gate balancing) │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│             5. ATTENDEE & OPERATOR ACTION                   │
│   Personalized multi-modal routes & real-time gate guidance │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    6. OBSERVE NEW STATE                     │
│   Continuous live feedback loop to prevent destination grid │
└─────────────────────────────────────────────────────────────┘
```

---

## 🌟 Key Features

### 1. 🧭 Smart Multi-Modal Journey Planner (Attendee App)
- **Top-First Map Exploration**: Clean top-anchored interactive route maps with turn-by-turn platform and walking guidance.
- **Dynamic Route Ranking**:
  - **Fastest**: Direct high-capacity rail connectivity.
  - **Balanced ★**: Recommended dedicated shuttle corridors to bypass congested stations.
  - **Low Crowd**: Optimized for comfort and minimal queue times.
- **Live Destination Status**: Real-time venue gate queues, food zone crowd density, and nearby hotel availability.

### 2. 📊 Operator Decision Support & Live Simulation (Organizer Portal)
- **Live Destination Intelligence**: Real-time crowd pressure radar on major transit nodes (Churchgate, CSMT, Dadar, Marine Lines) and stadiums.
- **What-If Scenario Simulation**: Test rainfall impacts, transit delays, and shuttle fleet additions before approving interventions.
- **Human-in-the-Loop Approval**: Organizers retain full control to approve, modify, or reject system recommendations.

### 3. 🤝 Partner Coordination (Hospitality & Transit)
- **Zone Demand Heatmaps**: High, medium, and low occupancy zones for restaurants, hotels, and fleet operators.
- **Synchronized Readiness**: Real-time surge forecasts allowing local services to prepare capacity in advance.

---

## 💻 Tech Stack

### Web Application & Dashboards
- **Framework**: Next.js 16 (App Router, Turbopack)
- **UI & Components**: React 19, TypeScript
- **Styling**: Vanilla CSS Modules (Glassmorphism & Responsive Layouts)
- **Visualizations**: Recharts, Framer Motion, Lucide Icons

### Mobile Application
- **Framework**: Flutter 3 (Android & Web)
- **Language**: Dart
- **Map & Geo Engine**: Flutter Map / Leaflet Engine
- **Animations**: Flutter Animate & Custom Motion Gestures

---

## 🛠️ Local Development

### Run Web Application:
```bash
npm install
npm run dev
```
Open [http://localhost:3000](http://localhost:3000) in your browser.

### Run Mobile Application:
```bash
cd attendee_flutter_app
flutter pub get
flutter run
```

---

## 📄 License
MIT © 2026 [Junction Team](https://github.com/NihalMishra3009/Junction-App)
