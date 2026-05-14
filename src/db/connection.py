from dotenv import load_dotenv
import os
import duckdb

load_dotenv()

def get_connection(db_path: str = os.getenv("DUCKDB_PATH")):
    # db_path = os.getenv("DUCKDB_PATH")
    """
    CREATE AND RETURN A DUCKDB CONNECTIONS.
    """
    return duckdb.connect(db_path)
