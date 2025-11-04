sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list
sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list
sed -i '/stretch-updates/d' /etc/apt/sources.list
echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99ignore-valid-until

