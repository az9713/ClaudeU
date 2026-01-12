# Valuation Ratios Cheatsheet

Quick reference for stock valuation metrics. These ratios help answer: **"Is this stock expensive or cheap?"**

---

## Price-to-Earnings (P/E) Ratio

**Formula**: `Stock Price ÷ Earnings Per Share`

**What it tells you**: How much investors pay for $1 of company earnings

**Analogy**: Like asking "how many years of profit would it take to pay back the stock price?"

**Interpretation**:
| P/E Range | Meaning |
|-----------|---------|
| < 10 | Very low - possibly undervalued OR troubled business |
| 10-15 | Low - mature company or out of favor |
| 15-25 | Average for established companies |
| 25-40 | High - growth expectations priced in |
| > 40 | Very high - aggressive growth expectations |

**When to use**: Comparing companies in the SAME industry/sector

**Code Example**:
```python
pe_ratio = info.get('trailingPE')  # From yfinance
# or manually: stock_price / earnings_per_share
```

**⚠️ Gotcha**:
- Meaningless for companies with negative earnings (no P/E displayed)
- Trailing P/E uses past earnings; Forward P/E uses estimated future earnings
- Different industries have vastly different "normal" P/E ranges

---

## Price-to-Book (P/B) Ratio

**Formula**: `Stock Price ÷ Book Value Per Share`

**What it tells you**: Premium (or discount) to the company's accounting value

**Analogy**: Like comparing a car's sticker price to its scrap metal value

**Interpretation**:
| P/B Range | Meaning |
|-----------|---------|
| < 1.0 | Trading below book value (rare - investigate why!) |
| 1.0-2.0 | Low premium - value stocks, cyclical industries |
| 2.0-5.0 | Moderate premium - typical for quality companies |
| > 5.0 | High premium - intangibles, brand value, growth |

**When to use**: Asset-heavy industries (banks, insurance, manufacturing, real estate)

**Code Example**:
```python
pb_ratio = info.get('priceToBook')
```

**⚠️ Gotcha**:
- Less meaningful for tech companies (intangible assets like software, patents not fully captured)
- Book value can be distorted by accounting methods
- P/B < 1 could signal a value trap (declining business)

---

## Price-to-Sales (P/S) Ratio

**Formula**: `Market Cap ÷ Annual Revenue` or `Stock Price ÷ Revenue Per Share`

**What it tells you**: What you pay per dollar of revenue

**Analogy**: Like valuing a restaurant by how much food it sells, not profit

**Interpretation**:
| P/S Range | Meaning |
|-----------|---------|
| < 1.0 | Very low - may indicate undervaluation or problems |
| 1.0-3.0 | Reasonable for most industries |
| 3.0-10.0 | High - expecting margin improvement or growth |
| > 10.0 | Very high - typical for high-growth tech |

**When to use**: Unprofitable growth companies where P/E doesn't work

**Code Example**:
```python
ps_ratio = info.get('priceToSalesTrailing12Months')
```

**⚠️ Gotcha**:
- Ignores profitability entirely - a company can have high sales but lose money
- Different industries have vastly different margins
- SaaS companies often have P/S > 10 due to recurring revenue

---

## EV/EBITDA

**Formula**: `Enterprise Value ÷ EBITDA`

**What it tells you**: Company value relative to operating earnings, debt-neutral

**Why it matters**: Unlike P/E, this accounts for different capital structures (debt levels)

**Components**:
- **Enterprise Value (EV)** = Market Cap + Debt - Cash
- **EBITDA** = Earnings Before Interest, Taxes, Depreciation, Amortization

**Interpretation**:
| EV/EBITDA | Meaning |
|-----------|---------|
| < 6 | Low - potentially undervalued |
| 6-10 | Average for most industries |
| 10-15 | Above average - growth or quality premium |
| > 15 | High - aggressive growth expectations |

**When to use**: Comparing companies with different debt levels or tax situations

**Code Example**:
```python
ev_ebitda = info.get('enterpriseToEbitda')
```

**⚠️ Gotcha**:
- EBITDA ignores capital expenditure needs (some businesses need heavy reinvestment)
- Can be manipulated through accounting
- Less useful for financial companies

---

## PEG Ratio (Price/Earnings to Growth)

