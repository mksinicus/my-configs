# Nushell Config File

# for more information on themes see
# https://www.nushell.sh/book/coloring_and_theming.html
let dark_theme = {
    # color for nushell primitives
    separator: white
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: green_bold
    empty: blue
    bool: white
    int: white
    filesize: white
    duration: white
    date: white
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cellpath: white
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray

    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b}
    shape_binary: purple_bold
    shape_bool: light_cyan
    shape_int: purple_bold
    shape_float: purple_bold
    shape_range: yellow_bold
    shape_internalcall: cyan_bold
    shape_external: cyan
    shape_externalarg: green_bold
    shape_literal: blue
    shape_operator: yellow
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_datetime: cyan_bold
    shape_list: cyan_bold
    shape_table: blue_bold
    shape_record: cyan_bold
    shape_block: blue_bold
    shape_filepath: cyan
    shape_globpattern: cyan_bold
    shape_variable: purple
    shape_flag: blue_bold
    shape_custom: green
    shape_nothing: light_cyan
}

let light_theme = {
    # color for nushell primitives
    separator: dark_gray
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: green_bold
    empty: blue
    bool: dark_gray
    int: dark_gray
    filesize: dark_gray
    duration: dark_gray
    date: dark_gray
    range: dark_gray
    float: dark_gray
    string: dark_gray
    nothing: dark_gray
    binary: dark_gray
    cellpath: dark_gray
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray

    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b}
    shape_binary: purple_bold
    shape_bool: light_cyan
    shape_int: purple_bold
    shape_float: purple_bold
    shape_range: yellow_bold
    shape_internalcall: cyan_bold
    shape_external: cyan
    shape_externalarg: green_bold
    shape_literal: blue
    shape_operator: yellow
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_datetime: cyan_bold
    shape_list: cyan_bold
    shape_table: blue_bold
    shape_record: cyan_bold
    shape_block: blue_bold
    shape_filepath: cyan
    shape_globpattern: cyan_bold
    shape_variable: purple
    shape_flag: blue_bold
    shape_custom: green
    shape_nothing: light_cyan
}

