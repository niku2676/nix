# NixOS-Konfiguration fuer `buls`

Dies ist die private, reproduzierbare NixOS-Konfiguration fuer den PC `buls`.
Sie ist fuer Dual Boot mit Windows auf einer getrennten SSD ausgelegt. Der
aktuelle Mac ist ausschliesslich die Migrationsquelle; er wird nicht veraendert.

## Was bereits konfiguriert ist

- Nix Flake mit `nixos-unstable`, Home Manager, Disko, Lanzaboote und SOPS-Nix.
- Host `buls`, Benutzer `nikita`, deutsche Locale/Tastatur, Berlin-Zeitzone,
  NetworkManager, Firewall und deaktiviertes SSH.
- EFI -> LUKS2 -> ext4 auf einer dedizierten NixOS-SSD.
- Lanzaboote mit eigenen Schluesseln und erhaltenen Microsoft-Schluesseln. Nach
  dem Enrollment startet Windows aus dem NixOS-Bootmenue.
- Hyprland mit der Nix-/Home-Manager-Variante von end-4/dots. Ghostty bleibt das
  Terminal; Kitty ist im end-4-Modul deaktiviert.
- Ausgewaehlte Apps und CLI-Tools aus `MIGRATION.md`.
- Ghostty-Standardkonfiguration, Zen-Privacy-Preferences und ein Zen-Add-on-
  Inventar unter `config/`.

## Repository-Struktur

```text
.
├── config/                 # textbasierte Nutzerkonfigurationen
│   ├── ghostty/config
│   └── zen/{user.js,addons.md}
├── home/nikita/            # Home-Manager-Programme und end-4
├── hosts/buls/             # PC-spezifische NixOS-, Disko- und Hardware-Dateien
├── flake.nix
├── MIGRATION.md
└── README.md
```

## Vor der ersten Installation: zwingend

`hosts/buls/disko.nix` ist auf die dedizierte NixOS-SSD festgelegt:

```nix
device = "/dev/disk/by-id/ata-P4-120_08B12Z593604";
```

Sie wurde auf dem Ziel-PC als SATA-SSD P4-120 mit 111.8 GB und der Seriennummer
`08B12Z593604` verifiziert. Windows darf dort nie erscheinen. Disko
partitioniert und formatiert sein Ziel vollstaendig.

Die Datei `hosts/buls/hardware-configuration.nix` ist ebenfalls nur ein
gueltiger Platzhalter. Sie wird erst vom NixOS-Installer auf dem Ziel-PC
erzeugt.

## Erstinstallation vom NixOS-USB

Die folgenden Befehle werden ausschliesslich nach der SSD-Pruefung im
NixOS-Installer ausgefuehrt. Sie veraendern nicht die Windows-SSD, sofern der
Disko-Pfad korrekt gesetzt wurde.

```bash
# Private Repo-Anmeldung und Arbeitskopie fuer den Installer.
gh auth login
git clone git@github.com:niku2676/nix.git /tmp/nix
cd /tmp/nix

# Erst jetzt: Disko-Pfad in hosts/buls/disko.nix kontrollieren und ersetzen.
nix --extra-experimental-features 'nix-command flakes' flake lock
sudo nix --extra-experimental-features 'nix-command flakes' \
  run github:nix-community/disko -- \
  --mode destroy,format,mount ./hosts/buls/disko.nix

# Disko hat das neue System unter /mnt eingehangen.
sudo nixos-generate-config --root /mnt
sudo cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/buls/hardware-configuration.nix

# Die volle Desktop-Konfiguration wird auf die eingehangte Ziel-SSD installiert.
sudo nixos-install --flake .#buls
```

Nach dem ersten Boot das Repo als `nikita` nach `~/projects/nix` klonen,
`hardware-configuration.nix` committen und die dortige Kopie als einzige Quelle
weiterpflegen. Vor dem Aktivieren von Secure Boot zuerst `sbctl verify`
ausfuehren; Lanzaboote erzeugt und enrollt die konfigurierten Schluessel.

## Apps und Paketnamen

`home/nikita/default.nix` fuehrt jeden ausgewaehlten App-Namen explizit auf.
Paketnamen, die in der durch `flake.lock` gepinnten Nixpkgs-Revision nicht
existieren, werden nicht stillschweigend installiert; sie erscheinen nach der
Home-Manager-Aktivierung in:

```text
~/.local/share/nix-config/unresolved-package-names.txt
```

Das betrifft mit hoeherer Wahrscheinlichkeit Anbieter- oder Nischenprogramme
wie Antigravity, Codex CLI, Ente Auth und herdr. Fuer jeden solchen Eintrag wird
eine explizite, reproduzierbare Quelle entschieden; keine `curl | sh`-Installer.

Steam und Docker sind bewusst Systemdienste. Der Rest lebt im Home-Manager-
Profil. Anmeldungen fuer Bitwarden, Discord, Nextcloud, Proton VPN, Signal,
Spotify, Steam, Stremio und WhatsApp bleiben lokal und manuell.

SF Mono Nerd Font wird nicht automatisiert aus dem Mac kopiert. Pruefe zuerst
die Lizenz und installiere danach eine rechtmaessige Linux-Quelle oder verwende
eine freie Nerd Font als Ersatz.

## Zen und Ghostty

Ghostty hatte auf dem Mac keine benutzerdefinierten Einstellungen; die Datei
`config/ghostty/config` dokumentiert diesen Ausgangspunkt.

Zen startet einmal mit einem frischen Linux-Profil. Danach:

1. Den tatsaechlichen Zen-Profilordner feststellen.
2. `config/zen/user.js` als `user.js` in diesen Ordner kopieren oder verlinken.
3. Die Erweiterungen aus `config/zen/addons.md` bewusst neu installieren.
4. Bitwarden einmalig anmelden.

Browserprofil, gespeicherte Logins, Cookies, Verlauf, Sitzungen, Erweiterungs-
Speicher und dynamische IDs gehoeren nicht in dieses Repository.

## Secrets

SOPS ist vorbereitet, aber es existieren noch absichtlich keine Secrets. Auf
dem PC wird ein eigener Age-Schluessel erzeugt, sein **oeffentlicher** Teil als
SOPS-Recipient eingetragen und der private Schluessel sicher in Bitwarden
abgelegt. Klartext-Secrets, private SSH-Schluessel und entschluesselte Dateien
sind ausgeschlossen.

## Normaler Betrieb

```bash
cd ~/projects/nix
nix flake update
sudo nixos-rebuild build --flake .#buls
sudo nixos-rebuild switch --flake .#buls
```

Ein Update wird erst nach erfolgreichem Build committed. Bei Problemen waehlst
du beim Start die vorherige NixOS-Generation.
