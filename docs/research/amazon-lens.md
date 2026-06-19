# Competitor Research Notes — Amazon Lens (Amazon Shopping App)

**App:** Amazon Shopping (visual search via in-app Lens / camera icon)
**Stores reviewed:** App Store (apps.apple.com/us/app/amazon-shopping/id297606951), Google Play (play.google.com/store/apps/details?id=com.amazon.mShop.android.shopping), AppFollow aggregator
**Research focus:** Critical and negative user feedback, unmet needs around visual search and price results

---

## Recurring Pain Points

**1. Slow and unresponsive interface**
Filter interactions in particular cause the app to hang. Users report waiting 10–15 seconds for a filter menu to appear after tapping a toggle, making multi-step product searches impractical.

**2. Sponsored results crowd out relevant matches**
Search results — including those triggered by a Lens scan — are heavily populated with paid placements. Users say they have to scroll past multiple irrelevant sponsored items before finding what they actually photographed.

**3. Intrusive AI assistant (Rufus) cannot be disabled**
Rufus, Amazon's AI shopping assistant, surfaces proactively during browsing and cannot be dismissed permanently. Users describe it as obstructive and interrupting to normal scanning and browsing flows.

**4. App crashes and freezes**
Broadly reported across both stores: the app freezes mid-session, requires force-close, and loses the scan in progress. The problem worsens with filters applied.

**5. Locked into Amazon's ecosystem**
Lens results are only sourced from Amazon's own catalogue. A scanned item that is sold cheaper on Walmart or Best Buy will never surface in results — users who want cross-retailer comparison must leave the app entirely.

---

## Representative Quotes

> "If you want to use filters or anything past the initial search, it is horrifyingly slow — so much so that you think it isn't taking commands."
> — App Store reviewer via AppFollow (apps.appfollow.io/android/amazon-shopping/...)

> "Glitches occur roughly 90% of the time when trying to filter after using the Prime toggle."
> — App Store reviewer via AppFollow

> "The app has gotten worse over time — especially when trying to filter searches."
> — Amazon Prime member, App Store via AppFollow

---

## Takeaways for Snap & Shop

1. Cross-retailer results are a structural gap Amazon will never fill — this is Snap & Shop's primary competitive advantage.
2. Speed matters: users explicitly call out 10–15 second waits as unacceptable; Precision mode's ≤5 s target is meaningful and must be hit.
3. Keep results unsponsored and ranked purely by price — users are acutely aware when sponsored items are being pushed.
4. Design the UI so that a completed scan never disappears unexpectedly; results must survive an accidental navigation tap.
