# rpcfiend
Use rpc null sessions to retrieve machine list, domain admin list, domain controllers

usage: ./rpcfiend.sh 192.168.1.1

```
[~] # ./rpcfiend.sh acme-dc01.acmecomputercompany.com
+++++++++ DOMAIN ADMINS +++++++++
administrator
superuser
backupadmin
+++++++++ DOMAIN CONTROLLERS +++++++++
acme-dc01
acme-dc02
+++++++++ DOMAIN MACHINES +++++++++
acme-laptop1
acme-laptop2
acme-laptop3
acme-laptop4
backupserver

```

## added in authenticated version
```
[~] # ./rpcfiend_authenticated.sh acme-dc01.acmecomputercompany.com username
Please enter your password:

+++++++++ DOMAIN ADMINS +++++++++
administrator
superuser
backupadmin
+++++++++ DOMAIN CONTROLLERS +++++++++
acme-dc01
acme-dc02
+++++++++ DOMAIN MACHINES +++++++++
acme-laptop1
acme-laptop2
acme-laptop3
acme-laptop4
backupserver
```
