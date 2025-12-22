import pandas as pd

start_date = "2023-10-01" #for this repo, setting this as the start date in an Oct-Sep fiscal year
end_date = "2024-09-30" #setting this as the end date for an Oct-Sep fiscal year

dates = pd.date_range(start=start_date, end=end_date, freq="D")

def fiscal_year(date):
    return date.year + 1 if date.month >= 10 else date.year

def fiscal_period(date):
    return ((date.month - 10) % 12) + 1

calendar_df = pd.DataFrame({
    "calendar_date": dates,
    "fiscal_year": [fiscal_year(d) for d in dates],
    "fiscal_month": [fiscal_period(d) for d in dates]
})

calendar_df["fiscal_year_period"] = (
    calendar_df["fiscal_year"].astype(str) + calendar_df["fiscal_month"].astype(str)
    .str.zfill(2)
)

calendar_df.to_csv("healthcare_dbt_project/seeds/calendar.csv", index=False)
