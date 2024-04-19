.PHONY: convert __validate_FILE open clean

REPO := email-outlook-message-perl
REPO_URL := https://github.com/mvz/$(REPO).git
MSGCONVERT := $(REPO)/script/msgconvert
MBOX_FILE := outlook-mbox

convert: __validate_FILE
	@if [ ! -d "$(REPO)" ] ; then git clone "$(REPO_URL)" ; fi
	@$(MSGCONVERT) --mbox $(MBOX_FILE) *.msg

__validate_FILE:
ifndef FILE
	$(error FILE is not defined; you must specify FILE like $$ make run FILE=*.msg)
endif

open:
	@mutt -f $(MBOX_FILE)

clean:
	@rm $(MBOX_FILE)
	@rm -rf $(REPO)
