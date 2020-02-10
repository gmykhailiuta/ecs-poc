"""Models for app
"""
from app import db, app


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), index=True, unique=True)
    birthday = db.Column(db.DateTime)

    def __repr__(self):
        return '<User {} born on {}>'.format(self.username, self.birthday)

    @classmethod
    def create_or_update(self, **kw):
        result = False
        obj = self(**kw)

        user = self.find_by_username(obj.username)
        if user:
            user.birthday = obj.birthday
        else:
            db.session.add(obj)

        try:
            db.session.commit()
            result = True
        except AssertionError as e:
            db.session.rollback()
            app.logger.error(e)
        except Exception as e:
            db.session.rollback()
            app.logger.error(e)
        finally:
            db.session.close()
        return result

    @classmethod
    def find_by_username(self, username):
        return User.query.filter_by(username=username).first()

    @classmethod
    def available(self):
        return db.session.execute('SELECT 1')
