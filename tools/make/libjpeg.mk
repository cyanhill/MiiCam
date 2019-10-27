#################################################################
## LIBJPEG-TURBO											   ##
#################################################################

LIBJPEGVERSION := $(shell cat $(SOURCES) | jq -r '.libjpeg.version' )
LIBJPEGARCHIVE := $(shell cat $(SOURCES) | jq -r '.libjpeg.archive' )
LIBJPEGURI     := $(shell cat $(SOURCES) | jq -r '.libjpeg.uri' )

#################################################################
##                                                             ##
#################################################################

$(SOURCEDIR)/$(LIBJPEGARCHIVE): $(SOURCEDIR)
	test -f $@ || $(DOWNLOADCMD) $@ $(LIBJPEGURI) || rm -f $@


#################################################################
##                                                             ##
#################################################################

$(BUILDDIR)/libjpeg-turbo: $(SOURCEDIR)/$(LIBJPEGARCHIVE)
	@mkdir -p $(BUILDDIR) && rm -rf $@-$(LIBJPEGVERSION)
	@tar -xzf $(SOURCEDIR)/$(LIBJPEGARCHIVE) -C $(BUILDDIR)
	@cd $@-$(LIBJPEGVERSION)		&& \
	$(BUILDENV)						\
		./configure					\
			--prefix=$(PREFIXDIR)	\
			--disable-static		\
			--enable-shared			\
			--host=$(TARGET)		&& \
		make -j$(PROCS)				&& \
		make -j$(PROCS) install
	@rm -rf $@-$(LIBJPEGVERSION)
	@touch $@


#################################################################
##                                                             ##
#################################################################
