#
# Makefile for the NIS databases
#
# This Makefile should only be run on the NIS master server of a domain.
# All updated maps will be pushed to all NIS slave servers listed in the
# /var/yp/ypservers file. Please make sure that the hostnames of all
# NIS servers in your domain are listed in /var/yp/ypservers.
#
# This Makefile can be modified to support more NIS maps if desired.
#

# Set the following variable to "-b" to have NIS servers use the domain
# name resolver for hosts not in the current domain. This is only needed,
# if you have SunOS slave YP server, which gets here maps from this
# server. The NYS YP server will ignore the YP_INTERDOMAIN key.
#B=-b
B=

# If we have only one server, we don't have to push the maps to the
# slave servers (NOPUSH=true). If you have slave servers, change this
# to "NOPUSH=false" and put all hostnames of your slave servers in the file
# /var/yp/ypservers.
NOPUSH=true

# We do not put password entries with lower UIDs (the root and system
# entries) in the NIS password database, for security. MINUID is the
# lowest uid that will be included in the password maps. If you
# create shadow maps, the UserID for a shadow entry is taken from
# the passwd file. If no entry is found, this shadow entry is
# ignored.
# MINGID is the lowest gid that will be included in the group maps.
MINUID=500
MINGID=500

# Should we merge the passwd file with the shadow file ?
# MERGE_PASSWD=true|false
MERGE_PASSWD=true

# Should we merge the group file with the gshadow file ?
# We don't support /etc/gshadow anymore, so we don't can merge it.
# MERGE_GROUP=true|false
MERGE_GROUP=false

# These are commands which this Makefile needs to properly rebuild the
# NIS databases. Don't change these unless you have a good reason.
AWK = /usr/bin/gawk
MAKE = /usr/bin/gmake
UMASK = umask 066

#
# These are the source directories for the NIS files; normally
# that is /etc but you may want to move the source for the password
# and group files to (for example) /var/yp/ypfiles. The directory
# for passwd, group and shadow is defined by YPPWDDIR, the rest is
# taken from YPSRCDIR.
#
YPSRCDIR = /etc
YPPWDDIR = $(shell . /etc/sysconfig/ypserv; echo $$YPPWD_SRCDIR)
YPBINDIR = /usr/lib/yp
YPSBINDIR = /usr/sbin
YPDIR = /var/yp
YPMAPDIR = $(YPDIR)/$(DOMAIN)

# These are the files from which the NIS databases are built. You may edit
# these to taste in the event that you wish to keep your NIS source files
# seperate from your NIS server's actual configuration files.
#
GROUP       = $(YPPWDDIR)/group
PASSWD      = $(YPPWDDIR)/passwd
SHADOW	    = $(YPPWDDIR)/shadow
GSHADOW     = $(YPPWDDIR)/gshadow
ADJUNCT     = $(YPPWDDIR)/passwd.adjunct
#ALIASES     = $(YPSRCDIR)/aliases  # aliases could be in /etc or /etc/mail
ALIASES     = /etc/aliases
ETHERS      = $(YPSRCDIR)/ethers     # ethernet addresses (for rarpd)
BOOTPARAMS  = $(YPSRCDIR)/bootparams # for booting Sun boxes (bootparamd)
HOSTS       = $(YPSRCDIR)/hosts
NETWORKS    = $(YPSRCDIR)/networks
PRINTCAP    = $(YPSRCDIR)/printcap
PROTOCOLS   = $(YPSRCDIR)/protocols
PUBLICKEYS  = $(YPSRCDIR)/publickey
RPC 	    = $(YPSRCDIR)/rpc
SERVICES    = $(YPSRCDIR)/services
NETGROUP    = $(YPSRCDIR)/netgroup
NETID	    = $(YPSRCDIR)/netid
AMD_HOME    = $(YPSRCDIR)/amd.home
AUTO_MASTER = $(YPSRCDIR)/auto.master
AUTO_HOME   = $(YPSRCDIR)/auto.home
AUTO_LOCAL  = $(YPSRCDIR)/auto.local
TIMEZONE    = $(YPSRCDIR)/timezone
LOCALE      = $(YPSRCDIR)/locale
NETMASKS    = $(YPSRCDIR)/netmasks

YPSERVERS = $(YPDIR)/ypservers	# List of all NIS servers for a domain

target: Makefile
	@test ! -d $(LOCALDOMAIN) && mkdir $(LOCALDOMAIN) ; \
	cd $(LOCALDOMAIN)  ; \
	$(NOPUSH) || $(MAKE) -f ../Makefile ypservers; \
	$(MAKE) -f ../Makefile all

# If you don't want some of these maps built, feel free to comment
# them out from this list.

