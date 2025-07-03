# (c) Hyperion Labs 2025

import time
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware

from mypkg.api.config import get_settings


# Fast API App
app = FastAPI(title=get_settings().app_name)


if get_settings().localhost:
    # Turnoff CORS if running on localhost
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
    print("this is localhost")


@app.middleware("http")
async def add_process_time_header(request: Request, call_next):
    start_time = time.time()
    response = await call_next(request)
    process_time = time.time() - start_time
    response.headers["X-Process-Time"] = str(process_time)
    return response


@app.get("/info")
async def get_info() -> dict[str, str]:
    return {
        "name": app.title
    }
