from fastapi.testclient import TestClient
from .api.main import app

client = TestClient(app)

def test_transfer_flow():
    print("🚀 Iniciando pruebas de despliegue...")

    # Caso 1: Transacción exitosa con Vendor A
    payload_ok = {
        "amount": 100,
        "vendor": "vendorA",
        "txhash": "0x123456"
    }

    response = client.post("/transfer", json=payload_ok)


    assert response.status_code == 200
    assert response.json()["status"] == "success"

    # Caso 2: TxHash inválido (debe dar 404)
    payload_fail = {
        "amount": 100,
        "vendor": "vendorA",
        "txhash": "0x99999"
    }
    response_fail = client.post("/transfer", json=payload_fail)

    assert response_fail.status_code == 404
