import requests
import json
import re
import os
import time
#from datetime import datetime, timedelta
import arrow
import pyodbc

ZABBIX_API_URL = "http://zabbix/api_jsonrpc.php"
UNAME = "admin"
PWORD = "passwd"

server = 'sqlsrv'
database = 'test_py'
username = 'sa'
password = 'sasa'
cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)
cursor = cnxn.cursor()



now = arrow.utcnow()
nowtime = now.timestamp()
old = now.shift(months=-3)
oldtime = old.timestamp()
now_qurter = now.shift(months=-1)
now_qurter_month = now_qurter.month

ids = [10,1,2,11]

for i in ids:
    if now_qurter_month <= 3:
        qurter_name = 'Первый крвартал'
    if now_qurter_month > 3 and now_qurter_month < 7:
        qurter_name = 'Второй крвартал'
    if now_qurter_month > 6 and now_qurter_month < 10:
        qurter_name = 'Третий квартал'
    if now_qurter_month > 9:
        qurter_name = 'Третий квартал'
    r = requests.post(ZABBIX_API_URL,
                    json={
                        "jsonrpc": "2.0",
                        "method": "user.login",
                        "params": {
                            "user": UNAME,
                            "password": PWORD},
                        "id": 1
                    })
    AUTHTOKEN = r.json()["result"]
# eksmo 1c base SLA
#    ID_eksmo = '1'
    print("\nRetrieve a EKSMO sla")
    r = requests.post(ZABBIX_API_URL,
                  json={
                      "jsonrpc": "2.0",
                      "method": "service.getsla",
                      "params": {
                          "serviceids": i,
                          "intervals": [
                              {
                                  "from": oldtime,
                                  "to": nowtime
                              }
                          ]
                      },
                      "auth": AUTHTOKEN,
                      "id": 1
                    })
#print(json.dumps(r.json(), indent=4, sort_keys=True))
    test = json.dumps(r.json(), indent=4, sort_keys=True)
#print(type(test))
    file1 = open("/tmp/MyFile.txt", "w")
    file1.write(test)
    file1.close()
    with open('/tmp/MyFile.txt') as f:
        data = json.load(f)
#print(type(data))
#print(data.keys())
    rezultat = (json.dumps(data['result'],indent=4, sort_keys=True))
#print(type(rezultat))
    file2 = open("/tmp/MyFile2.txt", "w")
    file2.write(rezultat)
    file2.close()
    with open('/tmp/MyFile2.txt') as fa:
        for line in fa:
            if re.search('sla', line):
                file3 = open("/tmp/MyFile3.txt", "w")
                file3.write(line)
                file3.close()
#            print(line)
    with open('/tmp/MyFile3.txt') as fa:
        for line in fa:
            if re.search('sla', line):
                awk1 = line.split(':')
                awk2 = awk1[1]
                awk3 = awk2.split(' ')
                awk4 = awk3[1]
                awk5 = awk4.split(',')
                awk6 = awk5[0]
#            print(awk6)
    print ('Inserting a new row into table')
#Insert Query
    tsql = "INSERT INTO sla (id, sla, date) VALUES (?,?,?);"
    with cursor.execute(tsql,i,awk6,qurter_name):
        print ('Successfully Inserted!')
    os.remove("/tmp/MyFile.txt")
    os.remove("/tmp/MyFile2.txt")
    os.remove("/tmp/MyFile3.txt")


#Logout user
print("\nLogout user")
r = requests.post(ZABBIX_API_URL,
                  json={
                      "jsonrpc": "2.0",
                      "method": "user.logout",
                      "params": {},
                      "id": 2,
                      "auth": AUTHTOKEN
                  })

#print(json.dumps(r.json(), indent=4, sort_keys=True))
