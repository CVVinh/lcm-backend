import os
import psycopg2
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from chalicelib.utils import secret_manager


secret = secret_manager.get_rds_key()

show_sql = False
log_level = os.environ.get('log_level', 'INFO')
if log_level == 'DEBUG':
    show_sql = True

# MySQLに接続。
url = f'mysql+pymysql://{secret["username"]}:{secret["password"]}@{secret["db_host"]}/{secret["db_name"]}?charset=utf8mb4'
engine = create_engine(
    url,
    echo=show_sql
)
Session = sessionmaker(bind=engine)
session = Session()


# db_host = "localhost"
# db_name = "postgre"
# db_user = "ims_local"
# db_password = "tTwRs&wV1"
# url = f"host='{db_host}' dbname='{db_name}' user='{db_user}' password='{db_password}'"
# engine = create_engine(
#     url,
#     echo=show_sql
# )

# Session = sessionmaker(bind=engine)
# session = Session()
