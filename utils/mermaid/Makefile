.PHONY: run __validate_FILE clean

run: __validate_FILE
	@docker run --rm -v "$(shell pwd):/data" -u "$(shell id -u):$(shell id -g)" \
	minlag/mermaid-cli:latest -i /data/$(FILE)

__validate_FILE:
ifndef FILE
	$(error FILE is not defined; you must specify FILE like $$ make run FILE=xxx.mmd)
endif

clean:
	@rm *.svg
