import urllib3
import winrm
import re
import os

from sys import argv
script, first = argv
login = first

#parse url with list of session
http = urllib3.PoolManager()
r = http.request('GET', 'https://site/termsrv.html')
#print(r.data.decode('utf-16'))
session = r.data.decode('utf-16')
file1 = open("/tmp/sessions.txt", "w")
file1.write(session)
file1.close()



with open('/tmp/sessions.txt') as fa:
    for line in fa:
        if  re.search(login, line):
            awk1 = line.split('<td>')
            awk2 = awk1[7]
            awk3 = awk2.split(' ')
            awk4 = awk3[2]
            awk5 = awk3[3]
            awk6 = awk5.split(':')
            awk7 = awk6[1]

s = winrm.Session(awk7, auth=('admin@domain.local', 'Pa$$w0rd'), transport='ntlm')


pshell = s.run_cmd(awk2)

status = pshell.status_code
print(status)





os.remove("/tmp/sessions.txt")

