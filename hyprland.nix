{
  inputs = {
    hyprland.url = "github:hyprwm/Hyprland";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
  };
  
  outputs = {
  imports = [ hyprland.homeManagerModules.default ];
  wayland.windowManager.hyprland {
    enabled = true;
    extraConfig = ''
      # window layout
      monitor=DP-1,1920x1080@240,0x0,1,vrr,1
      monitor=DP-3:2560x1440@75,1920x0,1,vrr,1
      monitor=HDMI-1:1920x1080@75,0x1080,1,transform,2
      
      # workspaces
      workspace=1,monitor:DP-1,persistent:true
      workspace=2,monitor:DP-1,persistent:true
      workspace=3,monitor:DP-1,persistent:true
      workspace=4,monitor:DP-3,persistent:true
      workspace=5,monitor:DP-3,persistent:true
      workspace=6,monitor:DP-3,persistent:true
      workspace=7,monitor:HDMI-1,persistent:true
      workspace=8,monitor:HDMI-1,persistent:true
      workspace=9,monitor:HDMI-1,persistent:true
      
      # window rules
      windowrule=pseudo,^(alacritty)$
      
      # Keybinds
      $mod = SUPER
      
      ## base
      bind=$mod,Q,killactive
      
      ## programs
      bind=$mod,T,exec,alacritty
    '';
  };
  
  programs = {
    alacritty.enabled = true;
  };
}

