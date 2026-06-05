# Competitor Research Notes — CamFind

**App:** CamFind — Visual Search Engine
**Stores reviewed:** App Store (apps.apple.com/us/app/camfind/id595857716) — overall rating 2.3/5 from 519 ratings; Google Play (play.google.com/store/apps/details?id=com.msearcher.camfind)
**Research focus:** Critical and negative user feedback on product/object recognition accuracy

---

## Recurring Pain Points

**1. Severe accuracy decline over successive app updates**
Long-term users repeatedly note that early versions of CamFind were impressive — capable of recognising objects by combining visual shape, colour, and readable text. After multiple updates the recognition engine deteriorated significantly and has not recovered. The regression has been tracked by the same users across years.

**2. Failure on labelled, branded items**
The most striking complaint is that CamFind cannot identify products even when the brand name or product name is physically printed on the object in the camera frame. Users tested clearly labelled everyday items — staplers, water bottles, packaged goods — and received either wrong category results or no results at all.

**3. Text recognition is broken or absent**
An older version combined OCR (reading text on labels) with visual recognition to deliver accurate product descriptions including brand names. Reviewers confirm that text recognition appears to have been removed or broken in current versions, removing the most reliable fallback path.

**4. Barcode scanning remains the only reliable feature**
Several reviewers note that scanning a barcode still returns a correct result, but that this is the minimum viable function of any scanner app. The visual (camera-based) recognition — CamFind's differentiating feature — no longer works reliably.

**5. Poor results on uncommon or thrift-store items**
Users specifically trying to identify second-hand or unlabelled items (the use case where visual recognition would be most valuable) report complete failure.

---

## Representative Quotes

> "Identified the stapler as a metal storage cabinet."
> — David (Nashville, TN), 2/5, App Store (Jan 2019)

> "Miss-identifies the type of object most of the time."
> — VbMe, 1/5, App Store (Oct 2024)

> "The very first versions worked great and were accurate. Now it can no longer get even the simplest of objects correct — even when the object has its name printed on it. The object recognition engine seems to have gotten a lobotomy. The current version no longer functions with any semblance of accuracy or repeatability."
> — Anonymous reviewer, 1/5, App Store (Apr 2019)

> "Completely useless. I downloaded this to find product info for a table I found at a thrift store. It not only failed that task, it couldn't identify anything across at least 10 different items. Even a basic water bottle barcode returned no results."
> — Google Play reviewer (paraphrased from App Store/Play cross-reference)

---

## Takeaways for Snap & Shop

1. Combining visual recognition with OCR (reading text on the label) is a hard requirement, not a nice-to-have — CamFind's biggest regression was losing exactly this.
2. Maintain recognition quality across app updates; users track regression over time and publicly document it. A degrading model will destroy trust faster than a slow model.
3. The thrift-store / unlabelled-item use case is completely unserved — Deep Scan's multi-image, multimodal approach is specifically designed for this gap.
4. Barcode fallback (Precision mode) sets a reliability floor, but visual recognition must work too, or the app has no advantage over any barcode scanner.