#all:  passwd group hosts rpc services netid protocols netgrp mail \
#	shadow publickey # networks ethers bootparams printcap \
	# amd.home auto.master auto.home auto.local passwd.adjunct \
	# timezone locale netmasks
all: group hosts netid passwd rpc services


########################################################################
#                                                                      #
#  DON'T EDIT ANYTHING BELOW IF YOU DON'T KNOW WHAT YOU ARE DOING !!!  #
#                                                                      #
########################################################################

DBLOAD = $(YPBINDIR)/makedbm -c -m `$(YPBINDIR)/yphelper --hostname`
MKNETID = $(YPBINDIR)/mknetid
YPPUSH = $(YPSBINDIR)/yppush
MERGER = $(YPBINDIR)/yphelper
DOMAIN = `basename \`pwd\``
LOCALDOMAIN = `/bin/domainname`
REVNETGROUP = $(YPBINDIR)/revnetgroup
CREATE_PRINTCAP = $(YPBINDIR)/create_printcap

ethers:	   	ethers.byname ethers.byaddr
hosts:	   	hosts.byname hosts.byaddr
networks:  	networks.byaddr networks.byname
protocols: 	protocols.bynumber protocols.byname
rpc:	   	rpc.byname rpc.bynumber
services:  	services.byname services.byservicename
passwd:    	passwd.byname passwd.byuid
group:     	group.byname group.bygid
shadow:	   	shadow.byname
passwd.adjunct:	passwd.adjunct.byname
netid:	   	netid.byname
netgrp:	   	netgroup netgroup.byhost netgroup.byuser
publickey: 	publickey.byname
mail:	   	mail.aliases
timezone:      timezone.byname
locale:                locale.byname
netmasks:      netmasks.byaddr

ypservers: $(YPSERVERS) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if ($$1 != "" && $$1 !~ "#") print $$0"\t"$$0 }' \
	    $(YPSERVERS) | $(DBLOAD) -i $(YPSERVERS) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@

$(YPSERVERS):
	@echo -n "Generating $*..."
	@uname -n > $(YPSERVERS)

bootparams: $(BOOTPARAMS) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if ($$1 != "" && $$1 !~ "#" && $$1 != "+") \
		print $$0 }' $(BOOTPARAMS) | $(DBLOAD) -r -i $(BOOTPARAMS) \
		 -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


ethers.byname: $(ETHERS) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if ($$1 != "" && $$1 !~ "#" && $$1 != "+") \
		print $$2"\t"$$0 }' $(ETHERS) | $(DBLOAD) -r -i $(ETHERS) \
						-o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


ethers.byaddr: $(ETHERS) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if ($$1 != "" && $$1 !~ "#" && $$1 != "+") \
		print $$1"\t"$$0 }' $(ETHERS) | $(DBLOAD) -r -i $(ETHERS) \
						-o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


netgroup: $(NETGROUP) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if ($$1 != "" && $$1 !~ "#" && $$1 != "+") \
		print $$0 }' $(NETGROUP) | $(DBLOAD) -i $(NETGROUP) \
		 -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


netgroup.byhost: $(NETGROUP) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(REVNETGROUP) -h < $(NETGROUP) | $(DBLOAD) -i $(NETGROUP) \
		-o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


netgroup.byuser: $(NETGROUP) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(REVNETGROUP) -u < $(NETGROUP) | $(DBLOAD) -i $(NETGROUP) \
		-o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


hosts.byname: $(HOSTS) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '/^[0-9]/ { for (n=2; n<=NF && $$n !~ "#"; n++) \
		print $$n"\t"$$0 }' $(HOSTS) | $(DBLOAD) -r $(B) -l \
			-i $(HOSTS) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@

hosts.byaddr: $(HOSTS) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if ($$1 !~ "#" && $$1 != "") print $$1"\t"$$0 }' \
	   $(HOSTS) | $(DBLOAD) -r $(B) -i $(HOSTS) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


networks.byname: $(NETWORKS) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if($$1 !~ "#" && $$1 != "") { print $$1"\t"$$0; \
		 for (n=3; n<=NF && $$n !~ "#"; n++) print $$n"\t"$$0 \
			}}' $(NETWORKS) | $(DBLOAD) -r -i $(NETWORKS) \
			 -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


networks.byaddr: $(NETWORKS) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if ($$1 !~ "#" && $$1 != "") print $$2"\t"$$0 }' \
		 $(NETWORKS) | $(DBLOAD) -r -i $(NETWORKS) \
		 -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


protocols.byname: $(PROTOCOLS) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if ($$1 !~ "#" && $$1 != "") { print $$1"\t"$$0; \
		for (n=3; n<=NF && $$n !~ "#"; n++) \
		print $$n"\t"$$0}}' $(PROTOCOLS) | $(DBLOAD) -r -i \
			$(PROTOCOLS) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


