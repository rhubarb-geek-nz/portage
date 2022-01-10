# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Java Platform, Standard Edition 11 Reference Implementation"
HOMEPAGE="https://jdk.java.net/java-se-ri/11"
SRC_URI="openjdk-11+28_linux-x64_bin.tar.gz"
S="$WORKDIR/jdk-11"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

src_compile() {
	ls -l
}

src_install() {
	install -d "$D/usr/lib64/jvm/openjdk-11"
	tar cf - * | tar xf - -C "$D/usr/lib64/jvm/openjdk-11"
}
