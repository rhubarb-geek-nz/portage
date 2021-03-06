# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="microSD JavaCard library"
HOMEPAGE="https://sourceforge.net/projects/rhbgtsdu/"
SRC_URI="https://sourceforge.net/projects/rhbgtsdu/files/src/rhbgtsdu-code-r24-trunk-jni.zip"
S="$WORKDIR/rhbgtsdu-code-r24-trunk-jni"
DEPEND="dev-libs/libGTSDUpi"
RDEPEND="$DEPEND"
BDEPEND="sys-devel/bc
	dev-lang/openjdk"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="x86 amd64 arm arm64"

src_compile() {
	mkdir -p bin
	cat > bin/svn <<EOF
#!/bin/sh -ex
echo Last Changed Rev: 24
EOF
	chmod +x bin/svn

	if test -z "$JAVA_HOME"
	then
		for d in /usr/lib*/jvm/openjdk*
		do
			if test -x "$d/bin/javac"
			then
				JAVA_HOME="$d"
			fi
		done
	fi

	echo "JAVA_HOME=$JAVA_HOME"

	PATH=$(pwd)/bin:$PATH make "JAVA_HOME=$JAVA_HOME" "STRIP=ls -ld" || die make all

	objdump -p librhbgtsdu.so | grep SONAME | grep librhbgtsdu.so.1.0.24 || die SONAME
}

src_install() {
	case "$ARCH" in
		*64 )
			BASEDIR=usr/lib64/rhbgtsdu/lib
			;;
		* )
			BASEDIR=usr/lib/rhbgtsdu/lib
			;;
	esac

	install -d "$D/$BASEDIR" || die create install
	install lib*.so *.jar "$D/$BASEDIR" || die install libs
}
