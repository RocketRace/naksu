{ pkgs, inputs, ... }:
{
  # originally from home.nix, needs to be defined outside home-manager due to bees apparently
  users.users.olivia.home = "/Users/olivia";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # development
    cargo
    rustc # required by rust-analyzer
    rustfmt
    clippy
    stats
    radicle-node
    cbqn-replxx
    (python311.withPackages (ps: with ps; [ ipykernel numpy matplotlib ]))
    python313
    # personal
  ];

  # Nix-related configuration
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    optimise.automatic = true;
    gc.automatic = true;
    gc.options = "--delete-older-than 7d";
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  
  # Enable nonfree apps, e.g. vscode
  nixpkgs.config.allowUnfree = true;

  # an overlay is some way to forward to a different registry than nixpkgs, I think?
  nixpkgs.overlays = with inputs; [
    nix-vscode-extensions.overlays.default
  ];

  # yey
  networking.hostName = "pigeon";

  system.primaryUser = "Olivia";
  # settings
  system.defaults = {
    # Don't navigate back and forward with two-finger scroll
    NSGlobalDomain.AppleEnableSwipeNavigateWithScrolls = false;
    # Use 1,234.56 number format 
    CustomSystemPreferences.NSGlobalDomain.AppleICUNumberSymbols = {
      "0" = ".";
      "1" = ",";
      "10" = ".";
      "17" = ",";
    };
    # Use dark theme
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    # Show hidden files
    NSGlobalDomain.AppleShowAllFiles = true;
    finder.AppleShowAllFiles = true;
    # But don't show all extensions
    NSGlobalDomain.AppleShowAllExtensions = false;
    finder.AppleShowAllExtensions = false;
    # Don't expand cursor when wiggling
    CustomUserPreferences.NSGlobalDomain.CGDisableCursorLocationMagnification = true;
    # Key repeat settings: fastest
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain.KeyRepeat = 2;
    # Don't autocorrect!
    NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
    NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticInlinePredictionEnabled = false;
    NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
    CustomUserPreferences.NSGlobalDomain.NSAutomaticTextCompletionEnabled = 0;
    CustomUserPreferences.NSGlobalDomain.WebAutomaticSpellingCorrectionEnabled = 0;
    # Prefer DDG
    CustomUserPreferences.NSGlobalDomain.NSPreferredWebServices.NSWebServicesProviderWebSearch = {
      NSDefaultDisplayName = "DuckDuckGo";
      NSProviderIdentifier = "com.duckduckgo";
    };
    # Custom shortcuts
    CustomUserPreferences.NSGlobalDomain.NSUserKeyEquivalents = {
      "Open With Code" = "@^$\\U00f6";
      "Open With TextEdit" = "@^$\\U00e4";
    };
    # Pretty swell double click threshold
    CustomUserPreferences.NSGlobalDomain."com.apple.mouse.doubleClickThreshold" = "0.5";
    # No natural scroll
    NSGlobalDomain."com.apple.swipescrolldirection" = false;
    # Fast trackpad
    NSGlobalDomain."com.apple.trackpad.scaling" = 3.0;
    # Single tap click
    trackpad.Clicking = true;
    # Disable four and five finger pinch
    CustomUserPreferences."com.apple.AppleMultitouchTrackpad".TrackpadFiveFingerPinchGesture = 0;
    CustomUserPreferences."com.apple.AppleMultitouchTrackpad".TrackpadFourFingerPinchGesture = 0;
    # Enable three finger drag and disable all other uses of it
    trackpad.TrackpadThreeFingerDrag = true;
    trackpad.TrackpadThreeFingerTapGesture = 0;
    CustomUserPreferences."com.apple.AppleMultitouchTrackpad".TrackpadThreeFingerHorizSwipeGesture = 0;
    CustomUserPreferences."com.apple.AppleMultitouchTrackpad".TrackpadThreeFingerVertSwipeGesture = 0;
    # Disable control center from the right edge
    CustomUserPreferences."com.apple.AppleMultitouchTrackpad".TrackpadTwoFingerFromRightEdgeSwipeGesture = 0;
    # Do nothing on fn key
    hitoolbox.AppleFnUsageType = "Do Nothing";
    # DON'T AUTOMATICALLY FUCK UP MY KEYBOARD LAYOUT
    CustomUserPreferences."com.apple.HIToolbox".AppleGlobalTextInputProperties.TextInputGlobalPropertyPerContextInput = 0;
    # I would prefer not to click to show desktop
    WindowManager.EnableStandardClickToShowDesktop = false;
    # Minor control center customizations: hide some things and show others
    # (battery will be shown by Stats app)
    CustomUserPreferences."com.apple.controlcenter"."NSStatusItem Visible Battery" = 0; # not documented?
    controlcenter.Bluetooth = true;
    controlcenter.NowPlaying = false;
    controlcenter.Sound = false;
    # Customize touchbar shortcuts
    CustomUserPreferences."com.apple.controlstrip".MiniCustomized = [
      "com.apple.system.mission-control"
      "com.apple.system.brightness"
      "com.apple.system.volume"
      "com.apple.system.screencapture"
    ];
    # Remove some spotlight options
    CustomUserPreferences."com.apple.spotlight".orderedItems = [
      { enabled = 1; name = "APPLICATIONS"; }
      { enabled = 1; name = "MENU_EXPRESSION"; }
      { enabled = 0; name = "CONTACT"; }
      { enabled = 1; name = "MENU_CONVERSION"; }
      { enabled = 1; name = "MENU_DEFINITION"; }
      { enabled = 1; name = "DOCUMENTS"; }
      { enabled = 0; name = "EVENT_TODO"; }
      { enabled = 1; name = "DIRECTORIES"; }
      { enabled = 0; name = "FONTS"; }
      { enabled = 1; name = "IMAGES"; }
      { enabled = 0; name = "MESSAGES"; }
      { enabled = 0; name = "MOVIES"; }
      { enabled = 0; name = "MUSIC"; }
      { enabled = 1; name = "MENU_OTHER"; }
      { enabled = 1; name = "PDF"; }
      { enabled = 1; name = "PRESENTATIONS"; }
      { enabled = 0; name = "MENU_SPOT LIGHT_SUGGESTIONS"; }
      { enabled = 1; name = "SPREADSHEETS"; }
      { enabled = 1; name = "SYSTEM_PREFS"; }
      { enabled = 0; name = "TIPS"; }
      { enabled = 0; name = "BOOKMARKS"; }
    ];
    # Hide dock
    dock.autohide = true;
    # Minimize to apps, turning minimize into a flamboyant hide
    dock.minimize-to-application = true;
    # DO NOT REARRANGE MY SPACES!!
    dock.mru-spaces = false;
    # No recent apps in dock
    dock.show-recents = false;
    # Don't set persistent apps here because that's hard and they're pointing to the nix store anyways
    # dock.persistent-apps = [
    # ];
    # Hot corners: Bottom right = Show desktop
    dock.wvous-br-corner = 4;
    # Prefer column view in finder
    finder.FXPreferredViewStyle = "clmv";
    # Open ~ on new finder window
    finder.NewWindowTarget = "Home";
    # Enable iCloud Drive to sync desktop and documents
    CustomUserPreferences."com.apple.finder".FXICloudDriveDesktop = 1;
    CustomUserPreferences."com.apple.finder".FXICloudDriveDocuments = 1;
    # Don't show status bar at the bottom in finder
    finder.ShowStatusBar = false;
    # Sort folders first in finder
    finder._FXSortFoldersFirst = true;
    # These are disabled because you can't write to them directly
    # # Three finger double tap zoom
    # CustomUserPreferences."com.apple.universalaccess".closeViewSplitScreenRatio = "0.2";
    # CustomUserPreferences."com.apple.universalaccess".closeViewTrackpadGestureZoomEnabled = 1;
    # CustomUserPreferences."com.apple.universalaccess".closeViewZoomFactorBeforeTermination = 1;
    # CustomUserPreferences."com.apple.universalaccess".closeViewZoomedIn = 0;
    # # Show icons in finder title bar
    # CustomUserPreferences."com.apple.universalaccess".showWindowTitlebarIcons = 1;
  };
  # Allow touchid in sudo prompts
  security.pam.services.sudo_local.touchIdAuth = true;
  # Add p10k font
  fonts.packages = [
    pkgs.meslo-lgs-nf
  ];
  # no
  environment.variables.HOMEBREW_NO_ANALYTICS = "1";
  # homebrew junk here
  homebrew = {
    enable = true;
    # I don't care about idempotent behavior I just wanna have my apps up to date
    onActivation = {
      # update brew formulae
      autoUpdate = true;
      # upgrade packages
      upgrade = true;
      # remove unlisted packages
      cleanup = "zap";
    };
    casks = [
      "firefox"
      "iterm2"
      "steam"
      "karabiner-elements"
      "tailscale"
      "proton-mail"
      "proton-drive"
      "protonvpn"
      "signal"
      "telegram"
      "blender"
      "arduino-ide"
      "kicad"
      "ukelele"
      "processing"
      "fontforge"
      "dyalog"
      "godot"
    ];
  };
}
