from prometheus_fastapi_instrumentator import Instrumentator
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from .blockchain_mock import validate_txhash
from .vendor_factory import get_vendor
from .observability.logger import logger
from .observability.metrics import transfer_success, transfer_fail, transfer_latency
import time


app = FastAPI()
Instrumentator().instrument(app).expose(app)

class TransferRequest(BaseModel):
    amount: int
    vendor: str
    txhash: str

@app.post("/transfer")
def transfer(req: TransferRequest):

    start = time.time()
    logger.info(f"Transfer request vendor={req.vendor}")

    tx_status = validate_txhash(req.txhash)

    if tx_status != "confirmed":
        transfer_fail.inc()
        logger.error("Invalid txhash received")
        raise HTTPException(status_code=404, detail="txhash not found")

    vendor = get_vendor(req.vendor)

    if not vendor:        
        transfer_fail.inc()
        logger.error("Vendor not supported")
        raise HTTPException(status_code=400, detail="Vendor not supported")

    result = vendor.transfer(req.amount)
    logger.info(f"Transfer request received vendor={req.vendor} amount={req.amount}")
    transfer_success.inc()
    transfer_latency.observe(time.time() - start)
    return result
    