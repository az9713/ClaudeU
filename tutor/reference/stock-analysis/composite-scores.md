# Composite Financial Health Scores Cheatsheet

Integrated metrics that combine multiple factors into a single score. These help quickly assess company quality.

---

## Piotroski F-Score (0-9)

**What it measures**: Overall financial strength across profitability, leverage, and efficiency

**Created by**: Joseph Piotroski (2000), designed to identify undervalued stocks with improving fundamentals

### The 9 Binary Tests

Each test scores 0 or 1. Total score: 0-9.

#### Profitability (4 points)

| # | Test | Condition | Rationale |
|---|------|-----------|-----------|
| 1 | ROA | Return on Assets > 0 | Company is profitable |
| 2 | CFO | Operating Cash Flow > 0 | Real cash generation |
| 3 | ΔROA | ROA increased vs prior year | Improving profitability |
| 4 | Accruals | Cash Flow > Net Income | Quality earnings (not accounting tricks) |

#### Leverage & Liquidity (3 points)

| # | Test | Condition | Rationale |
|---|------|-----------|-----------|
| 5 | ΔLeverage | Debt/Assets decreased | Reducing risk |
| 6 | ΔLiquidity | Current Ratio increased | Better short-term health |
| 7 | Equity | No new shares issued | No dilution |

#### Operating Efficiency (2 points)

| # | Test | Condition | Rationale |
|---|------|-----------|-----------|
| 8 | ΔMargin | Gross Margin increased | Pricing power or efficiency |
| 9 | ΔTurnover | Asset Turnover increased | Better asset utilization |

### Interpretation

| F-Score | Meaning | Historical Performance |
|---------|---------|------------------------|
| 0-2 | **Weak** - Poor fundamentals | Underperformed market |
| 3-5 | **Average** - Mixed signals | Market-like returns |
| 6-7 | **Strong** - Good fundamentals | Outperformed market |
| 8-9 | **Excellent** - Best-in-class | Significant outperformance |

### Simplified Code Example

```python
def simplified_f_score(info):
    """
    Simplified Piotroski F-Score (6 tests available from yfinance)
    Full version requires year-over-year comparisons
    """
    score = 0

    # 1. ROA > 0
    if (info.get('returnOnAssets') or 0) > 0:
        score += 1

    # 2. Operating Cash Flow > 0
    if (info.get('operatingCashflow') or 0) > 0:
        score += 1

    # 3. Cash Flow > Net Income (quality)
    ocf = info.get('operatingCashflow') or 0
    ni = info.get('netIncomeToCommon') or 0
    if ocf > ni:
        score += 1

    # 4. Current Ratio > 1
    if (info.get('currentRatio') or 0) > 1:
        score += 1

    # 5. Positive Profit Margin
    if (info.get('profitMargins') or 0) > 0:
        score += 1

    # 6. Positive Gross Margin
    if (info.get('grossMargins') or 0) > 0:
        score += 1

    return score  # Out of 6 (simplified)
```

### When to Use F-Score

**Best for**:
- Value investing (finding cheap stocks with improving fundamentals)
- Screening out "value traps"
- Comparing companies within same industry

