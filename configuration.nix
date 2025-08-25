# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "magpie"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fi";
    variant = "mac";
  };

  # Configure console keymap
  console.keyMap = "fi";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Add vscode extensions
  nixpkgs.overlays = with inputs; [
    nix-vscode-extensions.overlays.default
  ];
  
  fonts = {
    packages = [
      # so many tofu...
      pkgs.noto-fonts
    ];

    fontconfig.defaultFonts = {
      sansSerif = [ "Adwaita Sans" "Noto Sans" ];
    };
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.olivia = {
    isNormalUser = true;
    description = "Olivia";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      gnome-tweaks
      resources
      discord
      # For proton VPN
      protonvpn-gui
      wireguard-tools
      
      proton-pass
      telegram-desktop
      signal-desktop

      # Gnome extensions
      gnomeExtensions.dash-to-dock # Swipeable dash
      gnomeExtensions.blur-my-shell # Cute blurs
      gnomeExtensions.appindicator # Tray icons
      gnomeExtensions.color-picker # Just a little color picker
      gnomeExtensions.peek-top-bar-on-fullscreen # Glance the top bar when in a fullscreen mode
      gnomeExtensions.shutdown-dialogue # Thank you alt+f4
      gnomeExtensions.unblank # Lock screen that isn't blank
      
      # TODO: Once using home-manager, add dconf settings to automatically enable the extensions!

      # global .net SDK for tModLoader mod development
      dotnetCorePackages.sdk_8_0_3xx 
    ];
  };

  # Protonvpn + wireguard
  networking.firewall.checkReversePath = false;
  
  # Basic apps
  programs.firefox.enable = true;
  programs.steam.enable = true;

  # NVIDIA Drivers
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # Open drivers only support the 20xx and 16xx series cards and onwards
    open = false;
    # May help with graphical corruption and system crashes on suspend, but hasn't worked for me
    # powerManagement.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix = {
    settings = {
      # Enable flakes
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    # Automatic GC & hardlinking
    gc = {
      automatic = true;
      dates = "weekly";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
