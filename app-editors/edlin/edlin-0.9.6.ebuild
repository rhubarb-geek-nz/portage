# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Text editor based on MS-DOS endlin"
HOMEPAGE="https://github.com/rhubarb-geek-nz/edlin"
SRC_URI="https://github.com/rhubarb-geek-nz/edlin/archive/refs/tags/0.9.6.tar.gz"
S="$WORKDIR/edlin-0.9.6"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sparc x86"

src_configure() {
	CFLAGS="-Wall -Werror $CFLAGS" ./configure || die configure
}

src_compile() {
	CFLAGS="-Wall -Werror $CFLAGS" emake edlin || die make
	bzip2 < edlin.1 > edlin.1.bz2 || die make
	for d in de en es fr it
	do
		msgfmt -o "edlin-$d.mo" "posix/nls/edlin-$d.po"
	done
}

src_install() {
	install -D edlin "$D/usr/bin/edlin"
	install -D edlin.1.bz2 "$D/usr/share/man/man1/edlin.1.bz2"
	for d in de en es fr it
	do
		install -D "edlin-$d.mo" "$D/usr/share/locale/$d/LC_MESSAGES/edlin.mo"
	done
}
