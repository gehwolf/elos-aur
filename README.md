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
for i in safu samconf elos; do
    pushd $i
    makepkg -g
    popd
done
```
3. test build `./docker-run.sh`
4. in docker check packages with namcap
5. in docker run, test and play with elos
6. update .SRCINFO
```bash
for i in safu samconf elos; do
    pushd $i
    makepkg --printsrcinfo > .SRCINFO
    popd
done
```
7. for each package: git add , git commit, git push
