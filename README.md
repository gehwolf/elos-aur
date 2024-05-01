# elos-aur
Build and test aur packages of elos and its dependencies.

## Setup

```sh
git submodule update --init --recursive
```

## Build and Test

```sh
./docker-run.sh
```

## Release

1. update versions PKGBUILD
2. update checksums
```bash
git submodule foreach makepkg -g
git submodule foreach git diff
```
3. test build `./docker-run.sh`
4. in docker check packages with namcap
5. in docker run, test and play with elos
```bash
sudo /usr/lib/elos/tests/smoketest.sh
```
6. update .SRCINFO
```bash
git submodule foreach sh -c 'makepkg --printsrcinfo > .SRCINFO'
```
7. for each package: git add , git commit, git push
