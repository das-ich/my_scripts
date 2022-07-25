import winrm
from sys import argv
script, first = argv

hostname = first

s = winrm.Session(hostname, auth=('admin@domain.local', 'Pa$$w0rd'), transport='ntlm')

pshell = s.run_ps('Stop-Service "HASP Loader"')
statstop = pshell.status_code
if statstop == 0:
    pshell = s.run_ps('Start-Service "HASP Loader"')
    statstart = pshell.status_code
    if statstart == 0:
        print('service on', hostname, 'was stop and start')
    else:
        print('service not started')
else:
    print('service not stoped')

