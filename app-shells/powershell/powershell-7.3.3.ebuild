# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="PowerShell is an automation and configuration management platform."
HOMEPAGE="https://github.com/PowerShell/PowerShell"
KEYWORDS="arm arm64 amd64"
SRC_URI="arm? ( https://github.com/PowerShell/PowerShell/releases/download/v7.3.3/powershell-7.3.3-linux-arm32.tar.gz )
arm64? ( https://github.com/PowerShell/PowerShell/releases/download/v7.3.3/powershell-7.3.3-linux-arm64.tar.gz )
amd64? ( https://github.com/PowerShell/PowerShell/releases/download/v7.3.3/powershell-7.3.3-linux-x64.tar.gz )"
S="$WORKDIR"
LICENSE="MIT"
SLOT="0"

pkg_pretend() {
	pwd || die pwd
}

src_compile() {
	pwd || die pwd
	ls -ld pwsh || die missing pwsh
}

src_test() {
	pwd || die pwd
	ls -ld pwsh || die missing pwsh
	./pwsh --version || die pwsh version
}

src_install() {
	pwd || die install
	ls -ld "$S" || die install
	ls -ld "pwsh" || die install
	install -d "$D/opt/microsoft/powershell/7"
	find * -type d | while read N
	do
		install -d "$D/opt/microsoft/powershell/7/$N" || die install "$N"
	done
	find * -type f | while read N
	do
		case "$N" in
			pwsh )
				install --mode=0555 "$N" "$D/opt/microsoft/powershell/7/$N" || die install "$N"
				;;
			* )
				install --mode=0444 "$N" "$D/opt/microsoft/powershell/7/$N" || die install "$N"
				;;
		esac
	done
	find * -type l | while read N
	do
		ln -s $(readlink "$N") "$D/opt/microsoft/powershell/7/$N" || die install "$N"
	done
	install -d "$D/usr/bin"
	ln -s "../../opt/microsoft/powershell/7/pwsh" "$D/usr/bin/pwsh" || install "usr/bin/pwsh"
}
