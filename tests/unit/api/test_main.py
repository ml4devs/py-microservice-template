# (c) Hyperion Labs 2025

import httpx
import pytest


from mypkg.api.main import app


@pytest.mark.asyncio
async def test_sanity():
    async with httpx.AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.get("/info")
    assert response.status_code == 200
    assert response.headers["content-type"] == "application/json"
    data = response.json()
    assert data["name"] == "Python Microservice Template"
    assert "X-Process-Time" in response.headers
    assert float(response.headers["X-Process-Time"]) > 0.0
