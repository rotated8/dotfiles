#!/usr/bin/env bash

hyperfine "nvim -u NORC +qa" --warmup=20
find . -maxdepth 1 -regextype egrep -regex ".*(vim|lua)" | sort | xargs -I{} hyperfine "nvim -u '{}' +qa" --warmup=20
