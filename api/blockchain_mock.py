def validate_txhash(txhash: str):

    if txhash.startswith("0x123"):
        return "confirmed"

    return "not found"