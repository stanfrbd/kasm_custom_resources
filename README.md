# kasm_custom_resources

### Add this line in **Docker Run Config Override (JSON)** section
```json
{"cap_add":["NET_ADMIN"],"devices":["dev/net/tun","/dev/net/tun"]}
```

## Add user / password for surfshark in KASM

### Add these lines in **Docker Exec Config (JSON)** section

```json
{
    "first_launch": {
        "cmd": "bash -c 'sudo echo <MANUAL_SURFSHARK_USERNAME> > vpn-auth.txt && sudo echo <MANUAL_SURFSHARK_PASSWORD> >> vpn-auth.txt && sudo openvpn --config /etc/openvpn/ovpn_configs/fi-hel.prod.surfshark.com_udp.ovpn --auth-user-pass vpn-auth.txt --mute-replay-warnings'"
    }
}
```
