# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="ad-hoc tool set for developers"
HOMEPAGE="https://sourceforge.net/projects/rhbtools/"
SRC_URI="https://sourceforge.net/projects/rhbtools/files/src/rhbtools-19.tar.gz"
S="$WORKDIR/rhbtools-19"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="x86 amd64 arm arm64"

src_compile() {

	CONFIG_GUESS=config/unix/config.guess

	for d in /usr/share/misc/config.guess /usr/share/libtool/config/config.guess /usr/share/automake-*/config.guess
	do
		if test -x "$d" 
		then
			CONFIG_GUESS="$d"
			break
		fi
	done

	PLATFORM=$($CONFIG_GUESS)
	PLATFORM_HOST=ebuild-pc-linux-gnu

	if test ! -f products/$PLATFORM_HOST/default/bin/cpp
	then
		mkdir -p products/$PLATFORM_HOST/default/bin

		ln -s ../../../../cpp/cpp.sh products/$PLATFORM_HOST/default/bin/cpp
	fi

	PLATFORM=$PLATFORM PLATFORM_HOST=$PLATFORM_HOST make || die make all
}

src_install() {
	install -d "$D/opt/RHBtools/bin"

	find products/*/default/bin -type f | while read N
	do
		install "$N" "$D/opt/RHBtools/bin"
	done
}
