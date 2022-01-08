# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The Common Desktop Environment, the classic UNIX desktop"
HOMEPAGE="https://sourceforge.net/projects/cdesktopenv/"
SRC_URI="https://sourceforge.net/projects/cdesktopenv/files/src/cde-2.4.0.tar.gz"
S="$WORKDIR"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"

DEPEND="app-arch/ncompress
	app-shells/ksh
	dev-lang/tcl
	media-fonts/font-bitstream-100dpi
	media-libs/freetype
	media-libs/libjpeg-turbo
	net-libs/rpcsvc-proto
	net-nds/rpcbind
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/bc
	sys-devel/bison
	sys-devel/flex
	sys-devel/libtool
	sys-devel/m4
	sys-libs/libutempter
	sys-libs/pam
	virtual/libcrypt
	x11-apps/bdftopcf
	x11-apps/mkfontscale
	x11-apps/xrdb
	x11-apps/xset
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXaw
	x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	x11-libs/motif
	x11-misc/xbitmaps"

RDEPEND="${DEPEND}"

pkg_pretend() {
	# Check system support of required locales.
	for check_locale in de_DE es_ES fr_FR it_IT; do
		LOCALE_STRING="${check_locale}.iso88591"
		[[ $'\n'$(locale -a) =~ $'\n'${LOCALE_STRING}$'\n' ]] || die "LOCALE ${LOCALE_STRING} is required to build CDE"
	done
	grep "^mail:" /etc/group || die group mail missing
	ls -ld /bin/ksh || die missing /bin/ksh
}

src_compile() {
	cd cde-2.4.0
	make World || die make World
	ls -ld exports/include/Dt/Dt.h programs/dtksh/dtksh programs/dtdocbook/instant/instant || die missing files
}

src_test() {
	cd cde-2.4.0
	ls -ld exports/include/Dt/Dt.h programs/dtksh/dtksh programs/dtdocbook/instant/instant || die missing files
}

src_install() {
	MYTMPDIR=$(pwd)"/cdesktop.$$.ebuild.d"

	mkdir "$MYTMPDIR"

	for CMD in mkdir
	do
		ORIGINAL=$(which $CMD)

		cat >"$MYTMPDIR/$CMD" << EOF 
#!/bin/sh

	ARGS=

	for d in "\$@"
	do
		case "\$d" in
			/etc/dt | /var/dt | /usr/dt )
				ARGS="\$ARGS $D\$d"
				;;
			* )
				ARGS="\$ARGS \$d"
				;;
		esac
	done

	if test -n "\$ARGS"
	then
		$ORIGINAL \$ARGS
	fi
EOF

		chmod +x "$MYTMPDIR/$CMD"
	done

	(
		set -e

		trap "rm -rf $MYTMPDIR" 0

		cd cde-2.4.0

		PATH="$MYTMPDIR:$PATH" admin/IntegTools/dbTools/installCDE -s $(pwd) -destdir "$D" -DontRunScripts
	) || die installCDE 
}
