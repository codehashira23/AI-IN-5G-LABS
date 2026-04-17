# Open5GS (Lab 3)

This folder documents **Open5GS** lifecycle for Ubuntu 22.04. Installation is automated in `../../setup/install_all.sh`.

## Services (systemd)

After package install, typical units include:

- `open5gs-amfd.service` — AMF
- `open5gs-nrfd.service` — NRF (NF discovery)
- `open5gs-smfd.service` — SMF
- `open5gs-upfd.service` — UPF

## Quick verification

```bash
sudo systemctl is-active open5gs-amfd
sudo journalctl -u open5gs-amfd -n 80 --no-pager
sudo journalctl -u open5gs-nrfd -n 80 --no-pager
```

Look for AMF startup and NRF-related NF registration patterns in logs (exact strings vary by release).

## Configuration

Default YAML under `/etc/open5gs/`. For a clean classroom VM, defaults are acceptable; tune PLMN and interfaces only if you integrate real gNB/UE.
