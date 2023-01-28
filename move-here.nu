#!/usr/bin/env nu

def move-here [cfgs] {
  let cfgsname = ($cfgs | transpose key value | get key)
  for name in $cfgsname {
    mkdir $name
    ln -f ($cfgs | get $name | path expand) $"./($name)/"
  }
}
