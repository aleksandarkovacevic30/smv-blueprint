import json
import requests
import time, threading

from random import seed
from random import randint

seed(1)

class SensorReading(object):
    def __init__(self):
        self.id="690001001"
        self.cycle=randint(0,100000)
        self.type="LEVER_SWITCH_V2"
        self.identity="vwpnwrclb001"
        self.vcc=randint(0, 12)
        self.heap=randint(0, 100000)
        self.rssi=randint(-100, 100)
        self.value=str(randint(0, 100000))
        self.sleepWakeupCause=randint(0, 10)
        self.wifiFailureCount=randint(0, 100000)
        self.serverFailureCount=randint(0, 100000)
        self.fw="3.1.8"
        self.connectionTime=randint(0, 1000)
        self.transactionTime=randint(0, 1000)
        self.ska=3600
        self.FORCE_DEEP_SLEEP=14000
        self.snw=300
        self.ssf=180
        self.swf=180
        self.wrm=5
        self.srm=5
        self.oct=1
        self.brownout=0
    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__, 
            sort_keys=False, indent=4)


server="http://127.0.0.1:5000"
host = server+"/api/device/status"

def foo():
    sr = SensorReading()
    data_json = sr.toJSON()
    response = requests.post(host, data=data_json, headers={'content-type': 'application/json'})
    print(response)
    print(response.text)
    threading.Timer(10, foo).start()

foo()
