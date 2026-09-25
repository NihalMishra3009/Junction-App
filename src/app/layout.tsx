import type { Metadata, Viewport } from "next";
import "./globals.css";
import { AppProvider } from "@/state/AppContext";

export const viewport: Viewport = {
  themeColor: "#0a0d14",
  width: "device-width",
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
};

export const metadata: Metadata = {
  title: "JUNCTION — Orchestrating Every Journey",
  description: "Intelligent event-driven destination orchestration platform. Understand destination pressure, predict bottlenecks, simulate interventions, and help organizers and attendees make better decisions.",
  keywords: ["event management", "crowd management", "destination intelligence", "journey planning", "Mumbai IPL"],
  manifest: "/manifest.json",
  appleWebApp: {
    capable: true,
    statusBarStyle: "black-translucent",
    title: "Junction",
  },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body suppressHydrationWarning>
        <ClerkProvider>
          <AppProvider>
            {children}
          </AppProvider>
        </ClerkProvider>
      </body>
    </html>
  );
}
