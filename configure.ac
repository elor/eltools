AC_INIT([eltools], [1.0], [erik.e.lorenz@gmail.com])
#AC_PREREQ(2.12)
AM_INIT_AUTOMAKE()

AC_ARG_ENABLE([chem],
AS_HELP_STRING([--enable-chem], [Include chem scripts]),
[case "${enableval}" in
  yes) chem=true ;;
  no) chem=false ;;
  *) AC_MSG_ERROR([bad value ${enableval} for --enable-debug]) ;;
esac],[chem=false])
AM_CONDITIONAL([HAVE_CHEM], [test x$chem = xtrue])

AC_ARG_ENABLE([interactive],
AS_HELP_STRING([--enable-interactive], [Include interactive scripts]),
[case "${enableval}" in
  yes) interactive=true ;;
  no) interactive=false ;;
  *) AC_MSG_ERROR([bad value ${enableval} for --enable-debug]) ;;
esac],[interactive=false])
AM_CONDITIONAL([HAVE_INTERACTIVE], [test x$interactive = xtrue])

AC_ARG_ENABLE([bash],
AS_HELP_STRING([--enable-bash], [Include bash scripts]),
[case "${enableval}" in
  yes) bash=true ;;
  no) bash=false ;;
  *) AC_MSG_ERROR([bad value ${enableval} for --enable-debug]) ;;
esac],[bash=false])
AM_CONDITIONAL([HAVE_BASH], [test x$bash = xtrue])

AC_ARG_ENABLE([build],
AS_HELP_STRING([--enable-build], [Include build scripts]),
[case "${enableval}" in
  yes) build=true ;;
  no) build=false ;;
  *) AC_MSG_ERROR([bad value ${enableval} for --enable-debug]) ;;
esac],[build=false])
AM_CONDITIONAL([HAVE_BUILD], [test x$build = xtrue])

AC_ARG_ENABLE([git],
AS_HELP_STRING([--disable-git], [Exclude git scripts]),
[case "${enableval}" in
  yes) git=true ;;
  no) git=false ;;
  *) AC_MSG_ERROR([bad value ${enableval} for --enable-debug]) ;;
esac],[git=true])
AM_CONDITIONAL([HAVE_GIT], [test x$git = xtrue])

AC_ARG_ENABLE([desktop],
AS_HELP_STRING([--disable-desktop], [Exclude desktop scripts]),
[case "${enableval}" in
  yes) desktop=true ;;
  no) desktop=false ;;
  *) AC_MSG_ERROR([bad value ${enableval} for --enable-debug]) ;;
esac],[desktop=true])
AM_CONDITIONAL([HAVE_DESKTOP], [test x$desktop = xtrue])

AC_ARG_ENABLE([pdflatex],
AS_HELP_STRING([--enable-pdflatex], [Include pdflatex scripts]),
[case "${enableval}" in
  yes) pdflatex=true ;;
  no) pdflatex=false ;;
  *) AC_MSG_ERROR([bad value ${enableval} for --enable-debug]) ;;
esac],[pdflatex=false])
AM_CONDITIONAL([HAVE_PDFLATEX], [test x$pdflatex = xtrue])

AC_ARG_ENABLE([arch],
AS_HELP_STRING([--enable-arch], [Include arch scripts]),
[case "${enableval}" in
  yes) arch=true ;;
  no) arch=false ;;
  *) AC_MSG_ERROR([bad value ${enableval} for --enable-debug]) ;;
esac],[arch=false])
AM_CONDITIONAL([HAVE_ARCH], [test x$arch = xtrue])

AC_ARG_ENABLE([download],
AS_HELP_STRING([--disable-download], [Exclude download scripts]),
[case "${enableval}" in
  yes) download=true ;;
  no) download=false ;;
  *) AC_MSG_ERROR([bad value ${enableval} for --enable-debug]) ;;
esac],[download=true])
AM_CONDITIONAL([HAVE_DOWNLOAD], [test x$download = xtrue])

AC_ARG_ENABLE([mount],
AS_HELP_STRING([--disable-mount], [Exclude mount scripts]),
[case "${enableval}" in
  yes) mount=true ;;
  no) mount=false ;;
  *) AC_MSG_ERROR([bad value ${enableval} for --enable-debug]) ;;
esac],[mount=true])
AM_CONDITIONAL([HAVE_MOUNT], [test x$mount = xtrue])
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
