# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# These types of files are called "modules".

# This configuration is intended for my personal use.
# It is to be reproducable on the same machine (i.e. Lenovo Thinkpaad T480).

# WARNING: Paths SHOULD always be absolute
{ lib, pkgs, ... }:

let files = import /etc/nixos/lib/files.nix; in
{
  imports =
    lib.lists.flatten
    [ # Include custom modules
      (files.extFiles /etc/nixos/modules "nix")
      # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/efi";
    };
    grub = {
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
      splashImage = null;
    };
  };

  networking = {
    hostName = "nixT480";
    networkmanager.enable = true;
  };

  # user `ars`
  users.users.ars = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };

  # WARNING: broken, set manually for now
  #
  # grant user `ars` read/write permission to /etc/nixos/*
  #
  # system.userActivationScripts = {
  #   "sourcePkgs" = { text = ''source ${config.system.build.setEnvironment}''; };
  #   "nixosConfACL" = {
  #     text = ''setfacl -m "user:ars:rwX" -R /etc/nixos/'';
  #     deps = [ "sourcePkgs" ]; };
  # };

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
    ];
  };

  # Allow unfree packages/derivations
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # my packages
    chezmoi
    wezterm
    firefox
    btop
    spotify
    yt-dlp
    obsidian
    mpv
    gh
    stow
    obs-studio
    lazygit
    shotcut

    # common packages
    fzf
    eza
    jq
    ripgrep
    git
    sshfs
    unzip
    p7zip
    wget
    efibootmgr
    pulseaudio
    ncdu
    parted
    cryptsetup

    # language packages
    gcc
    gnumake
    go
    rustup
    dart-sass
  ];

  programs = {
    fish.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      withNodeJs = true;
    };

    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        # wayland and sway related packages
        grim
        slurp
        wl-clipboard
        swaybg
        eww
        dunst
        brightnessctl
        wev
        polkit_gnome
        gnome-themes-extra
        waybar
      ];
    };

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [ tumbler ];
    };

    ssh = {
      startAgent = true;
    };
  };

  # wayland wl-roots screen recording/sharing
  xdg.portal.wlr.enable = true;

  services = {
    openssh = {
      enable = true;
      # Don't let sftp read .bashrc or any shell init files
      sftpServerExecutable = "internal-sftp";
      settings = {
        PasswordAuthentication = false;
      };
    };

    dnscrypt-proxy2 = {
      enable = true;
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.libinput.enable = true;

    logind = {
      lidSwitch = "ignore";
    };

    udisks2.enable = true;

    syncthing = {
      enable = true;
      user = "ars";
      group = "users";
      systemService = false;
      dataDir = /home/ars;
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

