import pytest
from datetime import datetime


@pytest.fixture
def app():
    from app import app, db
    from app.models import User
    app.config.update(TESTING=True,
                      SQLALCHEMY_DATABASE_URI='sqlite://')
    db.create_all()
    User.create_or_update(username='testUser', birthday=datetime(2000, 1, 2))
    return app