# The default config record. This is where much of your global configuration is setup.
let-env config = {
  ls: {
    use_ls_colors: true # use the LS_COLORS environment variable to colorize output
    clickable_links: true # enable or disable clickable links. Your terminal has to support links.
  }
  rm: {
    always_trash: false # always act as if -t was given. Can be overridden with -p
  }
  cd: {
    abbreviations: true # allows `cd s/o/f` to expand to `cd some/other/folder`
  }
  table: {
    mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
    index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
    trim: {
      methodology: wrapping # wrapping or truncating
      wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
      truncating_suffix: "..." # A suffix used by the 'truncating' methodology
    }
  }
  history: {
    max_size: 100000 # Session has to be reloaded for this to take effect
    sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
    file_format: "sqlite" # "sqlite" or "plaintext"
  }
  completions: {
    case_sensitive: false # set to true to enable case-sensitive completions
    quick: true  # set this to false to prevent auto-selecting completions when only one remains
    partial: true  # set this to false to prevent partial filling of the prompt
    algorithm: "prefix"  # prefix or fuzzy
    external: {
      enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up my be very slow
      max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
      completer: null # check 'carapace_completer' above as an example
    }
  }
  filesize: {
    metric: true # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
    format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
  }
  color_config: $light_theme   # if you want a light theme, replace `$dark_theme` to `$light_theme`
  datetime_format: {
    normal: "%F %T %Z" # shows up in displays of variables or other datetime's outside of tables
    # table: "%F %T %Z" # generally shows up in tabular outputs such as ls. commenting this out will change it to the default human readable datetime format
  }
  use_grid_icons: true
  footer_mode: "25" # always, never, number_of_rows, auto
  float_precision: 2
  buffer_editor: "hx" # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
  use_ansi_coloring: true
  edit_mode: emacs # emacs, vi
  shell_integration: true # enables terminal markers and a workaround to arrow keys stop working issue
  show_banner: false # true or false to enable or disable the banner
  render_right_prompt_on_last_line: false # true or false to enable or disable right prompt to be rendered on last line of the prompt.
  hooks: {
    pre_prompt: [
      # {|| $nothing}  # replace with source code to run before the prompt is shown
    ]
    pre_execution: [
      # {|| $nothing}  # replace with source code to run before the repl input is run
    ]
    env_change: {
      PWD: [{|before, after|
        $nothing  # replace with source code to run if the PWD environment is different since the last repl input
      }]
    }
    display_output: {||
      if (term size).columns >= 100 { table -e } else { table }
    }
  }
  menus: [
      # Configuration for default nushell menus
      # Note the lack of souce parameter
      {
        name: completion_menu
        only_buffer_difference: false
        marker: "| "
        type: {
            layout: columnar
            columns: 4
            col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
            col_padding: 2
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
      }
      {
        name: history_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
      }
      {
        name: help_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: description
            columns: 4
            col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
      }
      # Example of extra menus created using a nushell source
      # Use the source field to create a list of records that populates
      # the menu
      {
        name: commands_menu
        only_buffer_difference: false
        marker: "# "
        type: {
            layout: columnar
            columns: 4
            col_width: 20
            col_padding: 2
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.commands
            | where command =~ $buffer
            | each { |it| {value: $it.command description: $it.usage} }
        }
      }
      {
        name: vars_menu
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.vars
            | where name =~ $buffer
            | sort-by name
            | each { |it| {value: $it.name description: $it.type} }
        }
      }
      {
        name: commands_with_description
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: description
            columns: 4
            col_width: 20
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.commands
            | where command =~ $buffer
            | each { |it| {value: $it.command description: $it.usage} }
        }
      }
  ]
  keybindings: [
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: emacs # Options: emacs vi_normal vi_insert
      event: {
        until: [
          { send: menu name: completion_menu }
          { send: menunext }
        ]
      }
    }
    {
      name: completion_previous
      modifier: shift
      keycode: backtab
      mode: [emacs, vi_normal, vi_insert] # Note: You can add the same keybinding to all modes by using a list
      event: { send: menuprevious }
    }
    {
      name: history_menu
      modifier: control
      keycode: char_r
      mode: emacs
      event: { send: menu name: history_menu }
    }
    {
      name: next_page
      modifier: control
      keycode: char_x
      mode: emacs
      event: { send: menupagenext }
    }
    {
      name: undo_or_previous_page
      modifier: control
      keycode: char_z
      mode: emacs
      event: {
        until: [
          { send: menupageprevious }
          { edit: undo }
        ]
       }
    }
    {
      name: yank
      modifier: control
      keycode: char_y
      mode: emacs
      event: {
        until: [
          {edit: pastecutbufferafter}
        ]
      }
    }
    {
      name: unix-line-discard
      modifier: control
      keycode: char_u
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          {edit: cutfromlinestart}
        ]
      }
    }
    {
      name: kill-line
      modifier: control
      keycode: char_k
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          {edit: cuttolineend}
        ]
      }
    }
    # Keybindings used to trigger the user defined menus
    {
      name: commands_menu
      modifier: control
      keycode: char_t
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_menu }
    }
    {
      name: vars_menu
      modifier: alt
      keycode: char_o
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: vars_menu }
    }
    {
      name: commands_with_description
      modifier: control
      keycode: char_s
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_with_description }
    }
  ]
}

## Private configs begin

# Helix runtime
let-env HELIX_RUNTIME = "/home/marco/.config/helix/runtime"

# Wasmer
let-env WASMER_DIR = "/home/marco/.wasmer"

# Broot
def-env br [
  --args (-a): string
] {
  let cmd_file = (^mktemp | str trim)
  if ($args | is-empty) {
    ^broot --outcmd $cmd_file
  } else {
    ^broot $args --outcmd $cmd_file
  }
  let-env cmd = ((open $cmd_file) | str trim)
  ^rm $cmd_file
  cd ($env.cmd | str replace "cd" "" | str trim)
}

# starship init
source /home/marco/.cache/starship/init.nu

# zoxide init
source /home/marco/nu/.zoxide.nu

# Rust toolchain mirror
let-env RUSTUP_DIST_SERVER = "https://mirrors.ustc.edu.cn/rust-static"
let-env RUSTUP_UPDATE_ROOT = "https://mirrors.ustc.edu.cn/rust-static/rustup"


## More personal configurations
# PATH
let-env PATH = (
  $env.PATH
  | prepend '/home/marco/.cargo/bin'
  | # prepend '/home/marco/bin'
  | # prepend '/home/marco/bin-flatpak'
  | prepend '/home/marco/sh'
  | prepend '/home/marco/nu/execs'
  | append '/home/marco/.local/share/r-miniconda/bin' | # My conda's here
  # append '/home/marco/bin/node-v18.12.1-linux-x64/bin/'
  | append '/home/marco/.wasmer/bin'
  | append '/home/marco/.wabt/'
)
let-env XDG_DATA_DIRS = (
  $env.XDG_DATA_DIRS
  + ':/home/marco/.local/share/flatpak/exports/share'
  + ':/var/lib/flatpak/exports/share'
)

# EDITOR
let-env EDITOR = "hx"
# let-env VISUAL = "alacritty -t Helix -e hx"
let-env VISUAL = "hx"
# HELPER
let-env NU_HELPER = "tldr"
# export use std help

