# Snap & Shop — Product Brief

## Vision
Snap & Shop turns any iPhone camera into a personal comparison-shopping assistant. A user points their camera at any product, the app identifies it, and immediately surfaces the best available price across major online retailers — eliminating manual searching and impulse overpaying.

---

## Target User
**Primary persona: The Value-Conscious Shopper**
A busy adult (25–45) who shops both in-store and online, cares about getting a fair price, and wants fast answers without switching between multiple apps or typing product names by hand. They are comfortable with smartphone cameras and expect results in seconds.

---

## Top 3 User Stories
1. As a value-conscious shopper, I want to snap a photo of a product on a store shelf and instantly see where I can buy it for less online, so that I can make a confident purchase decision on the spot.
2. As a deal-hunter, I want to see a ranked list of prices across Amazon, Walmart, Best Buy, eBay, and Target for any product I scan, so that I never pay more than I have to.
3. As a returning user, I want to revisit my scan history and re-check prices on products I previously saved, so that I can catch price drops before I commit to buying.

---

## MVP Scope (iOS Only)
- Camera capture screen with Precision (single-photo) and Deep (video / multi-image) scan modes
- Product identification: on-device vision classifier with server-side fallback
- Live price comparison via SerpAPI Google Shopping across Amazon, Walmart, Best Buy, eBay, and Target
- Ranked results card showing best price, total with shipping, retailer rating, and a direct buy link
- Trusted-retailer whitelist configurable by the user
- Scan history: thumbnail, product name, scan mode used, date, and lowest price seen
- Saved favourites with a price-drop indicator on re-scan
- Sign in with Apple for account creation (no passwords)
- Three-slide onboarding flow introducing both scan modes and the privacy promise
- Manual text-search fallback for poor camera conditions

---

## Success Metrics
1. **Scan-to-result time** — Precision mode returns results in ≤ 5 seconds (p95) on iPhone 12 or newer.
2. **Scan success rate** — ≥ 80 % of scans return at least one retailer result.
3. **Price breadth** — ≥ 70 % of successful scans include results from at least 3 distinct retailers.
4. **D7 retention** — ≥ 30 % of new users return within 7 days of first scan.
5. **Onboarding completion** — ≥ 85 % of new installs reach the Camera screen.

---

## Dual-Tier Scan Model

### Precision Scan (fast path)
Triggered by a single high-quality still photo. The app crops and compresses the image on-device, runs a lightweight vision classifier first, and sends only the cropped thumbnail to the server if the on-device confidence is below threshold. Target turnaround is under 5 seconds end-to-end. Best suited for clear, well-lit shots where a barcode, product label, or distinctive shape is visible. Presented to the user as a standard single-shutter camera view.

### Deep Scan (thorough path)
Triggered when the user switches to video mode or captures a multi-image burst, optionally adding a short text hint. The app sends video frames and/or multiple images to a multimodal server model that can reason across views and partial product information. Tolerates lower lighting, odd angles, and unlabelled items. Expected turnaround is 15–20 seconds; a progress indicator keeps the user informed. Presented as a video-capture view with a mode label reading "Deep Scan."

### Trigger logic
Precision is the default mode. The user can switch to Deep via an in-camera toggle. If a Precision scan returns low confidence, the app surfaces a prompt suggesting the user retry in Deep mode.

---

## Out of Scope for v1
- No Android support — this app is iOS only
- No in-app purchasing or checkout flow
- No social or sharing features (no wishlists shared with others, no feeds)
- No user-generated reviews or ratings
- No price-alert push notifications
- No augmented-reality overlay on the camera view
- No barcode-only scanner mode as a standalone feature
- No web or desktop version

---

**Approved by iOS supervisor:** _________________________ (date: ________)
