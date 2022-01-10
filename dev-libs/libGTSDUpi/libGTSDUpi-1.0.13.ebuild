# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="microSD JavaCard library"
HOMEPAGE="https://sourceforge.net/projects/rhbgtsdu/"
SRC_URI="https://sourceforge.net/projects/rhbgtsdu/files/src/rhbgtsdu-code-r13-trunk-posix.zip"
S="$WORKDIR/rhbgtsdu-code-r13-trunk-posix"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="x86 amd64 arm arm64"

src_compile() {

	make CFLAGS="-Wall -Werror -Iinclude $CFLAGS" LIBS="-lpthread" "STRIP=ls -ld" || die make all
}

src_install() {
 	dolib.so lib*.so
	doheader include/*.h
}
