# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="somFree - Portable implementation of SOM - development kit"
HOMEPAGE="https://sourceforge.net/projects/somfree/"
ESVN_REPO_URI="https://svn.code.sf.net/p/somfree/code/trunk@65"
RDEPEND="net-libs/somtk-dsom
	dev-lang/somtk-comp"

inherit subversion

LICENSE="LGPL-3+"
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

	chmod +x toolbox/dir2rpm.sh toolbox/dir2deb.sh

	PLATFORM=$($CONFIG_GUESS)
	PLATFORM_HOST=ebuild-pc-linux-gnu

	if test ! -f products/$PLATFORM_HOST/default/bin/cpp
	then
		mkdir -p products/$PLATFORM_HOST/default/bin

		ln -s ../../../../cpp/cpp.sh products/$PLATFORM_HOST/default/bin/cpp
	fi

	if ( PLATFORM=$PLATFORM PLATFORM_HOST=$PLATFORM_HOST make )
	then
		:
	else
		rm -rf products/$PLATFORM_HOST
		ln -s $PLATFORM products/$PLATFORM_HOST
		make || die make all
	fi

	echo "#!/bin/sh" > toolbox/dir2rpm.sh

	echo "#!/bin/sh" > toolbox/dir2deb.sh

	make dist || die make dist
}

src_test() {
	OUTDIR=$(find products -type d -name default)
	
	echo "OUTDIR=$OUTDIR"

	LD_LIBRARY_PATH="$OUTDIR/lib" "$OUTDIR/tests/somtest0" || die somtest0

	LD_LIBRARY_PATH="$OUTDIR/lib" SOMIR="$OUTDIR/etc/somnew.ir" "$OUTDIR/bin/irdump" ::SOMObject::somFree || die irdump ::SOMObject::somFree

	cat ipv6test/gnuelf/ipv6test.h 

	"$OUTDIR/tests/ipv6test" || die make test

	cat ipv6test/gnuelf/ipv6test.h 
}

src_install() {
	OUTDIR=$(find somtkpkg/*/default -type d -name somtk.dev)

	echo "OUTDIR=$OUTDIR"

	test -n "$OUTDIR" || die no OUTDIR

	test -d "$OUTDIR" || die no OUTDIR

	cd "$OUTDIR"

	BASEDIR=usr/share

	find "$BASEDIR" -type d | while read N
	do
		install -d "$D/$N" || die install dir "$N"
	done

	find "$BASEDIR" -type f | while read N
	do
		install "$N" "$D/$(dirname $N)" || die install file "$N"
	done

	find "$BASEDIR" -type l | while read N
	do
		ln -s $(readlink "$N") "$D/$N" || die install link "$N"
	done
}
