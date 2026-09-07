# 🏟️ JUNCTION — Mega-Event Hospitality & Destination Orchestration

[![Deployment](https://img.shields.io/badge/Railway-Ready-0B0D14?style=for-the-badge&logo=railway&logoColor=white)](https://railway.com)
[![Next.js](https://img.shields.io/badge/Next.js%2016-Turbopack-000000?style=for-the-badge&logo=next.js&logoColor=white)](https://nextjs.org)
[![Flutter](https://img.shields.io/badge/Flutter-Mobile%20%26%20Web-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Theme](https://img.shields.io/badge/Map%20Theme-Apple%20Maps%20Dark-111624?style=for-the-badge&logo=apple&logoColor=white)](https://apple.com)

**Junction** is an intelligent, destination-wide event orchestration platform designed for mega-events (e.g. IPL Finals, World Cups, Music Festivals). It combines accommodation, multi-modal transportation, venue operations, and crowd pressure prediction to deliver real-time decision support for organizers and personalized smart journey guidance for attendees.

---

## 📱 Quick Install on Any Phone (QR Code & Direct APK)

Install the **Junction Attendee App** on any Android device anywhere in seconds:

<div align="center">
  <img src="public/junction-qr.png" width="240" alt="Scan QR Code to Download & Install Junction Attendee App" />
  <br />
  <sub><b>👆 Scan this QR code with any smartphone camera to download & install instantly</b></sub>
  <br /><br />
  <a href="https://github.com/NihalMishra3009/Junction-App/releases/latest/download/junction-attendee.apk">
    <img src="https://img.shields.io/badge/Download-Android%20APK%20(Release)-0A84FF?style=for-the-badge&logo=android&logoColor=white" height="42" />
  </a>
  <br />
  <p>Direct Download URL: <code>https://github.com/NihalMishra3009/Junction-App/releases/latest/download/junction-attendee.apk</code></p>
</div>

---

## ✨ Key Capabilities

### 1. 🗺️ Apple Maps Dark Mode Destination Map
- **True Black & Charcoal OLED Base**: In-memory shader filter with zero external API key requirements.
- **Illuminated Road Networks & Coastlines**: High-contrast vector highways, glowing Marine Drive promenade ribbon, and Arabian Sea shoreline contours.
- **3D POI Badges & Pulse Halos**: Real-time crowd pressure radar halos on stations (Churchgate, CSMT, Dadar, Marine Lines) and Wankhede Stadium.
- **Apple Frosted Glass Floating Toolbar**: Multi-layer toggle controls with Apple blue glow active pills.

### 2. 🚆 Multi-Modal Journey Navigation (Attendee App)
- **Top-First Map Exploration**: Automatically resets view position so interactive maps and simulations are immediately visible at the top.
- **Smart Route Options**: Fastest (Rail), Balanced (Shuttle Corridor), and Low Crowd routes with platform info, walking times, and transfer guidance.
- **Live Destination Status**: Real-time gate queues, train frequency surges, and weather updates.

### 3. 📊 Operator Decision Support & What-If Simulation
- **Capacity & Bottleneck Tracking**: Early warning detection for station overload and transit delays.
- **Cascade Tracing**: Visualizes upstream/downstream ripple effects across roads and transit hubs.
- **Recommendation Engine**: Human-in-the-loop intervention approval for traffic diversion and shuttle dispatch.

---

## 🚀 One-Click Railway Deployment

The platform is pre-configured with a standalone Docker container ready for 1-click deployment on **Railway**:

1. Fork or push this repository to GitHub: `https://github.com/NihalMishra3009/Junction-App.git`
2. Open [railway.com](https://railway.com) -> **New Project** -> **Deploy from GitHub repo**.
3. Select `Junction-App`.
4. Railway will automatically detect the [Dockerfile](Dockerfile) and [railway.json](railway.json) configuration.
5. In **Settings** -> **Networking**, click **Generate Domain** (e.g. `https://junction-production.up.railway.app`).

---

## 🛠️ Local Development & Build

### Running the Web Platform (Next.js 16)
```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Build for production
npm run build

# Start production standalone server
npm run start
```

### Running the Attendee Mobile App (Flutter)
```bash
cd attendee_flutter_app

# Fetch dependencies
flutter pub get

# Run on connected phone or emulator
flutter run

# Build release APK
flutter build apk --release
```
The compiled APK will be at `attendee_flutter_app/build/app/outputs/flutter-apk/app-release.apk`.

---

## 🏷️ GitHub Release Instructions (To Host APK)

To publish a new version of the APK on GitHub:
1. Go to [https://github.com/NihalMishra3009/Junction-App/releases/new](https://github.com/NihalMishra3009/Junction-App/releases/new)
2. Enter tag version: `v1.0.0` and Release title: `Junction Attendee App v1.0.0`
3. Drag & drop `public/junction-attendee.apk` into the release binary attachment area.
4. Click **Publish release**.

---

## 📄 License
MIT © 2026 [Junction Team](https://github.com/NihalMishra3009/Junction-App)
