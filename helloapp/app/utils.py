from datetime import datetime
from app import app


def get_today():
    # Get datetime object with today's date with all bits empty except
    # year, month and day
    now = datetime.now()
    return datetime(now.year, now.month, now.day)


def days_to_birthday(birthday):
    # Takes birthday in datetime format
    # Returns days count (int) from today to next birthday
    today = get_today()
    birthday_this_year = datetime(today.year, birthday.month, birthday.day)
    birthday_next_year = datetime(today.year + 1, birthday.month, birthday.day)
    if birthday_this_year > today:
        return (birthday_this_year - today).days
    elif birthday_this_year < today:
        return (birthday_next_year - today).days
    else:
        return 0


def parse_birthday(birthday_str):
    # Try to convert str to datetime and return None if it fails
    try:
        return datetime.strptime(birthday_str, app.config['DATE_FORMAT'])
    except ValueError as e:
        app.logger.error(e)
        return None
