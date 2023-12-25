const U_ROOT = ('.' | path expand)
const cfg_list = 'cfg-list.nu'

export def main [] {
  assure-pwd
  move-here (open-cfgs)
  acp
}

export def acp [] {
  assure-pwd
  def break-acp [] {
    error make {
      msg: "Git add-commit interrupted."
    }
  }

  git diff
  match (input 'Changes should display above. Continue? (y/N)') {
    'y' => {}
    _ => {break-acp}
  }
  git add .
  git commit -m (date now | format date %F) -e # Force edit commit message
  git push
}

export def move-here [cfgs] {
  $cfgs | transpose name path | par-each {
    |it|
    mkdir $it.name
    cp -f ($it.path | path expand) $"./($it.name)/"
  }
}
export alias m = move-here

# assure pwd
def --env assure-pwd [] {
  cd $U_ROOT
}

def open-cfgs [] {
  use $cfg_list
  cfg-list
  | transpose key value
  | update value {
    |col| $col.value | match ($in | describe) {
      'string' => {$col.value | path expand}
      'record<file: string, action: closure>' => {
        $col.value | get file | path expand
      }
    }
  }
  | transpose -rd
}

