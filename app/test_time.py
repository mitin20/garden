from app.main import app
import datetime
from fastapi.testclient import TestClient
from freezegun import freeze_time

client = TestClient(app)

@freeze_time("2012-01-14")
def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert datetime.datetime.now() == datetime.datetime(2012, 1, 14)