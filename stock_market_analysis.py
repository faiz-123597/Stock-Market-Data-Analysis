import pandas as pd

df = pd.read_csv("stock_market_analyst_dataset-.csv")

print(df.head())

print("Shape:", df.shape)

print("\nColumns:")
print(df.columns)

print("\nData Types:")
print(df.dtypes)

df["date"] = pd.to_datetime(df["date"])

print(df.dtypes)

print("\nMissing Values:")
print(df.isnull().sum())

print("\nDuplicate Rows:")
print(df.duplicated().sum())

print("\nStatistical Summary:")
print(df[["open", "high", "low", "close", "volume"]].describe())

df["return_pct"] = ((df["close"] - df["open"]) / df["open"]) * 100

print("\nDaily Return:")
print(df[["date", "symbol", "company", "return_pct"]].head())

avg_return = (
    df.groupby(["symbol", "company"])["return_pct"]
      .mean()
      .round(2)
      .sort_values(ascending=False)
)

print("\nAverage Return by Company:")
print(avg_return)

import matplotlib.pyplot as plt
avg_return.plot(kind="bar", figsize=(12, 6))

plt.title("Average Daily Return by Company")
plt.xlabel("Company")
plt.ylabel("Average Return (%)")
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()
df["month"] = df["date"].dt.to_period("M")

monthly_return = (
    df.groupby("month")["return_pct"]
      .mean()
      .round(2)
)

print("\nMonthly Average Return:")
print(monthly_return)

monthly_return.plot(kind="line", figsize=(12, 6))

plt.title("Monthly Average Return")
plt.xlabel("Month")
plt.ylabel("Average Return (%)")
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

# Volatility Analysis
volatility = (
    df.groupby(["symbol", "company"])["return_pct"]
      .std()
      .round(2)
      .sort_values(ascending=False)
)

print("\nVolatility by Company:")
print(volatility)

# Volatility Chart
volatility.plot(kind="bar", figsize=(12, 6))

plt.title("Volatility by Company")
plt.xlabel("Company")
plt.ylabel("Volatility (%)")
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

# 7-Day Moving Average
df = df.sort_values(["symbol", "date"])

df["moving_avg_7"] = (
    df.groupby("symbol")["close"]
      .transform(lambda x: x.rolling(7).mean())
)

print("\n7-Day Moving Average:")
print(df[["date", "symbol", "close", "moving_avg_7"]].head(10))

# Final Company Summary
final_summary = (
    df.groupby(["symbol", "company"])
      .agg(
          avg_close=("close", "mean"),
          max_close=("close", "max"),
          min_close=("close", "min"),
          avg_return=("return_pct", "mean"),
          volatility=("return_pct", "std"),
          avg_volume=("volume", "mean")
      )
      .round(2)
      .sort_values("avg_return", ascending=False)
)

print("\n========== FINAL PYTHON SUMMARY ==========")
print(final_summary)