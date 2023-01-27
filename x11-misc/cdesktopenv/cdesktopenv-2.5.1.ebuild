# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The Common Desktop Environment, the classic UNIX desktop"
HOMEPAGE="https://sourceforge.net/projects/cdesktopenv/"
KEYWORDS="arm arm64 x86 amd64"
SRC_URI="arm? ( cdesktopenv-2.5.1-20230127005253-armv7l.tar.gz )
arm64? ( cdesktopenv-2.5.1-20230127005143-aarch64.tar.gz )
x86? ( cdesktopenv-2.5.1-20230127005004-i686.tar.gz )
amd64? ( cdesktopenv-2.5.1-20230127004006-x86_64.tar.gz )"

LICENSE="GPL-2+"
SLOT="0"

DEPEND="app-arch/ncompress
	app-shells/ksh
	media-fonts/font-bitstream-100dpi
	media-libs/freetype
	media-libs/libjpeg-turbo
	net-libs/rpcsvc-proto
	net-nds/rpcbind
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
