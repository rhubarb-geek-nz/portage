# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="somFree - Portable implementation of SOM - runtime compiler"
HOMEPAGE="https://sourceforge.net/projects/somfree/"
SRC_URI="https://sourceforge.net/projects/somfree/files/src/somfree-code-r76-trunk.zip"
S="$WORKDIR/somfree-code-r76-trunk"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="x86 amd64 arm arm64"
BDEPEND="sys-devel/bc"

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

	for d in dsom somabs1 somu somu2 somd somdd regimpl somdchk soms somst somdsvr somdtype somdprep somdapps somdcomm rhbgiop1 irdump somestrm somir somtc somidl somtkidl somistub shlbtest ipv6test somkprep som somref somiprep somtest0 somcorba somem somcdr somdstub somnmf somos somossvr somany somcslib somp somkpub
	do
		rm "$d/unix/$d.mak"
	done

	if test ! -f products/$PLATFORM_HOST/default/bin/cpp
	then
		mkdir -p products/$PLATFORM_HOST/default/bin

		ln -s ../../../../cpp/cpp.sh products/$PLATFORM_HOST/default/bin/cpp
	fi

	PLATFORM=$PLATFORM PLATFORM_HOST=$PLATFORM_HOST make || die make all

	echo "#!/bin/sh" > toolbox/dir2rpm.sh

	echo "#!/bin/sh" > toolbox/dir2deb.sh

	chmod +x toolbox/dir2rpm.sh toolbox/dir2deb.sh

	mkdir -p "somidl/$PLATFORM"

	touch "somidl/$PLATFORM/somobj.h"

	for d in somdobj somdcprx orb somoa boa nvlist om cntxt impldef implrep principl request servmgr somdom somdtype stexcep unotypes somproxy omgestio xmscssae somdserv naming lname xnaming xnamingf lnamec biter somos somddsrv somestio repostry containd containr intfacdf operatdf moduledf paramdef somref typedef excptdef constdef attribdf somssock tcpsock workprev timerev somsid eman sinkev clientev emregdat event snglicls somida omgidobj somcls somobj somcm
	do
		touch "somidl/$d.idl"
	done

	for d in somdsvr somdchk somossvr
	do
		touch "products/$PLATFORM/default/bin/$d"
	done

	for d in somnew.ir
	do
		touch "products/$PLATFORM/default/etc/$d"
	done

	make dist || die make dist
}

src_install() {
	OUTDIR=$(find somtkpkg/*/default -type d -name somtk.comp)

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
