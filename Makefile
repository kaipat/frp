FRPS_SERVER=ubuntu@118.126.91.13

yuejia:
	rsync -avz --progress conf/* $(YUEJIA_SERVER):/etc/nginx/ --rsync-path="sudo rsync"
	ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa $(YUEJIA_SERVER) "sudo nginx -t && sudo nginx -s reload"

frpc:
	./frpc_arm64/frpc -c ./frpc_arm64/frpc.toml

frps:
	rsync -avz --progress frps_amd64/* $(FRPS_SERVER):~/frps
	ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa $(FRPS_SERVER) "sudo systemctl restart frps"
