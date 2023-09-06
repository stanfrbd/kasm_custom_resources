# kasm_custom_resources

## Dependencies

- KASM Workspaces
- Docker
- Docker Compose (included in the last versions of Docker)

This is supposed to work in KASM Workspaces, so it is not a common docker image. For more information about how it works: [KASM Workspaces | Building Custom Images](https://www.kasmweb.com/docs/latest/how_to/building_images.html)

## Dockerfile:
- `docker-custom-kali`

## How to build this Kali custom image (this is a very long step) :

```bash
git clone https://github.com/stanfrbd/kasm_custom_resources
cd kasm_custom_resources
docker build --network="kasm_default_network" -t kali-custom:beta -f docker-custom-kali .
```

* This image is ~ 16 GB

### This KASM docker image is based on:

* `kasmweb/core-kali-rolling:1.13.0`

### It contains:
* `kali-tools-top10`
* `autopsy`
* `cutycapt`
* `dirbuster`
* `faraday`
* `fern-wifi-cracker`
* `guymager`
* `hydra-gtk`
* `legion`
* `ophcrack`
* `ophcrack-cli`
* `sqlitebrowser`
* `kali-themes-purple`
* `kali-tools-identify`
* `kali-tools-protect`
* `kali-tools-detect`
* `kali-tools-respond`
* `kali-tools-recover`
* `Burp Suite`
* `Chromium`
* `Tor Browser`
* `VS Code`
* `Telegram Desktop`
* `RemoteBox`
* `Surfshark VPN` (autoconnects at startup following the next config)

### Add this line in **Docker Run Config Override (JSON)** section
```json
{"cap_add":["NET_ADMIN"],"devices":["dev/net/tun","/dev/net/tun"]}
```

## Add Surfshark VPN user / password in KASM

### Add these lines in **Docker Exec Config (JSON)** section

```json
{
    "first_launch": {
        "cmd": "bash -c 'sudo echo <MANUAL_SURFSHARK_USERNAME> > vpn-auth.txt && sudo echo <MANUAL_SURFSHARK_PASSWORD> >> vpn-auth.txt && sudo openvpn --config /etc/openvpn/ovpn_configs/<YOUR_SURFSHARK_CONFIG>.ovpn --auth-user-pass vpn-auth.txt --mute-replay-warnings'"
    }
}
```

* You can find `<MANUAL_SURFSHARK_USERNAME>` and `<MANUAL_SURFSHARK_PASSWORD>` on the Surfshark VPN website (manual config section).
* You can find `<YOUR_SURFSHARK_CONFIG>.ovpn` in `/etc/openvpn/ovpn_configs/` and on the Surfshark VPN website (manual config section).