protocols.bynumber: $(PROTOCOLS) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if ($$1 !~ "#" && $$1 != "") print $$2"\t"$$0 }' \
		$(PROTOCOLS) | $(DBLOAD) -r -i $(PROTOCOLS) \
		 -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


rpc.byname: $(RPC) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if ($$1 !~ "#"  && $$1 != "") { print $$1"\t"$$0; \
		for (n=3; n<=NF && $$n !~ "#"; n++)  print $$n"\t"$$0 \
		  }}' $(RPC) | $(DBLOAD) -r -i $(RPC) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


rpc.bynumber: $(RPC) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if ($$1 !~ "#" && $$1 != "") print $$2"\t"$$0 }' $(RPC) \
		| $(DBLOAD) -r -i $(RPC) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


services.byname: $(SERVICES) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if ($$1 !~ "#" && $$1 != "") print $$2"\t"$$0 }' \
		$(SERVICES) | $(DBLOAD) -r -i $(SERVICES) \
		-o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@

services.byservicename: $(SERVICES) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if ($$1 !~ "#" && $$1 != "") { \
		split($$2,A,"/") ; TMP = "/" A[2] ; \
		print $$1 TMP"\t"$$0 ; \
		if (! seen[$$1]) { seen[$$1] = 1 ; print $$1"\t"$$0 ; } \
		for (N = 3; N <= NF && $$N !~ "#" ; N++) { \
			if ($$N !~ "#" && $$N != "") print $$N TMP"\t"$$0 ; \
			if (! seen[$$N]) { seen[$$N] = 1 ; print $$N"\t"$$0 ; } \
		} } } ' \
		$(SERVICES) | $(DBLOAD) -r -i $(SERVICES) \
		-o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


ifeq (x$(MERGE_PASSWD),xtrue)
passwd.byname: $(PASSWD) $(SHADOW) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(UMASK); \
	$(MERGER) -p $(PASSWD) $(SHADOW) | \
	   $(AWK) -F: '!/^[-+#]/ { if ($$1 != "" && $$3 >= $(MINUID) ) \
	   print $$1"\t"$$0 }' | $(DBLOAD) -i $(PASSWD) \
		-o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@

passwd.byuid: $(PASSWD) $(SHADOW) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(UMASK); \
	$(MERGER) -p $(PASSWD) $(SHADOW) | \
	   $(AWK) -F: '!/^[-+#]/ { if ($$1 != "" && $$3 >= $(MINUID) ) \
	   print $$3"\t"$$0 }' | $(DBLOAD) -i $(PASSWD) \
		 -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@

# Don't build a shadow map !
shadow.byname:
	@echo "Updating $@... Ignored -> merged with passwd"

else

passwd.byname: $(PASSWD) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(UMASK); \
	$(AWK) -F: '!/^[-+#]/ { if ($$1 != "" && $$3 >= $(MINUID) ) \
	   print $$1"\t"$$0 }' $(PASSWD) | $(DBLOAD) -i $(PASSWD) \
		-o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@

passwd.byuid: $(PASSWD) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(UMASK); \
	$(AWK) -F: '!/^[-+#]/ { if ($$1 != "" && $$3 >= $(MINUID) ) \
	   print $$3"\t"$$0 }' $(PASSWD) | $(DBLOAD) -i $(PASSWD) \
		 -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@

shadow.byname: $(SHADOW) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(UMASK); \
	$(AWK) -F: '{ if (FILENAME ~ /shadow$$/) { \
		if (UID[$$1] >= $(MINUID) ) print $$1"\t"$$0; \
			} else UID[$$1] = $$3; }' $(PASSWD) $(SHADOW) \
		| $(DBLOAD) -s -i $(SHADOW) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@
endif

passwd.adjunct.byname: $(ADJUNCT) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(UMASK); \
	$(AWK) -F: '!/^[-+#]/ { if ($$1 != "" ) print $$1"\t"$$0 }' \
		$(ADJUNCT) | $(DBLOAD) -s -i $(ADJUNCT) -o $(YPMAPDIR)/$@ - $@
	@chmod 700 $(YPDIR)/$(DOMAIN)/$@*
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@

ifeq (x$(MERGE_GROUP),xtrue)
group.byname: $(GROUP) $(GSHADOW) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(UMASK); \
	$(MERGER) -g $(GROUP) $(GSHADOW) | \
	$(AWK) -F: '!/^[-+#]/ { if ($$1 != "" && $$3 >= $(MINGID) ) \
	print $$1"\t"$$0 }' | $(DBLOAD) -i $(GROUP) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@

