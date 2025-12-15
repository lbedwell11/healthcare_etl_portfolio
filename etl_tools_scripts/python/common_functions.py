from datetime import date, datetime, timedelta
from dateutil.relativedelta import relativedelta

# define function for converting fiscal period to date format
def conv_fiscal_period_to_date(date_period: str):
    year = int(date_period[:4])
    month = int(date_period[4:6])
    # set up assumes fiscal year starts in October and ends in September

    if month > 3:
        return datetime(year, month - 3, 1).date()
    else:
        return datetime(year - 1, month + 9, 1).date()

# define function for converting a date to fiscal period format
def conv_date_to_fiscal_period(date_input):
    if isinstance(date_input, str):
        date_input = datetime.strptime(date_input, "%Y-%m-%d")
    shifted = date_input + relativedelta(months = 3)
    return f"{shifted.year}{shifted.month:02d}"

