# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="The Common Desktop Environment, the classic UNIX desktop"
HOMEPAGE="https://sourceforge.net/projects/cdesktopenv/"
EGIT_REPO_URI="https://git.code.sf.net/p/cdesktopenv/code"
EGIT_COMMIT="341fdfbe7138deaa24252a25790b937bf27601fd"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

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

src_configure() {
	cd cde
	./autogen.sh || die "autogen"
	./configure || die "configure"
}

src_compile() {
	cd cde
	emake
}

src_install() {
	cd cde
	emake install DESTDIR="$D"
}
