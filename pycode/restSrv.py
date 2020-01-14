from flask import Flask, json
from flask import request
import random

states = ["DEVICE_INACTIVE_STATE","DEVICE_ACTIVE_STATE","DEVICE_ERROR_STATE"]

api = Flask(__name__)

@api.route('/api/device/status', methods=['POST'])
def post_device_status():
  if not request.json:
        abort(400)
  print(request.json)
  response={"state":random.choice(states),"config":{"ska":"3600"}}
  return json.dumps(response,sort_keys=False)

if __name__ == '__main__':
    api.run()

