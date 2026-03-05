import json
import os

class VendorsMock:
    def __init__(self):
     
        self.config_path = os.path.join(os.path.dirname(__file__), 'vendors', 'data.json')
        self._load_config()

    def _load_config(self):
        with open(self.config_path, 'r') as f:
            self.config = json.load(f)

    def process_transfer(self, vendor_name, amount, txhash):

        vendor_info = self.config['vendors'].get(
            vendor_name, 
            self.config['default_response']
        )
        
        return {
            "status": vendor_info["status"]
        }