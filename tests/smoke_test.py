import requests
import sys

# La URL vendría de una variable de entorno según el entorno de despliegue
API_URL = "http://localhost:8000" 

def test_transfer_flow():
    print("🚀 Iniciando pruebas de despliegue...")

    # Caso 1: Transacción exitosa con Vendor A
    payload_ok = {
        "amount": 100,
        "vendor": "vendorA",
        "txhash": "0x123456"
    }

    res = requests.post(f"{API_URL}/transfer", json=payload_ok)
    
    print(res.json())
    print(res.status_code)

    if res.status_code == 200 and res.json()["status"] == "success":
        print("✅ Test VendorA: PASSED")
    else:
        print(f"❌ Test VendorA: FAILED ({res.status_code})")
        sys.exit(1)

    # Caso 2: TxHash inválido (debe dar 404)
    payload_fail = {
        "amount": 100,
        "vendor": "vendorA",
        "txhash": "0x99999"
    }
    res_fail = requests.post(f"{API_URL}/transfer", json=payload_fail)

    if res_fail.status_code == 404:
        print("✅ Test Invalid TxHash: PASSED (404 found)")
    else:
        print(f"❌ Test Invalid TxHash: FAILED (Expected 404, got {res_fail.status_code})")
        sys.exit(1)

    print("🎉 Todas las pruebas de despliegue pasaron exitosamente.")

if __name__ == "__main__":
    test_transfer_flow()