**⚠️ Limitations**:
- Backward-looking (doesn't predict future)
- Requires year-over-year data for full calculation
- Less useful for high-growth companies (they may score low intentionally)

---

## Altman Z-Score

**What it measures**: Bankruptcy probability within 2 years

**Created by**: Edward Altman (1968), using discriminant analysis on historical bankruptcies

### The Formula

```
Z = 1.2×A + 1.4×B + 3.3×C + 0.6×D + 1.0×E
```

**Where**:
| Variable | Formula | What it measures |
|----------|---------|------------------|
| A | Working Capital / Total Assets | Liquidity |
| B | Retained Earnings / Total Assets | Cumulative profitability |
| C | EBIT / Total Assets | Operating efficiency |
| D | Market Value Equity / Total Liabilities | Leverage (market perspective) |
| E | Sales / Total Assets | Asset efficiency |

### Interpretation (Original Model - Manufacturing)

| Z-Score | Zone | Meaning |
|---------|------|---------|
| > 2.99 | **Safe Zone** | Low bankruptcy risk |
| 1.81 - 2.99 | **Grey Zone** | Some risk, needs monitoring |
| < 1.81 | **Distress Zone** | High bankruptcy risk |

### Modified Models

**For Private Companies** (Z'-Score):
```
Z' = 0.717×A + 0.847×B + 3.107×C + 0.420×D' + 0.998×E
```
Where D' = Book Value Equity / Total Liabilities

**For Non-Manufacturing** (Z''-Score):
```
Z'' = 6.56×A + 3.26×B + 6.72×C + 1.05×D'
```
Thresholds: > 2.6 safe, < 1.1 distress

### Code Example

```python
def calculate_z_score(info, balance_sheet):
    """
    Calculate Altman Z-Score (simplified)
    Note: Full calculation requires detailed balance sheet data
    """
    total_assets = info.get('totalAssets', 1)
    total_liabilities = info.get('totalDebt', 0)
    market_cap = info.get('marketCap', 0)
    revenue = info.get('totalRevenue', 0)

    # Approximations (full version needs more detailed data)
    working_capital = info.get('totalCurrentAssets', 0) - info.get('totalCurrentLiabilities', 0)
    retained_earnings = info.get('retainedEarnings', 0)
    ebit = info.get('ebitda', 0)  # Using EBITDA as proxy

    A = working_capital / total_assets if total_assets else 0
    B = retained_earnings / total_assets if total_assets else 0
    C = ebit / total_assets if total_assets else 0
    D = market_cap / total_liabilities if total_liabilities else 0
    E = revenue / total_assets if total_assets else 0

    z_score = 1.2*A + 1.4*B + 3.3*C + 0.6*D + 1.0*E
    return z_score
```

### When to Use Z-Score

**Best for**:
- Assessing credit risk
- Screening out potentially distressed companies
- Due diligence in value investing

**⚠️ Limitations**:
- Designed for manufacturing companies (less accurate for tech, finance)
- Based on 1960s data (economy has changed)
- Doesn't account for industry-specific factors
- Can flag healthy high-growth companies as "risky" (high D/E ratio)

---

## Beneish M-Score

**What it measures**: Likelihood of earnings manipulation

**Created by**: Messod Beneish (1999), studying companies that were later found to manipulate earnings

### The Formula

```
M = -4.84 + 0.92×DSRI + 0.528×GMI + 0.404×AQI + 0.892×SGI
    + 0.115×DEPI - 0.172×SGAI + 4.679×TATA - 0.327×LVGI
```

**Key Variables**:
| Variable | Name | What it detects |
|----------|------|-----------------|
| DSRI | Days Sales Receivables Index | Potential revenue inflation |
| GMI | Gross Margin Index | Margin deterioration |
| AQI | Asset Quality Index | Asset capitalization issues |
| SGI | Sales Growth Index | Pressure to meet expectations |
| DEPI | Depreciation Index | Accounting policy changes |
| SGAI | SG&A Index | Cost control issues |
| TATA | Total Accruals to Assets | Accrual manipulation |
| LVGI | Leverage Index | Financial distress |

### Interpretation

| M-Score | Meaning |
|---------|---------|
| < -2.22 | **Unlikely** to be manipulating earnings |
| > -2.22 | **Possible** earnings manipulation (investigate further) |

### When to Use M-Score

**Best for**:
- Fraud detection screening
- Due diligence before investing
- Forensic accounting

**⚠️ Limitations**:
- Complex to calculate (needs detailed financial statements)
- High-growth companies may trigger false positives
- Doesn't prove manipulation, only flags for investigation

---

## Tobin's Q

**What it measures**: Market value vs asset replacement cost

**Formula**:
```
Tobin's Q = Market Value of Company / Replacement Cost of Assets
         ≈ (Market Cap + Liabilities) / Total Assets
```

### Interpretation

| Q Value | Meaning |
|---------|---------|
| < 1.0 | Market values company below asset value (potentially undervalued) |
| = 1.0 | Market values company at asset replacement cost |
| > 1.0 | Market values company above assets (intangibles, growth premium) |
| >> 1.0 | Significant intangible value (brand, IP, growth expectations) |

### Code Example

```python
def calculate_tobins_q(info):
    """Simplified Tobin's Q"""
    market_cap = info.get('marketCap', 0)
    total_debt = info.get('totalDebt', 0)
    total_assets = info.get('totalAssets', 1)

    enterprise_value = market_cap + total_debt
    q = enterprise_value / total_assets if total_assets else 0
    return q
```

### When to Use Tobin's Q

**Best for**:
- Understanding market perception of intangible value
- Comparing across industries
- Academic research

---

## Quick Comparison Table

| Score | Range | Good Value | Focus Area |
|-------|-------|------------|------------|
| F-Score | 0-9 | 6-9 | Financial strength |
| Z-Score | -∞ to +∞ | > 2.99 | Bankruptcy risk |
| M-Score | -∞ to +∞ | < -2.22 | Earnings manipulation |
| Tobin's Q | 0 to +∞ | > 1.0 | Market vs book value |

---

## Combined Screening Strategy

**High-Quality Value Screen**:
```python
# Find undervalued companies with strong fundamentals
good_stocks = stocks[
    (stocks['PE'] < 15) &           # Cheap
    (stocks['FScore'] >= 6) &       # Strong fundamentals
    (stocks['ZScore'] > 2.5) &      # Low bankruptcy risk
    (stocks['MScore'] < -2.22)      # No manipulation flags
]
```

---

## Common Mistakes

### ❌ Relying on Single Composite Score
```
Wrong: "F-Score is 8, must be great!"
```

### ✅ Use Multiple Scores Together
```
Right: "F-Score 8 AND Z-Score > 3 AND M-Score < -2.22"
```

---

### ❌ Ignoring Industry Context
```
Wrong: Using Z-Score for a bank (not designed for financial companies)
```

### ✅ Use Appropriate Model
```
Right: Z-Score for manufacturing, industry-specific models for others
```

---

### ❌ Treating Scores as Absolute
```
Wrong: "Z-Score 2.0 means bankruptcy is coming"
```

### ✅ Treat as Screening Tool
```
Right: "Z-Score 2.0 warrants deeper investigation"
```

---

## Related Resources

- Practice notebook: `tutor/notebooks/stock-analysis/fundamental-ratios.ipynb`
- Full example: `examples/stock-analysis.ipynb`
- Indicator list: `docs/stock-indicators.md`
