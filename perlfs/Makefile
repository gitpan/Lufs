LIBDIR=/usr/local/lib

EE=$(shell perl -MExtUtils::Embed -e ccopts)
CCOPTS=-DHAVE_CONFIG_H -I. -g -O2 $(EE) -rdynamic
LDOPTS=`perl -MExtUtils::Embed -e ldopts`
all: perlfs.lo auto.perlfs
perlfs.lo: perlfs.c perlfs.h
	gcc $(CCOPTS) -c -o perlfs.lo perlfs.c
	libtool --mode=link gcc $(CCOPTS) -o liblufs-perlfs.la $(LDOPTS)
	gcc -shared perlfs.lo $(LDOPTS) -Wl,-soname -Wl,liblufs-perlfs.so.2 -o liblufs-perlfs.so.2.0.0
auto.perlfs: auto.perlfs.c
clean:
	rm -f perlfs.lo auto.perlfs liblufs-perlfs.so.2.0.0 liblufs-perlfs.la
install: install_lib install_autofs
install_lib:
	install -m 644 liblufs-perlfs.so.2.0.0 $(LIBDIR)
	[[ -e $(LIBDIR)/liblufs-perlfs.so ]] || ln -s $(LIBDIR)/liblufs-perlfs.so.2.0.0 $(LIBDIR)/liblufs-perlfs.so
	ldconfig
install_autofs:
	if grep -q perlfs /etc/auto.master ; then echo "perlfs already in /etc/auto.master";else echo "adding perlfs to /etc/auto.master";echo "/mnt/perl /etc/auto.perlfs --timeout=300" >> /etc/auto.master; fi
	install auto.perlfs /etc/
