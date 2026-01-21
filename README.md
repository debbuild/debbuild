# debbuild

[![CircleCI](https://circleci.com/gh/debbuild/debbuild.svg?style=svg)](https://circleci.com/gh/debbuild/debbuild) | [![Translation status](https://translate.fedoraproject.org/widgets/debbuild/-/svg-badge.svg)](https://translate.fedoraproject.org/engage/debbuild/?utm_source=widget)

## purpose of the 'debbuild' program

from [the original project page](https://secure.deepnet.cx/trac/debbuild):

> debbuild was written to be able to create packages that will install cleanly
> on Debian systems without going through the head-beating I found was required
> to follow the Debian New Maintainer’s Guide, and pretty much any other
> Debian packaging guide. It uses the build process and command-line options of rpmbuild,
> but produces packages that will install on Debian systems.

[...]

> If you’re careful about filesystem paths, commands, pre/post/(un)install scripts, etc, etc,
> you may be able to write one spec file that you can use to create packages that will install
> and work correctly on **_both_** Debian(ish) and RedHat(ish) systems.

### bug fixes ...

starting from [version 0.11.3 of
debbuild](https://github.com/debbuild/debbuild/releases/tag/0.11.3) the
commits of this project deal with

* handling tarballs compressed with various packers
* extracting specfiles from such tarballs
* improved handling of the `%setup` and `%patch` macros
* configuration and invocation of debbuild
* some nuts and bolts under the hood

some – but unfortunately not all – of these improvements have made it back into
[the original source
tree](https://secure.deepnet.cx/svn/debbuild/trunk/debbuild).

### ... and extensions

after version
[svn@210](https://github.com/debbuild/debbuild/releases/tag/SVN%40210)
this project took
[a life of its own](https://github.com/debbuild/debbuild/releases).

* fully externalized `macros`
* conditional build stuff
* advanced option handling
* `%autosetup`/`%autopatch`
* many more nuts and bolts under the hood

## how to install

debbuild's packages are (naturally) built by debbuild itself. You can generate an installable
`.deb` file for your distribution by running the `./bootstrap.sh` script.

There will typically be prebuilt packages for the latest Ubuntu LTS release attached to GitHub
releases, but you will find packages for other Debian and Ubuntu releases on the openSUSE Build
Service:

* Debian: https://download.opensuse.org/repositories/Debian:/debbuild/
* Ubuntu: https://download.opensuse.org/repositories/Ubuntu:/debbuild/

## how to use

Much like `rpmbuild`, debbuild requires a certain directory structure under your home
directory to build debs. You can easily do this with the following one-line command:

```
mkdir -p $HOME/debbuild/{BUILD,DEBS,SOURCES,SPECS,SDEBS}
```

Place the `.spec` file in `$HOME/debbuild/SPECS`, and the source tarball, named in the format
of `<Name>-<Version>.tar.gz`, in `$HOME/debbuild/SOURCES`. Execute debbuild with the command
`debbuild -bb $HOME/debbuild/SPECS/package.spec` and if all goes well it will build a `.deb`
file and output it to `$HOME/debbuild/DEBS/$arch` (where `$arch` is likely `all` or the name of
your machine's architecture, like `amd64` or `arm64`).

### helpful pastes

If you just need to do a quick-and-dirty build of a project you cloned from git, the following
pastes might help. Please adapt them to your needs.

This assumes you have checked the project out to a directory that matches the package name.

The following will create a source archive from the most recent Git tag, update the `Version`
field in the specfile to match, and build a deb:

```
PROJECT=$(basename `pwd`); \
TAG=$(git tag --sort=version:refname | tail -1); \
VERS=${TAG#v}; \
SPEC=$(find . -type f -name \*.spec | head -1); \
git archive --format=tgz --prefix=${PROJECT}-${VERS}/ -o $HOME/debbuild/SOURCES/${PROJECT}-${VERS}.tar.gz $TAG && \
cp -v "$SPEC" "$HOME/debbuild/SPECS/$(basename $SPEC)" && \
sed -re "s/^Version: (.*)$/Version: $VERS/" -i "$HOME/debbuild/SPECS/$(basename $SPEC)" && \
debbuild -bb "$HOME/debbuild/SPECS/$(basename $SPEC)"
```

The following does the same, but it uses the number of commits in the current branch as a
version number instead:


```
PROJECT=$(basename `pwd`); \
REV=$(git rev-list --count HEAD); \
SPEC=$(find . -type f -name \*.spec | head -1); \
git archive --format=tgz --prefix=${PROJECT}-${REV}/ -o $HOME/debbuild/SOURCES/${PROJECT}-${REV}.tar.gz HEAD && \
cp -v "$SPEC" "$HOME/debbuild/SPECS/$(basename $SPEC)" && \
sed -re "s/^Version: (.*)$/Version: $REV/" -i "$HOME/debbuild/SPECS/$(basename $SPEC)" && \
debbuild -bb "$HOME/debbuild/SPECS/$(basename $SPEC)"
```

## other things you might need

A lot of packages depend on macros that are included with rpmbuild.

Many of them have been ported to debbuild, and are available in the
[debbuild-macros](https://github.com/debbuild/debbuild-macros) repository. This can also be
built as a package and installed alongside debbuild.
