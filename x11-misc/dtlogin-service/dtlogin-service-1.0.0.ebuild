# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The Common Desktop Environment, the classic UNIX desktop"
HOMEPAGE="https://sourceforge.net/projects/cdesktopenv/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="x86 amd64 arm arm64"

RDEPEND="sys-apps/systemd
	x11-misc/cdesktopenv"

src_unpack() 
{
	mkdir "$P"
	cat > "$P/dtlogin.service" <<EOF
[Unit]
Description=Common Desktop Environment Login Manager
Documentation=man:dtlogin(1)
Conflicts=getty@tty1.service
Requires=rpcbind.service
After=getty@tty1.service systemd-user-sessions.service plymouth-quit.service

[Service]
ExecStart=/usr/dt/bin/dtlogin -nodaemon

[Install]
Alias=display-manager.service
EOF
}

src_install() {
	install -d "$D/lib/systemd/system"
	install -m 0644 dtlogin.service "$D/lib/systemd/system"
}
