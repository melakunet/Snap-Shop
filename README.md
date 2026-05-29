# Snap&Shop
Snap &amp; Shop — native iOS app that identifies products from a photo or short video and shows live prices across Amazon, Walmart, Best Buy &amp; more. Dual-tier scanning: Precision (single-photo) + Deep/Video (multimodal). SwiftUI · AVFoundation · SwiftData. triOS MWDMC capstone.

General Functionality
• Dual-mode camera scanning — Precision Scan for single high-accuracy photos, Deep / Video Scan for video
pans, multi-image bursts, and text hints.
• Seamless in-camera mode selector (Photo / Precision ↔ Video / Deep) built directly into the
AVFoundation capture view.
• Live price comparison across Amazon, Walmart, Best Buy, eBay, Target, B&H and more via SerpAPI Google
Shopping.
• Ranked results card showing best price, total price with shipping, rating, and direct retailer links.
• Trusted-retailer whitelist so users only see results from stores they actually shop at.
• Scan history with thumbnail, product name, mode used, date, and lowest price seen.
• Saved favorites with price-drop indicator on re-scan.
• Sign in with Apple for one-tap account creation (privacy-respecting, no passwords).
• Local-first storage with SwiftData; optional iCloud sync for multi-device access.
• Manual text search fallback when camera lighting is poor.
• Polished 3-slide onboarding flow that introduces both scan modes and the privacy promise, plus empty
states for first-launch UX.
• Dark mode support, accessible color contrast, VoiceOver labels, and Dynamic Type.
