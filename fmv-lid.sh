#!/usr/bin/bash
cat << _EOF |sudo tee /usr/local/bin/fmv-lid.sh
#!/usr/bin/bash
LAST=""
while true; do
	STATE=\$(cat /proc/acpi/button/lid/LID/state | awk '{print \$2}')
	if [[ "\$STATE" != "\$LAST" ]]; then
		LAST="\$STATE"
		if [[ "\$STATE" == "closed" ]]; then
			systemctl suspend
		fi
	fi
	sleep 1
done
_EOF

cat <<_EOF |sudo tee /etc/systemd/system/fmv-lid.service
[Unit]
Description=FMV Lid switch watcher

[Service]
Type=simple
ExecStart=/usr/local/bin/fmv-lid.sh
Restart=always

[Install]
WantedBy=multi-user.target
_EOF

sudo chmod +x /usr/local/bin/fmv-lid.sh
sudo systemctl enable --now fmv-lid.service
