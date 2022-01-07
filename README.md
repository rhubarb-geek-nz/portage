# portage
Gentoo ebuild repository

The license refers to the ebuild files themselves, not the projects that they refer to.

Use this repository by

```
# eselect repository add rhubarb-geek-nz git https://github.com/rhubarb-geek-nz/portage.git
# git clone https://github.com/rhubarb-geek-nz/portage.git /var/db/repos/rhubarb-geek-nz
```

Remove using

```
# eselect repository remove -f rhubarb-geek-nz
```

Altenatively, in a Dockerfile

```
RUN mkdir /etc/portage/repos.conf && \
	echo $'# created by eselect-repo\n\
[rhubarb-geek-nz]\n\
location = /var/db/repos/rhubarb-geek-nz\n\
sync-type = git\n\
sync-uri = https://github.com/rhubarb-geek-nz/portage.git' >> /etc/portage/repos.conf/eselect-repo.conf && \
	git clone https://github.com/rhubarb-geek-nz/portage.git /var/db/repos/rhubarb-geek-nz
```
