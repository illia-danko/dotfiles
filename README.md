Personal dotfiles to setup an arch-base or debian-base system

# debian notes

To restore/save terminal settings run from the root project's folder:

```bash
# To store settings to a file.
dconf dump "/org/gnome/terminal/" > assets/gnome-terminal.conf
# To load settings from a file (done automatically by the script).
dconf load "/org/gnome/terminal/" < assets/gnome-terminal.conf
```
