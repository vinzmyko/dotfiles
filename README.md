# Vinz's NixOS Dotfiles

## Deployment Quick Reference

**Key things to remember:**
These dotfiles use symlinks, so we need to place the config files in the correct location for the symlinks to work.

### For a new machine:

1. Partition and mount disks
2. Create user dir `mkdir -p /mnt/home/vinz`
3. Set ownership for user `chown 1000:100 /mnt/home/vinz`
4. Clone dotfiles `git clone https://github.com/vinzmyko/dotfiles /mnt/home/vinz/dotfiles`
5. Generate hardware config `nixos-generate-config --root /mnt`
6. Create dir for chosen host name `mkdir -p /mnt/home/vinz/dotfiles/hosts/HOSTNAME`
7. Create host directory `mkdir -p /mnt/home/vinz/dotfiles/hosts/HOSTNAME`
8. Copy hardware config `cp /mnt/etc/nixos/hardware-configuration.nix /mnt/home/vinz/dotfiles/hosts/HOSTNAME/hardware-configuration.nix`
9. **Add hostname to flake.nix** - edit the `hosts = [ "t480" ];` line to include your new hostname
10. Add to git `cd /mnt/home/vinz/dotfiles && git add hosts/HOSTNAME/hardware-configuration.nix && git add flake.nix`
11. Commit `git commit -m "Add HOSTNAME configuration"`
12. Install with flake `nixos-install --flake /mnt/home/vinz/dotfiles#HOSTNAME`
13. Clean up `rm -rf /mnt/etc/nixos/`

### For existing machines:
Just run `sudo nixos-rebuild switch --flake ~/dotfiles#HOSTNAME`

### Current hosts:
- `t480` - ThinkPad T480
