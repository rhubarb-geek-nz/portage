# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="somFree - Portable implementation of SOM - interface repository"
HOMEPAGE="https://sourceforge.net/projects/somfree/"
SRC_URI="https://sourceforge.net/projects/somfree/files/src/somfree-code-r76-trunk.zip"
S="$WORKDIR/somfree-code-r76-trunk"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="x86 amd64 arm arm64"
RDEPEND="sys-libs/somtk-rte"
BDEPEND="dev-lang/somtk-comp"

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
		mkdir -p "products/$PLATFORM_HOST/default/bin"

		ln -s ../../../../cpp/cpp.sh "products/$PLATFORM_HOST/default/bin/cpp"

		for d in /usr/lib*/somtk/bin/*
		do
			if test -f "$d"
			then
				ln -s "$d" "products/$PLATFORM_HOST/default/bin"
			fi
		done

		ls -l "products/$PLATFORM_HOST/default/bin"
	fi

	for d in somdapps regimpl somdd somossvr somossvr somdsvr shlbtest ipv6test somdchk dsom rhbgiop1 somd somipc pdl somcdr somdcomm somnmf somos somcorba somu somu2 somabs1 somcslib somp somestrm somst somem soms somdprep somany somdstub somdprep
	do
		rm "$d/unix/$d.mak"
	done

	PLATFORM=$PLATFORM PLATFORM_HOST=$PLATFORM_HOST make || die make all

	echo "#!/bin/sh" > toolbox/dir2rpm.sh

	echo "#!/bin/sh" > toolbox/dir2deb.sh

	chmod +x toolbox/dir2rpm.sh toolbox/dir2deb.sh

	for d in somddsrv
	do
		touch "somidl/$d.idl"
	done

	for d in somdsvr somdchk somossvr somipc pdl
	do
		touch "products/$PLATFORM/default/bin/$d"
	done

	make dist || die make dist
}

src_test() {
	OUTDIR=$(find products -type d -name default)
	
	echo "OUTDIR=$OUTDIR"

	LD_LIBRARY_PATH="$OUTDIR/lib" "$OUTDIR/tests/somtest0" || die somtest0

	LD_LIBRARY_PATH="$OUTDIR/lib" SOMIR="$OUTDIR/etc/somnew.ir" "$OUTDIR/bin/irdump" ::SOMObject::somFree || die irdump ::SOMObject::somFree
}

src_install() {
	OUTDIR=$(find somtkpkg/*/default -type d -name somtk.ir)

	echo "OUTDIR=$OUTDIR"

	test -n "$OUTDIR" || die no OUTDIR

	test -d "$OUTDIR" || die no OUTDIR

	cd "$OUTDIR"

	BASEDIR=usr

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
