# Nushell Environment Config File
#
# version = 0.82.1

def create_left_prompt [] {
  mut home = ""
  try {
    if $nu.os-info.name == "windows" {
      $home = $env.USERPROFILE
    } else {
      $home = $env.HOME
    }
  }

  let dir = ([
    ($env.PWD | str substring 0..($home | str length) | str replace --string $home "~"),
    ($env.PWD | str substring ($home | str length)..)
  ] | str join)

  let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
  let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
  let path_segment = $"($path_color)($dir)"

  $path_segment | str replace --all --string (char path_sep) $"($separator_color)/($path_color)"
}

def create_right_prompt [] {
  # create a right prompt in magenta with green separators and am/pm underlined
  let time_segment = ([
    (ansi reset)
    (ansi magenta)
    (date now | date format '%Y/%m/%d %r')
  ] | str join | str replace --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
    str replace --all "([AP]M)" $"(ansi magenta_underline)${1}")

  let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
    (ansi rb)
    ($env.LAST_EXIT_CODE)
  ] | str join)
  } else { "" }

  ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# $env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| " > " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| " : " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| " > " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
  "/home/marco/nu"
  ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
  ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]


## aliases
# applications aliases/shorthands
alias python    = python3
alias grep    = rg
alias code    = codium
alias j       = just # I'd rather use Nushell as my build system tho...
alias tarxz     = tar -c -I 'xz -6 -T0' -f
alias ghx     = alacritty -t Helix -e hx
alias lua     = lua5.4
alias unzipgbk  = unzip -O cp936
alias unzipjis  = unzip -O shift-jis
# alias zq      = zoxide query
alias zqi     = zoxide query -i
alias editor    = ^($env.EDITOR) # Let's keep this internal

# shell command shorthands
alias ll      = ls -la
alias lsl     = ls -l
alias lsa     = ls -a
alias md      = mkdir # DOS-ish
alias rmt     = rm -t
alias now     = date now
alias view-source = view source # I like it, reminds me of the view-source protocol
alias cls     = clear

# Don't put `use` import of custom modules here!
# The $env.NU_LIB_DIRS will only function *after* this file is fully loaded.
# Do it in `config.nu`.

# std imports on demand
use std 'path add'
# use std 'clip'

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

path add [
  ($env.HOME | path join neovim bin)
  ($env.HOME | path join bin zig-linux)
  ($env.HOME | path join .cargo bin)
  ($env.HOME | path join bin)
  ($env.HOME | path join bin-flatpak)
  ($env.HOME | path join sh)
  ($env.HOME | path join nu bin)
  ($env.HOME | path join .wasmer bin)
  ($env.HOME | path join .wabt)
  # ($env.HOME | path join bin node-v18.12.1-linux-x64 bin)
]

path add --append [
  ($env.HOME | path join .local share r-miniconda bin)
]

# starship init
# mkdir ~/.cache/starship; starship init nu | save -f ~/.cache/starship/init.nu

load-env {
  # Helix runtime
  HELIX_RUNTIME: "/home/marco/.config/helix/runtime"
  # Wasmer
  WASMER_DIR: "/home/marco/.wasmer"
  # Rust toolchain mirror
  RUSTUP_DIST_SERVER: "https://mirrors.ustc.edu.cn/rust-static"
  RUSTUP_UPDATE_ROOT: "https://mirrors.ustc.edu.cn/rust-static/rustup"
  # EDITOR
  EDITOR: "hx"
  # VISUAL: "alacritty -t Helix -e hx"
  VISUAL: "hx"
  # HELPER
  NU_HELPER: "tldr"
  XDG_DATA_DIRS: (
    $env.XDG_DATA_DIRS
    + ':/home/marco/.local/share/flatpak/exports/share'
    + ':/var/lib/flatpak/exports/share'
  )
}

