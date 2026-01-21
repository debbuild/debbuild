#!/usr/bin/env bash

set -e
shopt -s nullglob
srcdir=$(cd `dirname $0`; pwd)
project=debbuild

fatal() {
	echo "$1" >&2
	exit 1
}

check_command() {
	which $1 >/dev/null 2>&1 || fatal "$1 not installed"
}

check_command git
check_command make

for dir in BUILD SPECS SOURCES SDEBS DEBS; do
	test -d $HOME/debbuild/$dir || mkdir -p $HOME/debbuild/$dir
done

latest_tag=$(git --git-dir="$srcdir/.git" tag --sort=version:refname | egrep '^[0-9]+(\.[0-9]+)+$' | tail -1)

git archive --format=tgz --prefix="${project}-${latest_tag}/" -o "$HOME/debbuild/SOURCES/${project}-${latest_tag}.tar.gz" "${latest_tag}"
git show "${latest_tag}:debbuild.spec" > "$HOME/debbuild/SPECS/debbuild.spec"

./configure
make

set +e
./debbuild.out -bb "$HOME/debbuild/SPECS/debbuild.spec"
RET=$?
if [ $RET -eq 0 ]; then
	outf=$(ls -1 $HOME/debbuild/DEBS/all/debbuild_${latest_tag}*.deb)
	echo "Success! An installable .deb has been written to:"
	echo "  $outf"
else
	echo "Failed to build. See output above."
fi
