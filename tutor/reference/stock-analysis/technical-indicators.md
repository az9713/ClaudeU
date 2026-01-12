# Technical Indicators Cheatsheet

Quick reference for price-based and volume-based indicators. These help identify **trends, momentum, and potential reversals**.

---

## Trend Indicators

### Simple Moving Average (SMA)

**Formula**: `Sum of closing prices over N days ÷ N`

**What it tells you**: Average price over a period, smoothing out noise

**Common periods**:
- **20-day SMA**: Short-term trend
- **50-day SMA**: Medium-term trend
- **200-day SMA**: Long-term trend

**Signals**:
- Price above SMA = bullish trend
- Price below SMA = bearish trend
- **Golden Cross**: 50-day crosses above 200-day (bullish)
- **Death Cross**: 50-day crosses below 200-day (bearish)

**Code Example**:
```python
sma_20 = prices['Close'].rolling(window=20).mean()
sma_50 = prices['Close'].rolling(window=50).mean()
```

**⚠️ Gotcha**: Lagging indicator - signals come AFTER the move has started

---

### Exponential Moving Average (EMA)

**Formula**: Weighted average giving more importance to recent prices

**Difference from SMA**: Reacts faster to recent price changes

**Common periods**:
- **12-day EMA**: Used in MACD (fast)
- **26-day EMA**: Used in MACD (slow)
- **9-day EMA**: Often used as signal line

**Code Example**:
```python
ema_12 = prices['Close'].ewm(span=12, adjust=False).mean()
ema_26 = prices['Close'].ewm(span=26, adjust=False).mean()
```

**⚠️ Gotcha**: More sensitive = more whipsaws in choppy markets

---

### MACD (Moving Average Convergence Divergence)

**Components**:
1. **MACD Line**: 12-day EMA - 26-day EMA
2. **Signal Line**: 9-day EMA of MACD Line
3. **Histogram**: MACD Line - Signal Line

**Signals**:
| Signal | Meaning |
|--------|---------|
| MACD crosses above Signal | Bullish crossover |
| MACD crosses below Signal | Bearish crossover |
| Positive histogram growing | Momentum strengthening |
| Negative histogram shrinking | Downward momentum weakening |
| Divergence (price up, MACD down) | Potential reversal warning |

**Code Example**:
```python
ema_12 = prices['Close'].ewm(span=12, adjust=False).mean()
ema_26 = prices['Close'].ewm(span=26, adjust=False).mean()
macd_line = ema_12 - ema_26
signal_line = macd_line.ewm(span=9, adjust=False).mean()
histogram = macd_line - signal_line
```

**⚠️ Gotcha**:
- Lagging indicator - confirms trends rather than predicts
- Works poorly in sideways/ranging markets

---

### ADX (Average Directional Index)

**What it tells you**: Trend strength (not direction)

**Range**: 0 to 100

**Interpretation**:
| ADX Value | Meaning |
|-----------|---------|
| < 20 | Weak trend or no trend (ranging market) |
| 20-25 | Trend may be emerging |
| 25-50 | Strong trend |
| 50-75 | Very strong trend |
| > 75 | Extremely strong (possibly overextended) |

**⚠️ Gotcha**: ADX shows strength, not direction - use with other indicators

---

## Momentum Indicators

### RSI (Relative Strength Index)

**Formula**: `100 - (100 / (1 + RS))` where RS = Avg Gain / Avg Loss

**Range**: 0 to 100

**Standard period**: 14 days

**Interpretation**:
| RSI Value | Meaning |
|-----------|---------|
| > 70 | **Overbought** - price may be too high |
| 50-70 | Bullish momentum |
| 30-50 | Bearish momentum |
| < 30 | **Oversold** - price may be too low |

**Signals**:
- RSI crosses above 30 from below: Potential buy signal
- RSI crosses below 70 from above: Potential sell signal
- **Divergence**: Price makes new high, RSI doesn't = weakness

**Code Example**:
```python
def calculate_rsi(prices, period=14):
    delta = prices.diff()
    gain = delta.where(delta > 0, 0).rolling(period).mean()
    loss = (-delta.where(delta < 0, 0)).rolling(period).mean()
    rs = gain / loss
    return 100 - (100 / (1 + rs))

rsi = calculate_rsi(prices['Close'])
```

**⚠️ Gotcha**:
- Stocks can stay overbought/oversold for extended periods in strong trends
- More useful for ranging markets than trending markets

---

### Stochastic Oscillator

**Components**:
- **%K**: `((Current Close - Lowest Low) / (Highest High - Lowest Low)) × 100`
- **%D**: 3-day SMA of %K

**Range**: 0 to 100

**Interpretation**:
- > 80: Overbought
- < 20: Oversold
- %K crosses above %D: Bullish signal
- %K crosses below %D: Bearish signal

**⚠️ Gotcha**: Very sensitive, generates many signals (some false)

---

### CCI (Commodity Channel Index)

**What it tells you**: How far price has moved from its statistical mean

**Common interpretation**:
- CCI > +100: Overbought
- CCI < -100: Oversold
- Cross above +100: Strong uptrend beginning
- Cross below -100: Strong downtrend beginning

---

### Williams %R

**Range**: -100 to 0

**Interpretation**:
- Above -20: Overbought
- Below -80: Oversold

