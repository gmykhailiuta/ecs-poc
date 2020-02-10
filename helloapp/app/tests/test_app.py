from datetime import timedelta
from app.utils import get_today
from app.config import Config
from utils import _create_or_update_user, _get_user
cfg = Config()


def test_create_user(client):
    assert _create_or_update_user(
        client, 'John-', '2000-01-01').status_code == 400
    assert _create_or_update_user(
        client, '', '2000-01-01').status_code == 405
    assert _create_or_update_user(
        client, 'John1', '2000-01-01').status_code == 400
    assert _create_or_update_user(
        client, 'John', '--???').status_code == 400
    assert _create_or_update_user(
        client, 'NotBorn', '2090-01-01').status_code == 400
    assert _create_or_update_user(
        client, 'John', '2000-01-01').status_code == 204
    assert _create_or_update_user(
        client, 'John', '2000-01-02').status_code == 204


def test_create_user_with_birthday_passed(client):
    username = 'PastMan'
    today = get_today()
    assert _get_user(client, username).status_code == 404
    birthday_str = (today.replace(year=today.year - 20) -
                    timedelta(days=10)
                    ).strftime(cfg.DATE_FORMAT)
    assert _create_or_update_user(
        client, username, birthday_str).status_code == 204
    res = _get_user(client, username)
    assert res.status_code == 200
    assert res.json == {
        'message': 'Hello, {}! Your birthday is in 356 days'.format(username)}


def test_create_user_with_birthday_in_future(client):
    username = 'FutureMan'
    today = get_today()
    assert _get_user(client, username).status_code == 404
    birthday_str = (today.replace(year=today.year - 20) +
                    timedelta(days=10)
                    ).strftime(cfg.DATE_FORMAT)
    assert _create_or_update_user(
        client, username, birthday_str).status_code == 204
    res = _get_user(client, username)
    assert res.status_code == 200
    assert res.json == {
        'message': 'Hello, {}! Your birthday is in 10 days'.format(username)}


def test_create_user_with_birthday_today(client):
    username = 'TodayMan'
    today = get_today()
    assert _get_user(client, username).status_code == 404
    birthday_str = (today.replace(year=today.year - 20)
                    ).strftime(cfg.DATE_FORMAT)
    assert _create_or_update_user(
        client, username, birthday_str).status_code == 204
    res = _get_user(client, username)
    assert res.status_code == 200
    assert res.json == {
        'message': 'Hello, {}! Happy birthday!'.format(username)}
