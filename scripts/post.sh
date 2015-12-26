%define darch %{_bindir}/dpkg-architecture

if [ -x %{darch} ]; then
DEB_HOST_CPU=`%{darch} -qDEB_HOST_GNU_CPU 2>/dev/null`
DEB_HOST_OS=`%{darch} -qDEB_HOST_ARCH_OS 2>/dev/null`
DEB_HOST_SYSTEM=`%{darch} -qDEB_HOST_GNU_SYSTEM 2>/dev/null`
DEB_HOST_ARCH=`%{darch} -qDEB_HOST_ARCH_CPU 2>/dev/null`
DEB_BUILD_ARCH=`%{darch} -qDEB_BUILD_ARCH 2>/dev/null`

%{__sed} -e "s/@HOST_ARCH@/${DEB_HOST_ARCH}/g" \
         -e "s/@BUILD_ARCH@/${DEB_BUILD_ARCH}/g" \
         -e "s/@HOST_CPU@/${DEB_HOST_CPU}/g" \
         -e "s/@HOST_OS@/${DEB_HOST_OS}/g" \
         -e "s/@HOST_SYSTEM@/${DEB_HOST_SYSTEM}/g" \
         -i %{_libdir}/%{name}/macros
fi
