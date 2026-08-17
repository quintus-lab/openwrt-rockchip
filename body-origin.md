ImmortalWrt 25.12 firmware for NanoPi R2S / R2S Plus, NanoPi R4S /
R4S Enterprise / R4SE, and Orange Pi R1 Plus / LTS.

Source: immortalwrt/immortalwrt @ openwrt-25.12 (tip at build time)
Proxy: HomeProxy (sing-box) + Passwall (xray-core) + SmartDNS
VPN: Tailscale, WireGuard
IPv6: DHCPv6/RA, 464XLAT, 6in4/6rd/6to4, DS-Lite, MAP
LAN: 192.168.1.1 / root / (no password)

HomeProxy covers VLESS + Reality + Vision. Newer Xray-only
transports (XHTTP, VLESS Encryption) belong in Passwall.
