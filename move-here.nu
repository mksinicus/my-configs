#!/usr/bin/env nu

def main [cfgs] {
  let cfgs = ($cfgs | from nuon)
  let cfgsname = ($cfgs | transpose key value | get key)
  for name in $cfgsname {
    mkdir $name
    ln -f ($cfgs | get $name | path expand) $"./($name)/"
  }
}