SHELL := /bin/bash
copyFiles:
	scp -r * ns@192.168.51.111:/home/ns/

distributeFiles:
	for container in "alice" "bob" "trudy"; do \
		lxc file push -r certificates/rootCA/root.crt *.py certificates/$$container/* $${container}1/root/ ; \
	done 

addToRootStore:
	for container in "alice1" "bob1" "trudy1"; do \
		lxc exec $$container -- cp root.crt /usr/local/share/ca-certificates/ ; \
		lxc exec $$container -- sudo update-ca-certificates ; \
	done

clean:
	for container in "alice1" "bob1" "trudy1"; do \
		lxc exec $$container -- bash -c "rm -rf /root/{__pycache__/,alice/,bob/,*.crt,*.csr,*.sign,*.txt,*.py,*.pem}"; \
		lxc exec $$container -- bash -c "rm -rf /usr/local/share/ca-certificates/root.crt"; \
	done

	rm -rf certificates/ *.py *.crt /usr/local/share/ca-certificates/root.crt *.txt Makefile
