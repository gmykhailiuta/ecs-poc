# -*- coding: utf-8 -*-
"""Routes for app
"""

from flask import jsonify, request, make_response
from app import app
from app.models import User
from app.utils import days_to_birthday, parse_birthday, get_today


def _response(message, status_code):
    return make_response(jsonify({
        'message': message}), status_code)


@app.route('/hello/<username>', methods=['PUT'])
def create_or_update_user(username):
    if not username.isalpha():
        return _response(
            'Does username contain alphabetical characters only?', 400)
    if not request.json or 'dateOfBirth' not in request.json:
        return _response('Is "dateOfBirth" field present in request?', 400)

    birthday = parse_birthday(request.json['dateOfBirth'])
    if not birthday:
        return _response('Is dateOfBirth in format YYYY-MM-DD?', 400)

    if not birthday < get_today():
        return _response('Shouldn\'t the dateOfBirth be in the past?', 400)

    if User.create_or_update(username=username, birthday=birthday):
        return _response('User added/updated', 204)
    else:
        return _response('Could not create/update user', 500)


@app.route('/hello/<username>', methods=['GET'])
def get_user(username):
    if not username.isalpha():
        return _response(
            'Does username contain alphabetical characters only?', 400)

    user = User.find_by_username(username)
    if user is None:
        return _response(
            'Username "{}" not found in database'.format(username), 404)

    days = days_to_birthday(user.birthday)
    if days == 0:
        return _response(
            "Hello, {}! Happy birthday!".format(username), 200)
    elif days == 1:
        return _response(
            "Hello, {}! Your birthday is in {} day".format(username, days),
            200)
    else:
        return _response(
            "Hello, {}! Your birthday is in {} days".format(username, days),
            200)


@app.route('/healthcheck', methods=['GET'])
def healthcheck():
    if User.available():
        return _response('OK', 200)
    else:
        return _response('Database is not online', 500)


@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def catch_all(path):
    return 'Try /hello/<username>'
