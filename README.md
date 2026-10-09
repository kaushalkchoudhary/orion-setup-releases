# Orion Setup releases

Encrypted updates for Orion Setup on supported Linux ARM64 and ARMv7 appliances. Application source remains private; downloading releases does not require a GitHub account.

## Install

Run on the box with root/sudo and internet access:

```sh
curl -fsSL https://github.com/kaushalkchoudhary/orion-setup-releases/releases/latest/download/install.sh | sh
```

Enter the administrator-provided release code for the first installation. The installer selects the CPU build, prepares dependencies, verifies the download, and checks startup. A failed dependency check stops before replacing the console.

Open **`http://BOX_IP:8088`**. Default login: **`magicbox` / `magicbox@123`**; change it under Device.

## Update

```sh
orion-setup --update
orion-setup --status
orion-setup --version
orion-setup --help
```

Current builds check on startup and about every two minutes, then install automatically. **Device → Software** shows progress and retry controls. Installed production binaries authorize updates without a release code.

Settings, cameras, passwords, enrollment, and sessions are retained. Keep power connected and confirm pending network changes first. Failed releases require a retry; newer releases can install automatically. Application rollback is attempted on startup failure and does not restore OS/kernel changes.

## Files

- `orion-setup-linux-arm64.enc` / `orion-setup-linux-armv7.enc`: encrypted appliance binaries; installed as `orion-setup`.
- `orion-manifest*.json`: source commit, release, size, and SHA256 checksums.
- `orion-download-*`: Linux/macOS download helpers; no appliance source or release code is embedded.
- `install.sh` / `deploy.sh`: local and SSH installation.
- `update-authorization.json` / `update-keyring.enc`: encrypted authorization for installed production builds.

AES-256-GCM authenticates packages before execution. Compatibility manifests let earlier installations reach the current installer without publishing duplicate appliance binaries.

## Requirements and troubleshooting

Supported Debian images use NetworkManager/systemd; OpenWrt uses netifd/procd and matching package/kernel feeds. Offline SSH deployment requires dependencies to be installed already.

Console: port **8088**, including `10.99.x.x` and `10.10.x.x` management VPN addresses. Direct LAN/supported USB device mode uses `http://192.168.30.1:8088`.

Update logs: `/var/lib/magicbox-updates`. Backups: `/var/backups/orion-appliance`. Use `ORION_VERSION=build-COMMIT` to pin an installer release. Unpublished custom binaries may need initial authorization.
