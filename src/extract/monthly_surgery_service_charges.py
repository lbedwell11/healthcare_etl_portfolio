from pathlib import Path
from src.db.connection import get_connection
from src.utils.logger import get_logger

logger = get_logger(__name__)
logger.info("starting surgery extraction")

def run_query(conn, sql_file, params=None):
    query = Path(sql_file).read_text()

    return conn.execute(
        query,
        parameters=params
    ).fetchdf()

db_conn = get_connection()

try:
    logger.info("running query")
    df = run_query(
        conn=db_conn,
        sql_file="./sql/surgery_service_charges.sql",
        params=['202404']
        )
    logger.info(f"query returned {len(df)} rows")
except Exception as e:
    logger.error(f"query failed: {e}")
    raise

print(df.head())