## aliases
# applications aliases/shorthands
alias python      = python3
alias grep        = rg
alias code        = codium
alias j           = just
alias tarxz       = tar -c -I 'xz -6 -T0' -f
alias ghx         = alacritty -t Helix -e hx
alias lua         = lua5.4
alias unzipgbk    = unzip -O cp936
alias unzipjis    = unzip -O shift-jis
# alias zq          = zoxide query
alias zqi         = zoxide query -i
alias editor      = ^($env.EDITOR) # Let's keep this internal

# aliases for pijul; should really be in externs
# alias "pj switch" = pj channel switch
# alias "pj logch"  = pj log --channel
# alias "pj amend"  = pj record --amend
# "

# shell command shorthands
alias lsla        = ls -la
alias lsl         = ls -l
alias lsa         = ls -a
alias md          = mkdir # DOS-ish
alias rmt         = rm -t
alias now         = date now
alias view-source = view source # I like it, reminds me of the view-source protocol
# alias c           = clear
alias cls         = clear

# utilities
alias rimecfg     = cd /home/marco/.local/share/fcitx5/rime
alias chrono      = cd /home/marco/privo/chronographo

# Simple closures
# P.ex. `ls | recent 10min`
alias recent   = do {|x| where modified > (date now) - $x}
alias get-extension = do {insert extension {|c| $c.name | path parse | get extension}}
alias dehuman  = do {update modified {|c| $c.modified | date format %+}}
alias today    = do {date now | date format %F}
alias datetime = do {date now | date format %+}
alias hhmmss   = do {date now | date format %H:%M:%S}
alias zq       = do {|x| zoxide query $x | str trim}
# alias negate   = do {|| $in | (not $in)} # don't know why, it crashes.
# Let's use a more stable function approach
# def negate [] {not $in}
# Let's move them to a module file! But for now we can have it like this:
alias negate = collect {|x| not $x}
# alias c        = collect --keep-env {|x| cd $x; ls} # This can't take postpositional arguments

export def-env c [path: path] {
  cd $path
  ls
}


# While they are inside $env.NU_LIB_DIRS, no need to write full path
# Utilities that require import
use .mdcd.nu           *
use .into-hex.nu       *
use .clip.nu           *
use .math-is-prime.nu  *
use .into-utf8.nu      *
use .url-decode.nu     *
use .move-recent.nu    *
use .renamer.nu        *
use .entity.nu         *
use .history-recent.nu *
use .ls-visual.nu      *
use .lsr.nu  *
use .rmd-new.nu *
use .m3u82mp4.nu *
use utils.nu *

use qmv.nu
use touchmod.nu

## Utilities that require specified env variables
use .libris.nu *
let-env LIBRIS_WD = "~/.libris/"
use .facienda.nu *
let-env FACIENDA_WD = "~/.facienda/"
use .habitu.nu   *
let-env HABITU_WD = "~/.habitu/"
use .quotidie.nu *
let-env JOURNAL_WD = "~/.journal/"
use .journal.nu *

# My modules
use .nota.nu *

# Custom completions/externs
# use /home/marco/nu/externs/helix.nu  * # Subcommands ain't good for an editor
use externs/zellij.nu *
use externs/tar.nu    *
use externs/pijul.nu  *

# Originally at top of this file
# Get just the extern definitions without the custom completion commands
use externs/git.nu *

# Background Task (https://www.nushell.sh/book/background_task.html)
use job.nu

# Custom completions provided by nu_scripts
# Greatly slows down init!
# source /home/marco/nu/third/auto-gen-completions.nu

# useful variables
let cfgs = {
  alacritty:      "/home/marco/.config/alacritty/alacritty.yml"
  rime:           "/home/marco/.local/share/fcitx5/rime/default.custom.yaml"
  R:              "/home/marco/.Rprofile"
  git:            "/home/marco/.gitconfig"
  starship:       "/home/marco/.config/starship.toml"
  fontconfig:     "/home/marco/.config/fontconfig/fonts.conf"
  delta:          "/home/marco/themes.gitconfig"
  helix:          "/home/marco/.config/helix/config.toml"
  helix_lang:     "/home/marco/.config/helix/languages.toml"
  helix_theme:    "/home/marco/.config/helix/runtime/themes/solarized_mine.toml"
  nushell:        "/home/marco/.config/nushell/config.nu"
  nushell-env:    "/home/marco/.config/nushell/env.nu"
  nushell-plugin: "/home/marco/.config/nushell/plugin.nu"
  bat:            "/home/marco/.config/bat/config"
  bottom:         "/home/marco/.config/bottom/bottom.toml"
  zellij:         "/home/marco/.config/zellij/config.kdl"
  cargo:          "/home/marco/.cargo/config"
  wezterm:        "/home/marco/.wezterm.lua"
}
