import os
basedir = os.path.abspath(os.path.dirname(os.path.dirname(__file__)))


class Config(object):
    TESTING = os.getenv('TESTING', False)
    SQLALCHEMY_DATABASE_URI = os.getenv(
        'DATABASE_URI',
        'sqlite:///{}/app.db'.format(basedir))
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    DATE_FORMAT = os.getenv('DATE_FORMAT', '%Y-%m-%d')
    DEBUG = os.getenv('DEBUG', False)
