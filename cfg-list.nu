# needs to be symlinked to one of your $env.NU_LIB_DIRS!
export def main [] {
  {
    alacritty:      "~/.config/alacritty/alacritty.yml"
    R:              "~/.Rprofile"
    git:            "~/.gitconfig"
    starship:       "~/.config/starship.toml"
    fontconfig:     "~/.config/fontconfig/fonts.conf"
    delta:          "~/themes.gitconfig"
    helix:          "~/.config/helix/config.toml"
    helix_lang:     "~/.config/helix/languages.toml"
    helix_theme:    "~/.config/helix/runtime/themes/solarized_mine.toml"
    nushell:        "~/.config/nushell/config.nu"
    nushell-env:    "~/.config/nushell/env.nu"
    nushell-plugin: "~/.config/nushell/plugin.nu"
    nushell-def:    "~/nu/definitions.nu"
    bat:            "~/.config/bat/config"
    bottom:         "~/.config/bottom/bottom.toml"
    zellij:         "~/.config/zellij/config.kdl"
    cargo:          "~/.cargo/config"
    wezterm:        "~/.wezterm.lua"
    rime: {
      file: "~/.local/share/fcitx5/rime/default.custom.yaml" 
      action: {|| cd ~/.local/share/fcitx5/rime}
    }
    proxychains: "/etc/proxychains.conf"
  }
}
