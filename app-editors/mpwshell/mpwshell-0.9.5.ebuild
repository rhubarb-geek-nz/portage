# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Motivated Power Shell - text editor with embedded scripting engine"
HOMEPAGE="https://github.com/rhubarb-geek-nz/MPWShell"
SRC_URI="https://github.com/rhubarb-geek-nz/MPWShell/archive/refs/tags/0.9.5.tar.gz"
S="$WORKDIR/MPWShell-0.9.5/Motif"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64"
DEPEND="x11-libs/motif
	x11-lib/libXpm"

src_configure() {
	true || die configure
}

src_compile() {
	CFLAGS="-Wall -Werror $CFLAGS" emake mpwshell || die make
}

src_install() {
	install -D mpwshell "$D/usr/bin/mpwshell"
}
