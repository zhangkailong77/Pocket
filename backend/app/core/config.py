from pydantic_settings import BaseSettings
from typing import Optional

class Settings(BaseSettings):
    PROJECT_NAME: str = "Pocket"
    VERSION: str = "0.1.0"

    DATABASE_URL: str = "mysql+pymysql://root:123456@192.168.31.11:3306/pocket"

    UPLOAD_DIR: str = "/data/uploads"

    class Config:
        env_file = ".env"

settings = Settings()