**Note**: Inverse logic compared to RSI

---

## Volatility Indicators

### Bollinger Bands

**Components**:
1. **Middle Band**: 20-day SMA
2. **Upper Band**: Middle + (2 × Standard Deviation)
3. **Lower Band**: Middle - (2 × Standard Deviation)

**What they tell you**: Volatility and relative price levels

**Signals**:
| Pattern | Meaning |
|---------|---------|
| Price touches upper band | Potentially overbought |
| Price touches lower band | Potentially oversold |
| Bands widening | Volatility increasing |
| Bands narrowing ("squeeze") | Low volatility, potential breakout coming |
| Price outside bands | Strong momentum (not necessarily reversal) |

**Code Example**:
```python
sma = prices['Close'].rolling(20).mean()
std = prices['Close'].rolling(20).std()
upper_band = sma + (2 * std)
lower_band = sma - (2 * std)
```

**⚠️ Gotcha**: Price CAN stay outside bands in strong trends - it's not an automatic reversal signal

---

### ATR (Average True Range)

**What it tells you**: Average price movement (volatility), in dollars/points

**Uses**:
- Setting stop-losses (e.g., 2× ATR below entry)
- Position sizing (larger ATR = smaller position)
- Comparing volatility across stocks

**Interpretation**:
- High ATR = high volatility
- Low ATR = low volatility
- Rising ATR = volatility increasing

**Code Example**:
```python
high_low = prices['High'] - prices['Low']
high_close = abs(prices['High'] - prices['Close'].shift())
low_close = abs(prices['Low'] - prices['Close'].shift())
true_range = pd.concat([high_low, high_close, low_close], axis=1).max(axis=1)
atr = true_range.rolling(14).mean()
```

---

### Keltner Channels

**Similar to Bollinger Bands but uses ATR instead of standard deviation**

- More consistent band width
- Less sensitive to sudden price spikes

---

## Volume Indicators

### OBV (On-Balance Volume)

**Formula**: Running total of volume × direction (+volume on up days, -volume on down days)

**What it tells you**: Buying vs selling pressure

**Signals**:
- OBV rising while price flat = potential bullish breakout
- OBV falling while price flat = potential bearish breakdown
- OBV divergence from price = warning signal

---

### VWAP (Volume Weighted Average Price)

**Formula**: `Cumulative (Price × Volume) / Cumulative Volume`

**What it tells you**: Average price weighted by volume (institutional benchmark)

**Uses**:
- Price above VWAP = bullish intraday
- Price below VWAP = bearish intraday
- Institutions often aim to buy below VWAP

**⚠️ Gotcha**: Resets daily - primarily an intraday indicator

---

### Chaikin Money Flow (CMF)

**What it tells you**: Money flow over a period (20 days typical)

**Interpretation**:
- CMF > 0: Buying pressure
- CMF < 0: Selling pressure
- CMF increasing: Accumulation
- CMF decreasing: Distribution

---

## Quick Reference Table

| Indicator | Type | Range | Overbought | Oversold |
|-----------|------|-------|------------|----------|
| RSI | Momentum | 0-100 | > 70 | < 30 |
| Stochastic | Momentum | 0-100 | > 80 | < 20 |
| CCI | Momentum | No limit | > +100 | < -100 |
| Williams %R | Momentum | -100 to 0 | > -20 | < -80 |
| ADX | Trend Strength | 0-100 | N/A | N/A |
| MACD | Trend/Momentum | No limit | N/A | N/A |
| Bollinger | Volatility | Price-based | Upper band | Lower band |
| ATR | Volatility | Price-based | N/A | N/A |

---

## Indicator Combinations

### Trend + Momentum Confirmation
```
Strong Signal:
- Price above 50 SMA (uptrend)
- RSI > 50 (bullish momentum)
- MACD above signal line (confirmation)
```

### Reversal Setup
```
Potential Bottom:
- RSI < 30 (oversold)
- Price at Bollinger lower band
- Bullish divergence (price makes lower low, RSI makes higher low)
```

### Breakout Detection
```
Potential Breakout:
- Bollinger bands squeezing (low volatility)
- Volume increasing
- ADX starting to rise from < 20
```

---

## Common Mistakes

### ❌ Using Overbought/Oversold in Strong Trends
```
Wrong: "RSI is 80, must sell!"
In strong uptrends, RSI can stay > 70 for weeks.
```

### ✅ Respect the Trend
```
Right: In uptrends, use RSI < 50 as buy opportunities.
       In downtrends, use RSI > 50 as sell opportunities.
```

---

### ❌ Acting on Single Indicator
```
Wrong: "MACD crossed, I'll trade immediately"
```

### ✅ Wait for Confirmation
```
Right: MACD crossed AND price above SMA AND RSI confirms
```

---

### ❌ Ignoring Volume
```
Wrong: "Price broke out of resistance" (but volume was low)
```

### ✅ Volume Confirms Price
```
Right: "Price broke resistance on 2× average volume" = stronger signal
```

---

## Related Resources

- Practice notebook: `tutor/notebooks/stock-analysis/technical-indicators.ipynb`
- Full example: `examples/stock-analysis.ipynb`
- Valuation ratios: `tutor/reference/stock-analysis/valuation-ratios.md`
