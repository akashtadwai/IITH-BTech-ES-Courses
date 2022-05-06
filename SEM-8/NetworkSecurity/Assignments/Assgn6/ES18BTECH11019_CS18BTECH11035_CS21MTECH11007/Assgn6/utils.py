#!/usr/bin/env python3

FORMAT = "utf-8"
BUFFSIZE = 2048
SERVERPORT = 6174

ROOTSTORE = "/usr/local/share/ca-certificates/root.crt"

CLIENTCERT = "alice.crt"
FAKECLIENTCERT = "alice/fakeAlice.crt"
CLIENTPRIVATEKEY = "alicePrivate.pem"
FAKECLIENTPRIVATEKEY = "alice/fakeAlicePrivate.pem"

SERVERCERT = "bob.crt"
FAKESERVERCERT = "bob/fakeBob.crt"
SERVERPRIVATEKEY = "bobPrivate.pem"
FAKESERVERPRIVATEKEY = "bob/fakeBobPrivate.pem"

CLIENTIP = "172.31.0.2"
SERVERIP = "172.31.0.3"
