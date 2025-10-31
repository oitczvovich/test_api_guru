import os
from functools import cache
from pathlib import Path
from typing import Optional
from pydantic_settings import BaseSettings
from pydantic import PostgresDsn, model_validator
from urllib.parse import quote


BASE_DIR = Path(__file__).resolve().parent.parent.parent
print("BASE_DIR", BASE_DIR)
if os.path.exists(str(BASE_DIR / ".env")):
    ENV_FILE = ".env"
else:
    ENV_FILE = ".env.example"


class Settings(BaseSettings):
    """Настройки проекта."""

    DEBUG: bool = False
    # Database
    DATABASE_URL: Optional[PostgresDsn] = None
    POSTGRES_USER: str = "user"
    POSTGRES_PASSWORD: str = "password"
    POSTGRES_HOST: str = "localhost"
    POSTGRES_PORT: int = 5432
    POSTGRES_DB: str = "shop"

    @model_validator(mode="after")
    def set_database_url(self):
        if self.DATABASE_URL is None:
            password_encode = quote(self.POSTGRES_PASSWORD)

            database_url = (f"postgresql+asyncpg://{self.POSTGRES_USER}:{password_encode}@{self.POSTGRES_HOST}:{self.POSTGRES_PORT}/{self.POSTGRES_DB}")
            self.DATABASE_URL = PostgresDsn(database_url)
        return self


@cache
def get_settings():
    return Settings()


settings = get_settings()
