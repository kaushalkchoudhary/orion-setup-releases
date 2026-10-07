# Orion Setup updates

Public **encrypted** updates for Linux ARM64 Radxa E20C/E24C/E52C and NanoPi R2C/R2C Plus,
and Linux ARMv7 NanoPi R1S-H3.
The application source stays private. No GitHub account is needed to check for or
download updates. A fresh installation requires the release security code;
an installed published console authorizes subsequent updates automatically.

## From the box UI

After installing this release, terminal commands are available on PATH:

```sh
orion-setup              # device dashboard
orion-setup --status     # same read-only dashboard
orion-setup --update     # latest verified release
orion-setup --uninstall  # keep settings and enrollment
orion-setup --version
orion-setup --help
```

The dashboard shows box/board serials, IP addresses, ports and observed clients,
plus the VMS relay and camera inventory. Unknown camera state is labelled;
status does not start streams or change network configuration. Privileged commands
invoke sudo when needed. Commands use the `--command` form.

Open **Device → Software**. When an update is available, select **Install update**.
No security code is requested. Downloads are authenticated and verified before
installation. Existing setup, cameras, networks, passwords and enrollment are
retained. The installer backs up the application and attempts rollback if startup
fails. Keep the box powered on; rollback does not guarantee recovery from power
loss or restore all kernel/network changes. Confirm pending network changes first.

## Install directly on an online box

Requires curl, SHA256 tools, root/sudo, and a supported NetworkManager/systemd or
netifd/procd image. The installer selects the correct ARM64/ARMv7 binary, checks
dependencies, and installs all missing packages through Debian `apt-get` or
OpenWrt `apk`/`opkg` before replacing the console. Package installation is automatic;
existing tools are reused. A package failure stops setup before console replacement.
On the four-port Radxa E24C vendor image it also installs the MediaMTX camera relay.
This also upgrades boxes that do not yet have the update UI.

```sh
curl -fsSL https://github.com/kaushalkchoudhary/orion-setup-releases/releases/latest/download/install.sh | sh
```

Enter the release security code during first installation. Subsequent updates
reuse saved authorization or recover it from the installed published binary.
Older/direct installations do not need a one-time code entry. Run
`orion-setup --update` again to use the latest installer.

For an unattended installation from a root shell, supply the code directly:

```sh
curl -fsSL https://github.com/kaushalkchoudhary/orion-setup-releases/releases/latest/download/install.sh | ORION_UPDATE_CODE='YOUR_RELEASE_CODE' sh
```

The terminal shows release verification, dependency preparation, installation and
startup verification as numbered stages. Color is automatic; `NO_COLOR=1` disables it.

## Send an update from a laptop

On Linux or macOS, download both scripts and run the SSH helper:

```sh
tools_dir=$(mktemp -d)
for script in install.sh deploy.sh; do
  curl -fsSL "https://github.com/kaushalkchoudhary/orion-setup-releases/releases/latest/download/$script" -o "$tools_dir/$script"
done
sh "$tools_dir/deploy.sh" radxa@BOX_IP
```

The box does not need GitHub access for this method. An offline box must already
have all dependency packages installed.
Use an SSH config alias for custom ports/keys. Set `ORION_VERSION` to a release
tag to select a particular build. Helpers support ARM64/AMD64 Linux and macOS.
Installation continues if restarting the console drops the SSH connection;
the helper prints its log/result paths.

## Troubleshooting

UI checks retry automatically after connectivity failures. Failed UI jobs keep
logs under `/var/lib/magicbox-updates`; backups are under
`/var/backups/orion-appliance`. An unpublished/custom binary may not have an
authorization record; published production binaries are registered automatically.

## Package format

`orion-manifest.json` identifies the source revision, release, sizes and SHA256 hashes.
The appliance executable is encrypted with AES-256-GCM using a fresh salt/nonce
and PBKDF2-HMAC-SHA256 (600,000 iterations). A wrong code or changed ciphertext
fails authentication before the appliance executable is written or run.

`orion-download-*` are small, unencrypted platform helpers for downloading and
unlocking the package. They contain neither the appliance application nor the
security code. The `.sha256` files verify their downloads. Only completed,
tested builds become releases; boxes never install without an explicit action.

`update-authorization.json` contains encrypted authorizations keyed by published
binary checksums. Unlocking one requires a separate digest of the actual private
executable; public checksums alone cannot authorize updates. The release job
carries historical keys in `update-keyring.enc`, encrypted with the release secret.
Neither asset exposes the release code or plaintext authorization keys.

Legacy `radxa-*` assets and manifests remain for installed clients. Old GitHub
repository URLs redirect to the Orion repositories. Existing data is migrated
with backup and rollback; compatibility links preserve old installation paths.
