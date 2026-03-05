#!/bin/bash
echo "Esperando a que el LoadBalancer obtenga una IP pública..."
# Obtiene la URL externa del servicio de K8s
EXTERNAL_IP=""
while [ -z "$EXTERNAL_IP" ]; do
  EXTERNAL_IP=$(kubectl get svc payments-api-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
  [ -z "$EXTERNAL_IP" ] && sleep 10
done

echo "Probando API en: http://$EXTERNAL_IP/transfer"

# Prueba funcional básica
RESPONSE=$(curl -s -X POST "http://$EXTERNAL_IP/transfer" \
  -H "Content-Type: application/json" \
  -d '{"amount": 100, "vendor": "vendorA", "txhash": "0x123abc"}')

if [[ $RESPONSE == *"success"* ]]; then
  echo "✅ Prueba de despliegue exitosa"
  exit 0
else
  echo "❌ Prueba de despliegue fallida: $RESPONSE"
  exit 1
fi
