import json
from flask import url_for


def _create_or_update_user(client, username, birthday):
    mimetype = 'application/json'
    headers = {
        'Content-Type': mimetype,
        'Accept': mimetype
    }
    data = {'dateOfBirth': birthday}
    return client.put(
        url_for('create_or_update_user', username=username),
        data=json.dumps(data), headers=headers)


def _get_user(client, username):
    mimetype = 'application/json'
    headers = {
        'Content-Type': mimetype,
        'Accept': mimetype
    }
    return client.get(
        url_for('get_user', username=username), headers=headers)
