#################################################################
## READLINE													##
#################################################################

READLINEVERSION := $(shell cat $(SOURCES) | jq -r '.readline.version' )
READLINEARCHIVE := $(shell cat $(SOURCES) | jq -r '.readline.archive' )
READLINEURI     := $(shell cat $(SOURCES) | jq -r '.readline.uri' )


#################################################################
##                                                             ##
#################################################################

$(SOURCEDIR)/$(READLINEARCHIVE): $(SOURCEDIR)
	test -f $@ || $(DOWNLOADCMD) $@ $(READLINEURI) || rm -f $@


#################################################################
##                                                             ##
#################################################################

$(BUILDDIR)/readline: $(SOURCEDIR)/$(READLINEARCHIVE)
	@mkdir -p $(BUILDDIR) && rm -rf $@-$(READLINEVERSION)
	@tar -xzf $(SOURCEDIR)/$(READLINEARCHIVE) -C $(BUILDDIR)
	@cd $@-$(READLINEVERSION)			&& \
	$(BUILDENV)							\
		./configure						\
			--host=$(TARGET)			\
			--prefix=$(PREFIXDIR)		\
			--disable-static			\
			--enable-shared				&& \
		make -j$(PROCS)					&& \
		make -j$(PROCS) install
	@rm -rf $@-$(READLINEVERSION)
	@touch $@


#################################################################
##                                                             ##
#################################################################
