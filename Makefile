FRPS_SERVER=ubuntu@101.33.203.250

frpc:
	./frpc_arm64/frpc -c ./frpc_arm64/frpc.yaml

frps:
	rsync -avz --progress frps_amd64/* $(FRPS_SERVER):~/frps
	ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa $(FRPS_SERVER) "sudo systemctl restart frps"

auto_run_on_ubuntu:
	rsync -avz --progress ./frps_amd64/frps.service $(FRPS_SERVER):/etc/systemd/system/ --rsync-path="sudo rsync"
	ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa $(FRPS_SERVER) "sudo systemctl stop frps && sudo systemctl daemon-reload && sudo systemctl start frps && sudo systemctl enable frps && sudo systemctl status frps"

auto_run_on_mac:
	sudo launchctl bootout system /Library/LaunchDaemons/com.frp.frpc.plist || true
	sudo cp ./frpc_arm64/com.frp.frpc.plist /Library/LaunchDaemons/
	sudo plutil -lint /Library/LaunchDaemons/com.frp.frpc.plist
	sudo chown root:wheel /Library/LaunchDaemons/com.frp.frpc.plist
	sudo chmod 644 /Library/LaunchDaemons/com.frp.frpc.plist
	sudo launchctl bootstrap system /Library/LaunchDaemons/com.frp.frpc.plist
	sudo launchctl enable system/com.frp.frpc
	sudo launchctl list | grep com.frp.frpc
