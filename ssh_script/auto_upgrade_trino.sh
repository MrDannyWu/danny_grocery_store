#!/bin/sh
# auto upgrade trino version (centos version)
# for example: ./upgrade.sh 406 418

echo "old version $1 upgrade to new version $2 !"
echo "Start download trino-server-$2.tar.gz !"
wget -P /usr/local/ https://repo1.maven.org/maven2/io/trino/trino-server/$2/trino-server-$2.tar.gz
exch "trino-server-$2.tar.gz download complete !"

echo "Upgrading..."
cd /usr/local
tar -zxvf /usr/local/trino-server-$2.tar.gz -C /usr/local

# cd /usr/local/trino-server-$2/bin
# rm -f ./launcher
# cp ../../trino-server-$1/bin/launcher .

xsync /usr/local/trino-server-$2/

xcall cp -r /usr/local/trino-server-$1/etc/ /usr/local/trino-server-$2/
# xcall.sh cp -r /usr/local/trino-server-$1/plugin/paimon /usr/local/trino-server-$2/plugin/

xcall /usr/local/trino-server-$1/bin/launcher stop
xcall /usr/local/trino-server-$2/bin/launcher start

echo "Upgrade trino finished !"