group.bygid: $(GROUP) $(GSHADOW) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(UMASK); \
	$(MERGER) -g $(GROUP) $(GSHADOW) | \
	$(AWK) -F: '!/^[-+#]/ { if ($$1 != "" && $$3 >= $(MINGID) ) \
	print $$3"\t"$$0 }' | $(DBLOAD) -i $(GROUP) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@

else

group.byname: $(GROUP) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(UMASK); \
	$(AWK) -F: '!/^[-+#]/ { if ($$1 != "" && $$3 >= $(MINGID) ) \
					print $$1"\t"$$0 }' $(GROUP) \
		| $(DBLOAD) -i $(GROUP) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@

group.bygid: $(GROUP) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(UMASK); \
	$(AWK) -F: '!/^[-+#]/ { if ($$1 != "" && $$3 >= $(MINGID) ) \
					print $$3"\t"$$0 }' $(GROUP) \
		| $(DBLOAD) -i $(GROUP) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@
endif

$(NETID):
netid.byname: $(GROUP) $(PASSWD) $(HOSTS) $(NETID) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(MKNETID) -q -p $(PASSWD) -g $(GROUP) -h $(HOSTS) -d $(DOMAIN) \
		-n $(NETID) | $(DBLOAD) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


mail.aliases: $(ALIASES) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ \
			if ($$1 ~ "^#.*") \
				next; \
			if ($$1 == "" || $$1 == "+") { \
				if (line != "") \
					{print line; line = "";} \
				next; \
			} \
			if ($$0 ~ /^[[:space:]]/) \
				line = line $$0; \
			else { \
				if (line != "") \
					{print line; line = "";} \
				line = $$0; \
			} \
		} \
		END {if (line != "") print line}' \
		$(ALIASES) | $(DBLOAD) --aliases \
			-i $(ALIASES) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


publickey.byname: $(PUBLICKEYS) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if($$1 !~ "#" && $$1 != "") { print $$1"\t"$$2 }}' \
		$(PUBLICKEYS) | $(DBLOAD) -i $(PUBLICKEYS) \
		 -o $(YPMAPDIR)/$@ - $@
	@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


printcap: $(PRINTCAP) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(CREATE_PRINTCAP) < $(PRINTCAP) | \
		$(DBLOAD) -i $(PRINTCAP) -o $(YPMAPDIR)/$@ - $@
	@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


auto.master: $(AUTO_MASTER) $(YPDIR)/Makefile
	@echo "Updating $@..."
	-@sed -e "/^#/d" -e s/#.*$$// $(AUTO_MASTER) | $(DBLOAD) \
		-i $(AUTO_MASTER) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@

auto.home: $(AUTO_HOME) $(YPDIR)/Makefile
	@echo "Updating $@..."
	-@sed -e "/^#/d" -e s/#.*$$// $(AUTO_HOME) | $(DBLOAD) \
		-i $(AUTO_HOME) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


auto.local: $(AUTO_LOCAL) $(YPDIR)/Makefile
	@echo "Updating $@..."
	-@sed -e "/^#/d" -e s/#.*$$// $(AUTO_LOCAL) | $(DBLOAD) \
		-i $(AUTO_LOCAL) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


amd.home: $(AMD_HOME) $(YPDIR)/Makefile
	@echo "Updating $@..."
	-@sed -e "s/#.*$$//" -e "/^$$/d" $(AMD_HOME) | \
	$(AWK) '{\
		for (i = 1; i <= NF; i++)\
		   if (i == NF) { \
		      if (substr($$i, length($$i), 1) == "\\") \
	                   printf("%s", substr($$i, 1, length($$i) -1)); \
	               else \
			  printf("%s\n",$$i); \
	              } \
		   else \
		      printf("%s ",$$i);\
		}' | $(DBLOAD) -i $(AMD_HOME) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@

timezone.byname: $(TIMEZONE) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if ($$1 != "" && $$1 !~ "#") \
		print $$2"\t"$$0 }' $(TIMEZONE) | $(DBLOAD) \
			-r -i $(TIMEZONE) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


locale.byname: $(LOCALE) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if ($$1 != "" && $$1 !~ "#") \
	     print $$2"\t"$$0"\n"$$1"\t"$$2"\t"$$1 }' $(LOCALE) | $(DBLOAD) \
		-r -i $(LOCALE) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@


netmasks.byaddr: $(NETMASKS) $(YPDIR)/Makefile
	@echo "Updating $@..."
	@$(AWK) '{ if ($$1 != "" && $$1 !~ "#") \
		print $$1"\t"$$2 }' $(NETMASKS) | $(DBLOAD) \
			-r -i $(NETMASKS) -o $(YPMAPDIR)/$@ - $@
	-@$(NOPUSH) || $(YPPUSH) -d $(DOMAIN) $@
