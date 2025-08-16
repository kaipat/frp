FRPS_SERVER=ubuntu@101.33.203.250

frpc:
	./frpc_arm64/frpc -c ./frpc_arm64/frpc.toml

frps:
	rsync -avz --progress frps_amd64/* $(FRPS_SERVER):~/frps
	ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa $(FRPS_SERVER) "sudo systemctl restart frps"
