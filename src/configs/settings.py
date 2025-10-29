import os
from functools import cache
from pathlib import Path
from pydantic_settings import BaseSettings
from pydantic import computed_field

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
    POSTGRES_USER:str = "user"
    POSTGRES_PASSWORD:str = "password" 
    POSTGRES_DB:str = "shop"
    

    @computed_field
    def DATABASE_URL(self) -> str:
        return f"postgresql+asyncpg://{self.POSTGRES_USER}:{self.POSTGRES_PASSWORD}@postgres:5432/{self.POSGRES_DB}"

    model_config = {
            "env_file": f"{BASE_DIR}/.env",
            "case_sensitive": False,
            "extra": "ignore"
            }


@cache
def get_settings():
    return Settings()


settings = get_settings()
