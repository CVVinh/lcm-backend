from contextlib import contextmanager
from chalicelib.models import session


@contextmanager
def transaction():
    try:
        yield
        session.commit()
    except Exception:
        session.rollback()
        raise
    finally:
        session.close()
