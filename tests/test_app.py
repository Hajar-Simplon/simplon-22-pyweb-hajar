from app import app


def test_home():
    client = app.test_client()

    response = client.get("/")

    assert response.status_code == 200
    assert response.data == b"Hello, world!"


def test_logs():
    client = app.test_client()

    client.get("/")

    response = client.get("/logs")

    assert response.status_code == 200