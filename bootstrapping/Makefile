# example of Makefile for Scheme+ for Racket
# generic Makefile for all Scheme and Racket files
# author: Damien Mattei

# this Makefile parse all the Scheme+ file in the directory where the Makefile is.
# the resulting parsed scheme files are set in the subdirectory MODULE_DIRECTORY


SHELL := /bin/bash

# path to parser directory (relative to this bootstrapping directory)
#PARSER_DIRECTORY=SRFI-110-for-Racket
PARSER_DIRECTORY=..

# for MacOS:
#SCHEME_EXEC=/Applications/Racket\ v8.12/bin/racket
SCHEME_EXEC=racket


# Scheme+ for parser
#PARSER:=$(SCHEME_EXEC) $(SCHEME_PLUS)/src/curly-infix2prefix4racket.rkt
PARSER:=$(PARSER_DIRECTORY)/src/curly-infix2prefix4racket.rkt


# sub directory where parsed module files will be generated
MODULE_DIRECTORY=parsed_files_directory

INSTALL_DIRECTORY=..

# important: breaking the parser and you can not fix it because you're parser is broken unless you got a backup !
BACKUP_DIRECTORY=$(PARSER_DIRECTORY)/backup


# Scheme+ program to be parsed
MODULES_NAME=$(wildcard *+.rkt *+.scm)

# Scheme programs to create by parsing the Scheme+ files
OBJECT=$(addprefix $(MODULE_DIRECTORY)/,$(MODULES_NAME))




# create directory, build objects
# note: parsed files have the same name than source files but are in different directories
all: $(MODULE_DIRECTORY) $(OBJECT)


# create the sub directory where parsed module files will be
$(MODULE_DIRECTORY) :
	mkdir $@

# create Scheme files (*.scm , *+.scm , *-.scm)  by parsing Scheme+ files (*+.scm)
# if an error occur and the file is empty it will stop further Makefile call so i remove it:

.DELETE_ON_ERROR:

# create Scheme files (*.scm) by parsing Scheme+ files (*+.scm)
$(MODULE_DIRECTORY)/%+.scm: %+.scm
	@echo PARSING $< :
	$(SCHEME_EXEC) $(PARSER) $< > $@

# create Scheme files (*.rkt) by parsing Scheme+ files (*+.rkt)
$(MODULE_DIRECTORY)/%+.rkt: %+.rkt
	@echo PARSING $< :
	$(SCHEME_EXEC) $(PARSER) $< > $@

backup:
	@echo "Backing up parsed files in $(BACKUP_DIRECTORY) :"
	mkdir -p $(BACKUP_DIRECTORY)
	cp $(INSTALL_DIRECTORY)/main.rkt $(BACKUP_DIRECTORY)
	cp $(INSTALL_DIRECTORY)/kernel.rkt $(BACKUP_DIRECTORY)
	cp $(INSTALL_DIRECTORY)/src/curly-infix2prefix4racket.rkt $(BACKUP_DIRECTORY)
	@echo "Done."

install:
	@echo "Installing parsed files in $(INSTALL_DIRECTORY) :"
# old line : the files kept their names (main+.rkt went in ../main+.rkt and not in the active reader ../main.rkt)
# and the sub-directory compiled made cp fail
#	cp $(MODULE_DIRECTORY)/* $(INSTALL_DIRECTORY)
	cp $(MODULE_DIRECTORY)/main+.rkt $(INSTALL_DIRECTORY)/main.rkt
	@echo "Done."

clean:
	rm -rf $(OBJECT)
	rm -rf $(MODULE_DIRECTORY)

