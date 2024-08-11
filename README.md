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
1. update versions:
```bash
./updatePkgVer.sh safu/ 0.57.1
./updatePkgVer.sh samconf/ 0.57.1
./updatePkgVer.sh elos/ 0.57.1
```
2. test build `./docker-run.sh`
3. in docker run, test and play with elos
```bash
sudo /usr/lib/elos/tests/smoketest.sh
```
4. in docker check packages with namcap
5. for each package: git add , git commit, git push
```bash
git submodule foreach git add .SRCINFO PKGBUILD
git submodule foreach git commit
git submodule foreach git push aur HEAD:master
```
