#!/usr/bin/env nu

# Use with `source utils.nu`

def move-here [cfgs] {
  $cfgs | transpose name path | par-each {
    |it|
    mkdir $it.name
    ln -f ($it.path | path expand) $"./($it.name)/"
  }
}

def add-all [] {
  git add .
}

def commit-update [] {
  let today = (date now | date format %F)
  git commit -m $'Update ($today)'
}
