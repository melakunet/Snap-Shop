# Competitor Research Notes — Google Lens

**App:** Google Lens (embedded in Google app and standalone on Android; iOS via Google app)
**Stores reviewed:** App Store, Google Play, SourceForge, Product Hunt, Google Search Community
**Research focus:** Critical and negative user feedback, unmet needs

---

## Recurring Pain Points

**1. Inaccurate product and object identification**
The most consistent complaint across platforms is that results are unreliable — correct sometimes, wrong often enough to frustrate users. Misidentification is worse in low light, with unusual angles, or on less-mainstream products.

**2. Internet dependency**
Almost every useful function — shopping search, translation, multi-search — requires a live connection. Users in areas with weak signal get a degraded or completely broken experience.

**3. Shopping results favour big brands and sponsored listings**
Users report that shopping results are skewed toward large retailers and promoted items rather than the most price-competitive match for what they actually photographed.

**4. Classic reverse image search removed / harder to reach**
A vocal subset of power users want the old Google reverse image search back. They find Lens replaces it with a worse workflow for their actual use cases (finding original sources, checking product authenticity, researching provenance).

**5. Privacy concerns**
Google's data practices are frequently cited. Users note that Lens shares data across Google's ecosystem — search history, scanned content, location — and that Google has received a "Grade E" rating from Terms of Service; Didn't Read for its broader privacy policies.

---

## Representative Quotes

> "Completely worthless. Negative 10. Waste of time."
> — Anonymous CEO, 1/10, SourceForge (Oct 2024)

> "far and away the lamest most frustrating app that I have ever tried"
> — Charlie B., SourceForge (Jun 2023) — tested multiple household items, got inaccurate results consistently

> "search results are not accurate all the time"
> — Balwinder B. (SDE), SourceForge (Jun 2022)

> "This is useful, but not always accurate. I've had times where it completely guesses the wrong product or plant."
> — Product Hunt reviewer, producthunt.com/products/google-lens/reviews

> "I want Google reverse image search back. Google Lens lacks the features that are useful to me."
> — Google Search Community, support.google.com/websearch/thread/265732706

---

## Takeaways for Snap & Shop

1. Accuracy on everyday products is a core differentiator opportunity — users tolerate one or two bad results before abandoning a tool.
2. A barcode/label fallback path (Precision mode) can cover the cases where visual recognition struggles.
3. Keep shopping results neutral and ranked by price, not by sponsorship — this directly addresses one of Lens's loudest complaints.
4. A privacy-respecting architecture (minimal data sent, no retained photos) will resonate with users who distrust Google's data collection.
