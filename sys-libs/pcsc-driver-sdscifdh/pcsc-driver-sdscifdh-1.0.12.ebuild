# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="microSD JavaCard library"
HOMEPAGE="https://sourceforge.net/projects/rhbgtsdu/"
SRC_URI="https://sourceforge.net/projects/rhbgtsdu/files/src/rhbgtsdu-code-r12-trunk-pcsclite.zip"
S="$WORKDIR/rhbgtsdu-code-r12-trunk-pcsclite"
DEPEND="dev-libs/libGTSDUpi
	 sys-apps/pcsc-lite"
RDEPEND="$DEPEND"
BDEPEND="bc"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="x86 amd64 arm arm64"

src_compile() {
	mkdir -p bin
	cat > bin/svn <<EOF
#!/bin/sh -ex
echo Last Changed Rev: 12
EOF
	chmod +x bin/svn

	PATH=$(pwd)/bin:$PATH make CFLAGS="-I/usr/include/PCSC -Wall" STRIP=strip || die make all
}

src_install() {
	DRIVERDIR=usr/lib/pcsc/drivers
	CONFDIR=etc/reader.conf.d

	for d in usr/lib64/pcsc/drivers/serial usr/lib/pcsc/drivers/serial usr/lib64/readers/serial usr/lib/readers/serial
	do
	if test -d "/$d"
		then
			DRIVERDIR="$d"
			break
		fi
	done

	test -n "$DRIVERDIR" || die driver directory not found
	test -d "/$CONFDIR" || die "/$CONFDIR" not found
	test -d "/$DRIVERDIR" || die "/$DRIVERDIR" not found

	mkdir -p "$D/$DRIVERDIR" "$D/$CONFDIR"

	cp lib*.so "$D/$DRIVERDIR/"
	cat > "$D/$CONFDIR/libsdscifdh" << EOF
DEVICENAME      /dev/SMART_IO.CRD
FRIENDLYNAME    "microSD JavaCard"
LIBPATH         /$DRIVERDIR/libsdscifdh.so
EOF
}
