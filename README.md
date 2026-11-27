# foo2zjs — legacy printer drivers for Linux

A maintained fork of the foo2zjs driver collection for printers using host-based protocols including ZjStream, XQX, QPDL, OAK, LAVA, SLX, HIPERC and HBPL. The goal is compatibility with modern Linux while preserving the original printer protocols.

## Build from source

On Fedora:

```bash
sudo dnf install gcc make glibc-devel ghostscript bc groff cups cups-devel cups-filters
```

On Debian/Ubuntu:

```bash
sudo apt install build-essential ghostscript dc groff cups libcups2-dev cups-filters
```

Package availability varies by distribution release. Before installation, verify that the CUPS filter `foomatic-rip` is available; if missing, locate the package providing it (on Fedora, use `dnf provides '*/foomatic-rip'`).

```bash
git clone https://github.com/juanjosecas/foo2zjs.git
cd foo2zjs
make check-deps
make -j"$(nproc)"
```

Build as an ordinary user. The ICC converter uses the bundled byte-swapping implementation to support modern compilers and in-place conversion.

## Installation and safety

The current legacy installer writes into system directories and can remove existing PPD or Foomatic files. Prefer distribution packages when available. On a dedicated test system, inspect existing packages and the installation commands before proceeding:

```bash
rpm -q foo2zjs
command -v foo2zjs
make -n install
```

On Debian/Ubuntu use `dpkg -l '*foo2zjs*'` instead of rpm. Do not overwrite distribution-managed files. Back up existing printing configuration before installing.

```bash
sudo make install
sudo systemctl restart cups.service
lpinfo -m | grep -i foo2
sudo lpinfo -v
```

Use http://localhost:631 to add a printer with the matching model driver. Check `PPD/` for supported models. This driver requires a CUPS installation supporting legacy PPDs and filters.

**Do not routinely run `make cups`, `make install-hotplug` or `make uninstall`.** These legacy targets modify system configuration or remove files beyond the driver's own installation. Safe replacement procedures are pending. DESTDIR is not yet safe for isolated packaging.

## Firmware and USB printers

Some HP LaserJet models (1000, 1005, 1018, 1020, P1005–P1008 and P1505) require firmware on every power cycle. The repository includes firmware images for several models. Do not substitute firmware from another model. The legacy hotplug installer can remove HPLIP rules; inspect existing firmware loading support before changing it.

```bash
lsusb
sudo lpinfo -v
journalctl -u cups.service -b --no-pager
```

## Testing and troubleshooting

```bash
file foo2zjs foo2xqx icc2ps/foo2zjs-icc2ps
ldd icc2ps/foo2zjs-icc2ps
lpstat -t
./test-printer.sh --help
```

To print a test page, select the intended queue in CUPS. A successful build does not establish physical printer compatibility.

The historical `make test` uses hashes tied to Ghostscript 8.71 on Fedora 14. Modern rasterization can differ without a driver defect. Do not downgrade Ghostscript to satisfy those hashes. Legacy groff table diagnostics may appear while generating the PDF manual.

## Historical documentation

- [README.in](README.in): original driver overview.
- [INSTALL.in](INSTALL.in): historical installation and model-specific notes; commands may be obsolete.
- [INSTALL.usb](INSTALL.usb): historical USB notes.
- [INSTALL.osx](INSTALL.osx): historical macOS notes (not validated on modern macOS).
- [COPYING](COPYING): license terms.
- [ChangeLog](ChangeLog): historical changes.

## Maintenance policy

Preserve protocol encoders, firmware, color profiles and model-specific settings unless a reproducible defect requires a change. Prioritize build portability, safe installation, regression tests and documentation. Modern Linux builds and physical printer tests must be validated separately.
