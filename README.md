# purpose of the 'debbuild' program

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

## bug fixes ...

starting from [version 0.11.3 of
debbuild](https://github.com/ascherer/debbuild/releases/tag/0.11.3) the
commits of this project deal with

* handling tarballs compressed with various packers
* extracting specfiles from such tarballs
* improved handling of the `%setup` and `%patch` macros
* configuration and invocation of debbuild
* some nuts and bolts under the hood

some – but unfortunately not all – of these improvements have made it back into
[the original source
tree](https://secure.deepnet.cx/svn/debbuild/trunk/debbuild).

## ... and extensions

after version
[svn@210](https://github.com/ascherer/debbuild/releases/tag/SVN%40210)
this project took
[a life of its own](https://github.com/ascherer/debbuild/releases).

* fully externalized `macros`
* conditional build stuff
* advanced option handling
* `%autosetup`/`%autopatch`
* many more nuts and bolts under the hood
