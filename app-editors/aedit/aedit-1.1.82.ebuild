# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Text editor based on interface from Intel ISIS-II aedit"
HOMEPAGE="https://sourceforge.net/projects/aedit/"
SRC_URI="https://sourceforge.net/projects/aedit/files/src/aedit-82.tar.gz"
S="$WORKDIR/aedit-82"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sparc x86"

src_configure() {
	CFLAGS="-Wall -Werror $CFLAGS" ./configure || die configure
}

src_compile() {
	CFLAGS="-Wall -Werror $CFLAGS" emake aedit || die make
	bzip2 < aedit.1 > aedit.1.bz2 || die make
}

src_install() {
	install -D aedit "$D/usr/bin/aedit"
	install -D aedit.1.bz2 "$D/usr/share/man/man1/aedit.1.bz2"
}
