#!/bin/sh

# sorry, no makefile yet ... feel free to contribute it

CCOPTS="-DHAVE_CONFIG_H -I. -g -O2 `perl -MExtUtils::Embed -e ccopts` -rdynamic"
LDOPTS=`perl -MExtUtils::Embed -e ldopts`

rm -rf .libs > /dev/null
mkdir .libs > /dev/null
gcc $CCOPTS   -c -o .libs/perlfs.lo `test -f 'perlfs.c' || echo './'`perlfs.c

libtool --mode=link gcc $CCOPTS -o .libs/liblufs-perlfs.la $LDOPTS 

gcc -shared  .libs/perlfs.lo $LDOPTS -Wl,-soname -Wl,liblufs-perlfs.so.2 -o .libs/liblufs-perlfs.so.2.0.0

cp .libs/liblufs-perlfs.so.2.0.0 /usr/local/lib/
ldconfig
cc -o .libs/auto.perlfs auto.perlfs.c
cp .libs/auto.perlfs /etc

if grep -q perlfs /etc/auto.master ; then echo "perlfs already in /etc/auto.master"; else echo "adding perlfs to /etc/auto.master";echo "/mnt/perl /etc/auto.perlfs --timeout=300" >> /etc/auto.master; fi
