# (c) Hyperion Labs 2025

import json
from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    # Config from env file or secret dir
    app_name: str = "Python Microservice Template"
    localhost: bool = True
    debug: bool = True

    model_config = SettingsConfigDict(env_file=".env")


@lru_cache()
def get_settings():
    return Settings()


if __name__ == "__main__":
    print(json.dumps(dict(get_settings()), indent=2, sort_keys=True))