**Formula**: `P/E Ratio ÷ Annual EPS Growth Rate`

**What it tells you**: Whether growth justifies the P/E premium

**Rule of thumb**: PEG < 1 suggests growth at a reasonable price

**Interpretation**:
| PEG | Meaning |
|-----|---------|
| < 0.5 | Potentially undervalued relative to growth |
| 0.5-1.0 | Fairly valued - growth priced reasonably |
| 1.0-2.0 | Growth partially priced in |
| > 2.0 | Growth expectations may be too optimistic |

**Code Example**:
```python
peg = info.get('pegRatio')
```

**⚠️ Gotcha**:
- Growth rates are estimates (can be wrong)
- Doesn't work for declining companies (negative growth)
- Quality of growth matters (is it sustainable?)

---

## EV/Revenue (EV/Sales)

**Formula**: `Enterprise Value ÷ Annual Revenue`

**What it tells you**: Similar to P/S but accounts for debt and cash

**When to use**: Comparing companies with different capital structures

**Code Example**:
```python
ev_revenue = info.get('enterpriseToRevenue')
```

---

## Dividend Yield

**Formula**: `Annual Dividend ÷ Stock Price × 100`

**What it tells you**: Income return from dividends (ignoring price changes)

**Interpretation**:
| Yield | Meaning |
|-------|---------|
| 0% | No dividend (common for growth stocks) |
| 1-2% | Low yield, typical for growth companies paying token dividend |
| 2-4% | Moderate yield, balanced companies |
| 4-6% | High yield - income stocks, REITs |
| > 6% | Very high - may signal dividend cut risk |

**Code Example**:
```python
div_yield = (info.get('dividendYield') or 0) * 100  # Convert to percentage
```

**⚠️ Gotcha**:
- Very high yields often precede dividend cuts
- Yield rises when price falls (could be a trap)
- Compare to company's historical average

---

## Quick Comparison Function

```python
def compare_valuations(tickers):
    """Compare valuation ratios across multiple stocks"""
    import yfinance as yf
    import pandas as pd

    data = []
    for symbol in tickers:
        info = yf.Ticker(symbol).info
        data.append({
            'Ticker': symbol,
            'P/E': info.get('trailingPE'),
            'P/B': info.get('priceToBook'),
            'P/S': info.get('priceToSalesTrailing12Months'),
            'EV/EBITDA': info.get('enterpriseToEbitda'),
            'PEG': info.get('pegRatio')
        })

    return pd.DataFrame(data)

# Usage: compare_valuations(['AAPL', 'MSFT', 'GOOGL'])
```

---

## Industry Benchmarks

| Industry | Typical P/E | Typical P/B | Typical EV/EBITDA |
|----------|-------------|-------------|-------------------|
| Tech (Growth) | 25-50+ | 5-15+ | 15-25+ |
| Tech (Mature) | 15-25 | 3-8 | 10-15 |
| Banks | 8-15 | 0.8-1.5 | N/A |
| Insurance | 10-15 | 1-2 | 8-12 |
| Retail | 15-25 | 2-5 | 8-12 |
| Utilities | 15-20 | 1.5-2.5 | 8-12 |
| Healthcare | 15-25 | 3-6 | 10-15 |
| Consumer Staples | 20-30 | 4-8 | 12-18 |

---

## Common Mistakes to Avoid

### ❌ Comparing P/E Across Industries
```
Don't: "Amazon's P/E of 60 is too high because my bank has P/E of 10"
```

### ✅ Compare Within Same Industry
```
Do: "Amazon's P/E of 60 vs Walmart's 25 - what justifies the premium?"
```

---

### ❌ Ignoring Context
```
Don't: "P/E of 5 = cheap = buy"
```

### ✅ Investigate Why
```
Do: "P/E of 5 - why so low? Declining earnings? One-time gain? Industry issue?"
```

---

### ❌ Using Single Ratio
```
Don't: Decide based on P/E alone
```

### ✅ Use Multiple Ratios
```
Do: Check P/E, P/B, EV/EBITDA, and profitability together
```

---

## Related Resources

- Practice notebook: `tutor/notebooks/stock-analysis/fundamental-ratios.ipynb`
- Full example: `examples/stock-analysis.ipynb`
- Technical indicators: `tutor/reference/stock-analysis/technical-indicators.md`
