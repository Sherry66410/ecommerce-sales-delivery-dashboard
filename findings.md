# Findings Summary — E-Commerce Sales & Delivery (Olist)

*All money is in Brazilian reals (R$). Revenue = item price only (freight excluded).
On-time = delivered on or before the estimated date, compared at day level.
Impact figures are illustrative estimates built from this dataset and the stated assumptions, not audited numbers.*

## Headline numbers
- **R$13.22M** revenue across **96,470** delivered orders (average order ≈ R$137)
- **93.2%** of orders arrive on or before the estimated date, so **6.8% are late (6,534 orders)**
- Orders arrive **11.9 days early on average**, so delivery estimates are very conservative
- Average review score is **4.29 for on-time orders vs 2.27 for late orders**, a **2.02-point drop**

## Finding 1: Late delivery is strongly linked to bad reviews
Late orders are only 6.8% of volume, but they score about 2 points lower on a 5-point scale (4.29 → 2.27).

**Recommendation:** treat any order that passes its estimated date as a service-recovery case: proactive message, fast support contact, or a voucher.
**Estimated impact:** late orders represent ≈ R$0.99M of revenue (6,534 orders). If 10% of those customers would be retained with better service, that protects ≈ **R$99k**. *(Assumption: 10% retention uplift.)*

## Finding 2: Late deliveries are worst in the North-East, but Rio de Janeiro drives the volume
Alagoas (**78.6%** on-time), Maranhão (**82.6%**) and Sergipe (**84.8%**) have the lowest on-time rates, against a 93.2% average. Piauí, Ceará and Bahia are also below 88%. By volume, Rio de Janeiro (87.9% on-time across 12,350 orders) produces ≈ 1,500 late orders, roughly a quarter of all late deliveries. Even in the worst states average delivery is still earlier than estimated (AL: -8.7 days), so the problem is a tail of delayed orders, not a uniformly slow state.

**Recommendation:** fix carrier performance in RJ first (biggest volume impact), then review logistics partners in AL and MA (worst rates).
**Estimated impact:** lifting RJ to the 93.2% average removes ≈ 650 late orders (12,350 × 5.3 points), about **R$90-98k** of revenue (650 orders × R$137-151 average order value) no longer exposed to the 2-point review penalty.

## Finding 3: 35 high-revenue sellers have below-par ratings, and most also deliver late
35 sellers are in the top 10% by revenue but the bottom 25% by rating (all rated below 3.91; none reach 4.0). Together they generate **R$1.39M (11.0% of seller revenue)**, with an average rating of **3.59** and an average on-time rate of **89.0%** (platform: 93.2%). 22 of the 35 are below the platform on-time rate; the other 13 deliver on time, so their problem is rating rather than logistics. The clearest case is a São Paulo seller (7c67e1) with R$187k of revenue, a 3.35 rating and a 22-day average delivery time (platform: 12.5 days).

**Recommendation:** put these sellers on a performance plan (93% on-time target, 4.0 minimum rating), review quarterly, and restrict listings for those who don't improve, starting with the high-revenue sellers that miss both targets. For the 13 that already deliver on time, look at product quality and listing accuracy instead.
**Estimated impact:** raising their on-time rate from 89.0% to 93.2% cuts late orders on R$1.39M of revenue by 4.2 points, about **R$58k** moved out of the late-delivery group. *(Assumption: late share is roughly proportional to revenue.)*

## Bonus insight: delivery estimates are padded by ~12 days
Because orders arrive about 12 days earlier than promised, Olist could tighten estimates in low-risk regions, making the promise more competitive without increasing late deliveries.

## Additional observations

**Sales trend.** Monthly revenue grew through 2017 and peaked at R$988K in November 2017, then held between roughly R$0.7M and R$1.0M a month through August 2018. Growth flattened rather than continuing to climb.

**Payments.** Average order value tends to increase with the number of installments (counts are small at high installment numbers), from about R$100 for one installment to R$392 for 15 (installment counts with fewer than 30 orders are excluded). By primary payment type, credit card orders average R$143.24, boleto R$121.40, debit card R$119.72 and voucher R$94.80. This is an association: larger purchases are probably more likely to be split into installments, not the other way round.

## Assumptions and limitations
- Delivered orders only; seller analysis covers sellers with 5+ delivered orders.
- Seller thresholds differ by view: the seller scorecard uses sellers with 5+ delivered orders, while the Delivery dashboard's worst-sellers chart uses sellers with 20+ orders.
- Category is taken from the first item in each order, so "Top 10 Categories" assigns the whole order's revenue to that item's category.
- Review score is the average of an order's reviews; late-delivery impact shows association, not proven causation.
- Seller scorecard: average rating and average delivery days are calculated over order-item rows, so an order with several items from the same seller counts more than once, and an order with items from several sellers passes its review score to each. On-time % and order counts use distinct orders.
- Payment analysis: order value is item revenue (freight excluded), grouped by each order's primary payment type (the payment row with the largest value).

---
*The three impact estimates overlap (the same late orders appear in several), so don't add them together. Each shows the size of one lever on its own.*
