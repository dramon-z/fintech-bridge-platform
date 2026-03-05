from .base import Vendor

class VendorA(Vendor):

    def transfer(self, amount):
        return {"status": "success"}