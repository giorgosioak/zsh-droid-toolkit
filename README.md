# ZshDroid-RE

High-performance **Zsh** toolkit for Android Reverse Engineering.

## Usage

### Package Manager (`pm`)

The `pm` function provides a streamlined interface for `adb` package operations with smart **tab-completion** (sorted by newest installed).

| Command | Shorthand | Description |
| --- | --- | --- |
| `find` | `f` | Search installed packages |
| `download` | `d` | Pull APK from device |
| `clear` | `c` | Force-stop and wipe app data |
| `remove` | `r` | Uninstall package |

#### Example

```zsh
pm find google
pm clear com.android.chrome

```

## Structure

```text
zsh-droid-toolkit/
├── zsh-droid.plugin.zsh   # Main loader
├── completions/           # Tab-completion logic (_pm)
└── functions/             # Core logic (pm.sh)

```

## Requirements

* `zsh`
* `adb` (Android Platform Tools)
* `aapt2` (Optional: for local APK parsing)

## One-line Install

Run the following command in your terminal to clone and auto-append the source line to your `~/.zshrc`:

```zsh
curl -s https://raw.githubusercontent.com/giorgosioak/zsh-droid-toolkit/install.sh | zsh

```

## Manual Installation

Clone from GitHub and source `zsh-droid.plugin.zsh`.

```zsh
git clone https://github.com/giorgosioak/zsh-droid-toolkit.git ~/.zsh-droid-toolkit

```

```zsh
# ~/.zshrc
source ~/.zsh-droid-toolkit/zsh-droid.plugin.zsh

```

## Uninstall

Remove the installation directory and the `source` line from your `.zshrc`.

```zsh
rm -rf ~/.zsh-droid-toolkit

```