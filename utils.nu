#!/usr/bin/env nu

# Use with `source utils.nu`

def move-here [cfgs] {
  $cfgs | transpose name path | par-each {
    |it|
    mkdir $it.name
    ln -f ($it.path | path expand) $"./($it.name)/"
  }
}

def add-commit-push [] {
  git add .
  commit-update
  git push
}

alias acp = add-commit-push

def commit-update [] {
  let today = (date now | date format %F)
  git commit -m $'Update ($today)'
}
