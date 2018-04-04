from time import sleep
import datetime
from influxdb import InfluxDBClient
import numpy as np

client = InfluxDBClient('localhost', 8086, 'root', 'root', 'example')
client.create_database('example')

while True:
    lst = []
    for i in range(5):
        pld = {'measurement': 'signal',
              'time': datetime.datetime.utcnow().isoformat(),
              'fields': {"value": np.random.normal()}}
        lst.append(pld)
    print(lst)
    client.write_points(lst)
    sleep(5)
