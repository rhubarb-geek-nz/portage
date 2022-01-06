# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ad-hoc tool set for developers"
HOMEPAGE="https://sourceforge.net/projects/rhbtools/"
ESVN_REPO_URI="https://svn.code.sf.net/p/rhbtools/code/trunk@19"

inherit subversion

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="x86 amd64 arm arm64"

src_compile() {

	ls -ld toolbox/asneeded.sh

	cat > toolbox/asneeded.sh << EOF
#!/bin/sh -ex
exec "\$@" -Wl,--as-needed
EOF
	chmod +x toolbox/asneeded.sh

	CFLAGS="$CFLAGS -fPIC" make || die make
}

src_install() {
	install -d "$D/opt/RHBtools/bin"

	find products/*/default/bin -type f | while read N
	do
		install "$N" "$D/opt/RHBtools/bin"
	done
}
