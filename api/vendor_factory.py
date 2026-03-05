from .vendors.vendorA import VendorA
from .vendors.vendorB import VendorB

vendors = {
    "vendorA": VendorA(),
    "vendorB": VendorB(),
}

def get_vendor(name):

    if name not in vendors:
        raise Exception("vendor not supported")

    return vendors[name]