#!/usr/bin/env python3

FORMAT = "utf-8"
BUFFSIZE = 2048
SERVERPORT = 6174

ROOTSTORE = "/usr/local/share/ca-certificates/root.crt"

CLIENTCERT = "bob.crt"
FAKECLIENTCERT = "alice/fakeAlice.crt"
CLIENTPRIVATEKEY = "serverPrivate.pem"
FAKECLIENTPRIVATEKEY = "alice/fakeAlicePrivate.pem"

SERVERCERT = "alice.crt"
FAKESERVERCERT = "bob/fakeBob.crt"
SERVERPRIVATEKEY = "alicePrivate.pem"
FAKESERVERPRIVATEKEY = "bob/fakeBobPrivate.pem"

CLIENTIP = "172.31.0.2"
SERVERIP = "172.31.0.3"
