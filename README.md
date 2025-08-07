# DockTunnel

**Docker SOCKS Proxy + VPN Tunnel**

DockTunnel is a simple Docker-based tool that securely routes your traffic through a VPN using a lightweight SOCKS proxy. It supports **any VPN provider that uses OpenVPN**, giving you a flexible and isolated tunneling setup inside a container.

**Why did I make this?**

Several devices in my home lack the processor speed and in particular the single-thread performance needed to handle moderate to high data throughput, especially when encrypting proxy traffic before sending it through the VPN tunnel. Offloading this task allowed multiple devices on my home network to access the VPN simultaneously without hitting a performance bottleneck.

---

## 🔐 Features

- 🛡 **VPN encryption** via OpenVPN
- ↻ **SOCKS5 proxy** for routing traffic (e.g., browser, CLI tools)
- 🛣 **Docker containerized**: no mess on your host
- ⚙️ **Supports all OpenVPN providers** (e.g., ExpressVPN, NordVPN, ProtonVPN, Mullvad, etc.)
- 🧹 Easy environment-based configuration

---

## **Please note that this docker container requires CAP NET_ADMIN permissions for VPN**

## 🚀 Getting Started

### 📋 Prerequisites

- Docker installed
- A valid `.ovpn/.conf` configuration file from your VPN provider
- Optional: SOCKS proxy IP/port settings

### 🧪 Example

1. Clone the repository (you can re-bind the port as needed):
   ```bash
   git clone https://github.com/DDoctorzeus/DockTunnel.git
   cd DockTunnel
   ```

2. Place your `.ovpn/.conf` config file into the project directory.

3. Run the container:
   ```bash
   docker run --cap-add=NET_ADMIN --device=/dev/net/tun      -v "$(pwd)/:/vpn/:ro"      -e VPNCONFNAME=vpn.conf      -p 1080:1080      docktunnel
   ```

4. Point your applications to the SOCKS proxy at:
   ```
   socks5://localhost:1080
   ```

---

## ⚙️ Environment Variables

| Variable       | Description                                                                 | Default      |
|----------------|-----------------------------------------------------------------------------|--------------|
| `VPNCONFNAME`  | Name of the OpenVPN config file mounted at `/vpn/`                          | `vpn.conf`   |
| `PROXYBINDIP`  | IP address the SOCKS proxy binds to inside the container (`0.0.0.0` = all) | `127.0.0.1`  |
| `PROXYPORT`    | Port number for the SOCKS5 proxy to listen on (inside the container)        | `1080`       |

> ⚠️ **Note:** `PROXYPORT` is typically **redundant** when running in Docker. You can remap the container port to any desired host port using `-p`, for example:
> ```bash
> docker run -p 1234:1080 ...
> ```
> This binds the container’s internal port 1080 to host port 1234, making `PROXYPORT` optional unless you specifically need to change the internal port for some reason.

---

## 📅 Notes

- Requires `--cap-add=NET_ADMIN` and `--device=/dev/net/tun` to enable VPN tunneling in Docker.
- Works with **any OpenVPN-compatible provider**, including:
  - ExpressVPN
  - ProtonVPN
  - Mullvad
  - NordVPN
  - Private Internet Access
  - And others
- To avoid deprecation warnings in OpenVPN 2.6+, update your `.ovpn/.conf` file to include:
  ```conf
  data-ciphers AES-256-GCM:AES-128-GCM:CHACHA20-POLY1305
  remote-cert-tls server
  auth-nocache
  ```

---

## 🧑‍💻 Contributing

Contributions welcome!

1. Fork this repo
2. Create a feature branch
3. Open a PR with your improvements or bugfixes

---

## 🪖 License

[MIT License]

---

## 🤝 Contact

Questions or ideas? Open an issue or reach out via GitHub.

---
