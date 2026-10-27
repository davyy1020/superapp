import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({
  subsets: ["latin"],
  display: "swap",
  variable: "--font-inter",
});

export const metadata = {
  title: "BISPIRA SuperApp - Executive Admin Portal",
  description: "Next.js Executive Control & Operations Suite for BISPIRA SuperApp",
  icons: {
    icon: "/favicon.ico",
  },
};

export default function RootLayout({ children }) {
  return (
    <html lang="id" className={inter.variable}>
      <head>
        <meta name="theme-color" content="#0B0F19" />
      </head>
      <body>{children}</body>
    </html>
  );
}
