CC		:= gcc
CFLAGS	:=
LDFLAGS	:= -fPIC -shared
INSTALL	:= install
DESTDIR	:= /
PREFIX	:= /usr
VENV    := venv


all: plugin

plugin: defer_simple.c
	$(CC) $(CFLAGS) $(LDFLAGS) -I. -c defer_simple.c
	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-install_name,defer_simple.so -o defer_simple.so defer_simple.o

install: plugin
	mkdir -p $(DESTDIR)$(PREFIX)/lib/openvpn/plugins/
	mkdir -p $(DESTDIR)/etc/openvpn/
	$(INSTALL) -m755 defer_simple.so $(DESTDIR)$(PREFIX)/lib/openvpn/plugins/
	$(INSTALL) -m755 okta_openvpn.py $(DESTDIR)$(PREFIX)/lib/openvpn/plugins/
	$(INSTALL) -m755 okta_pinset.py $(DESTDIR)$(PREFIX)/lib/openvpn/plugins/
	$(INSTALL) -m644 okta_openvpn.ini.inc $(DESTDIR)/etc/openvpn/okta_openvpn.ini

clean:
	rm -f *.o
	rm -f *.so
	rm -f *.pyc
	rm -rf __pycache__
	rm -rf $(VENV)


py:
	virtualenv $(VENV)
	$(VENV)/bin/pip install --upgrade pip pytest
	$(VENV)/bin/pip install -r requirements.txt
