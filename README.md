# purpose of the 'debbuild' programme

see [the original project page](https://secure.deepnet.cx/trac/debbuild) for
the rationale of this stuff.

## bug fixes and extensions

starting from [version 0.11.3 of
debbuild](https://github.com/ascherer/debbuild/releases/tag/debbuild-0.11.3) the
commits of this project deal with

* handling tarballs compressed with various packers
* extracting specfiles from such tarballs
* improved handling of the `%setup` and `%patch` macros
* configuration and invocation of debbuild
* many more nuts and bolts under the hood

some – but unfortunately not all – of these improvements have made it back into
[the original source
tree](https://secure.deepnet.cx/svn/debbuild/trunk/debbuild).

after version
[svn@210](https://github.com/ascherer/debbuild/releases/tag/SVN%40210)
this project took
[a life of its own](https://github.com/ascherer/debbuild/releases).

## result

after several hundred commits, this effort resulted in the release of [debbuild
15.12.0](https://github.com/ascherer/debbuild/releases/tag/debbuild-15.12.0).
