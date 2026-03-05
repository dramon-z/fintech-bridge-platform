from .base import Vendor

class VendorB(Vendor):

    def transfer(self, amount):
        return {"status": "pending"}