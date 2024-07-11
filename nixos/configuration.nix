# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports=[
    <nixos-hardware/chuwi/minibook-x>
    ./hardware-configuration.nix
  ];

  boot={
    loader={
      timeout=3;
      systemd-boot={
        enable=true;
        editor=false;
#         netbootxyz.enable=true;
        configurationLimit=8;
      };
      efi.canTouchEfiVariables=true;
    };
    kernelPackages=pkgs.linuxPackages_zen;
    plymouth.enable=true;
  };

  # networking.hostName = "nixos"; # Define your hostname.
  networking={
    wireless.iwd.enable=true;
    useDHCP=false;
    useNetworkd=true;
    firewall.enable=false;
  };
  systemd.network={
    enable=true;
    networks={
      "20-ethernet"={
        matchConfig.Name="wl*";
        linkConfig.RequiredForOnline="routable";
        networkConfig={DHCP="yes";MulticastDNS="yes";};
        dhcpV4Config.RouteMetric=100;
        ipv6AcceptRAConfig.RouteMetric=100;
      };
      "20-wlan"={
        matchConfig.Name="en* eth*";
        linkConfig.RequiredForOnline="routable";
        networkConfig={DHCP="yes";MulticastDNS="yes";};
        dhcpV4Config.RouteMetric=600;
        ipv6AcceptRAConfig.RouteMetric=600;
      };
    };
  };
  services.resolved.enable=true;

  time.timeZone="Asia/Tokyo";
  i18n={
    defaultLocale="ja_JP.UTF-8";
    inputMethod={
      enabled="fcitx5";
      fcitx5.addons=with pkgs;[
        fcitx5-gtk
        fcitx5-mozc
      ];
    };
  };
  fonts={
    packages=with pkgs;[
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      monaspace
    ];
    fontconfig.defaultFonts={
      sansSerif=["Noto Sans CJK JP"];
      serif=["Noto Serif JP"];
      monospace=["monaspace Argon"];
    };
  };
  console.keyMap="jp106";

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable=true;

  # Enable sound.
  services.pipewire={
    enable=true;
    pulse.enable=true;
    jack.enable=true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users={
    defaultUserShell=pkgs.zsh;
    users={
      mcbeeringi={
        isNormalUser=true;
        extraGroups=["wheel"];
        useDefaultShell=true;
        packages=with pkgs;[
          firefox
          tree
          vscodium-fhs
        ];
      };
    };
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    foot
    neofetch
    brightnessctl
    wofi
    greetd.tuigreet
    xfce.tumbler
  ];

  programs={
    zsh={
      enable=true;
      syntaxHighlighting.enable=true;
      autosuggestions.enable=true;
    };
    git.enable=true;
    hyprland.enable=true;
    waybar.enable=true;
    thunar.enable=true;
    seahorse.enable=true;
  };
  services={
    gvfs={enable=true;package=pkgs.gvfs;};
    greetd={
      enable=true;
      package=pkgs.greetd.tuigreet;
      settings={default_session={command="tuigreet -g 'Welcome back!' -t --time-format '%y-%m-%d %H:%M' -r --remember-user-session --user-menu --asterisks";};};
    };
    gnome.gnome-keyring.enable=true;
    tumbler.enable=true;
  };
  security.pam.services={
    greetd.enableGnomeKeyring=true;
    passwd.enableGnomeKeyring=true;
  };
  security.polkit.enable=true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable=true;

  system.copySystemConfiguration=true;

  system.stateVersion = "24.05"; # DO NOT CHANGE

}

