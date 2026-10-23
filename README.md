# Personal dotfiles

GNU Stow manages the files in this repository. Each top-level directory named
below is a package whose contents mirror paths under `$HOME`.

## Install after a fresh system setup

Install `git` and `stow`, clone this repository as `~/dotfiles`, then run:

```sh
cd ~/dotfiles
stow --no-folding --simulate --verbose --target="$HOME" \
  doom hypr shell noctalia kitty starship phone-webcam wireplumber
stow --no-folding --target="$HOME" \
  doom hypr shell noctalia kitty starship phone-webcam wireplumber
```

Review any conflicts shown by the simulation and move existing config files
aside before running the second command. `--no-folding` links individual files,
so applications can still create generated files alongside them.

| Package | Contents |
| --- | --- |
| `doom` | Doom Emacs configuration |
| `hypr` | Hyprland Lua settings, idle and sunset settings, and helper script |
| `shell` | Zsh setup, Powerlevel10k preset, and asdf tool versions |
| `noctalia` | Noctalia v5 profile and custom Emacs Dired template |
| `kitty` | Kitty configuration |
| `starship` | Starship prompt configuration |
| `phone-webcam` | User service and executable camera script |
| `wireplumber` | Bluetooth profile switching override |

The Noctalia-generated `hyprland.conf`, `hypr/noctalia.lua`, color files,
Doom theme, and Kitty theme are deliberately left to Noctalia to recreate.
Start Noctalia after installing these packages so its templates can run. The
Hyprland Lua settings tolerate the generated module being absent at first.

## Private data and machine setup

`~/.zshrc` loads API keys from `~/.config/shell/secrets.zsh` when that file
exists. This private file is outside the repository and must be restored from
a separate, secure backup. Keep its permissions at `0600`. The keys are not
required for a shell to start, but apps using them need the file restored.

The Noctalia avatar (`~/.face`) and wallpaper directory
(`~/Pictures/Wallpapers`) are personal files and must also be backed up
separately. Other personal data, credentials, SSH keys, and browser profiles
are outside this dotfiles repository.

The phone webcam service uses a virtual V4L2 camera at `/dev/video90`, ADB,
scrcpy, and Avahi discovery. Restore the related device and module setup
before enabling the user service. Its script is executable; the unit can be
started with `systemctl --user start phone-webcam.service` once ready.

## Installed packages

The `packages/` files are a snapshot of packages on the old CachyOS system:

- `native-explicit.txt`: explicitly installed packages from configured repos.
- `foreign-explicit.txt`: explicitly installed packages outside those repos.
- `foreign-all.txt`: all installed foreign packages, including dependencies.

Review these lists against the new system and hardware before reinstalling.
They document names, not package versions, repository configuration, service
state, or system-wide settings. Refresh them before a future migration with:

```sh
pacman -Qqen > packages/native-explicit.txt
pacman -Qqem > packages/foreign-explicit.txt
pacman -Qqm > packages/foreign-all.txt
```
