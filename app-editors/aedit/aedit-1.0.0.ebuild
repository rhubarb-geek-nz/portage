# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Text editor based on interface from Intel ISIS-II aedit"
HOMEPAGE="https://sourceforge.net/projects/rhbaedit/"
SRC_URI="https://sourceforge.net/projects/rhbaedit/files/src/aedit-11.tar"
S="$WORKDIR/aedit-11"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sparc x86"

src_configure() {
	CFLAGS="-Wall -Werror $CFLAGS" ./configure || die configure
}

src_compile() {
	CFLAGS="-Wall -Werror $CFLAGS" emake aedit || die make
}

src_install() {
	install -d "$D/usr/bin"
	install aedit "$D/usr/bin"
}
