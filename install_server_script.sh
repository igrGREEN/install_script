#!/bin/sh
mkdir -p /root/trojangfw/
wget -O /root/server_linux_386  http://domain/server_linux_386
wget -O /root/trojangfw/client.json  http://domain/trojangfw/client.json
wget -O /root/trojangfw/config.json  http://domain/trojangfw/config.json
wget -O /root/trojangfw/rootSSL.crt  http://domain/trojangfw/rootSSL.crt
wget -O /root/trojangfw/rootSSL.key  http://domain/trojangfw/rootSSL.key
wget -O /root/trojangfw/server.json  http://domain/trojangfw/server.json
wget -O /root/trojangfw/trojan  http://domain/trojangfw/trojan

chmod +x /root/server_linux_386
chmod +x /root/trojangfw/trojan

cat > /root/start_server_linux_386.sh << EOF
#!/bin/sh
nohup /root/trojangfw/trojan -c /root/trojangfw/server.json >/dev/null &
nohup /root/trojangfw/trojan -c /root/trojangfw/client.json >/dev/null &
nohup /root/server_linux_386 -t "127.0.0.1:1080" -l ":21080" -key "151sfdsadfaf4e1238eeabdt2" -crypt aes -mode fast3 -smuxver 2 -mtu 1350 -sndwnd 1024 -rcvwnd 1024 -dscp 46 -nocomp -quiet >/dev/null &

EOF
chmod +x  /root/start_server_linux_386.sh
cat > /etc/systemd/system/start_server_linux_386.service << EOF
[Unit]
After=network.target

[Service]
ExecStart=/root/start_server_linux_386.sh
Type=oneshot
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

EOF

systemctl daemon-reload
systemctl enable start_server_linux_386
systemctl restart start_server_linux_386


