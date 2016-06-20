if [ -x %{__dpkg_architecture} ]; then
eval `%{__dpkg_architecture} -s`

%{__sed} -e "s/@BUILD_ARCH@/${DEB_BUILD_ARCH}/g" \
         -e "s/@HOST_ARCH@/${DEB_HOST_ARCH}/g" \
         -e "s/@HOST_OS@/${DEB_HOST_ARCH_OS}/g" \
         -e "s/@HOST_CPU@/${DEB_HOST_GNU_CPU}/g" \
         -e "s/@HOST_SYSTEM@/${DEB_HOST_GNU_SYSTEM}/g" \
         -i %{_libdir}/%{name}/macros
fi
