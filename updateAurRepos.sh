#!/bin/sh -eu

git submodule update --init --recursive
git submodule foreach git reset --hard origin/HEAD
