.PHONY: run __validate_FILE runserver clean

run: __validate_FILE
	@docker run --rm -v "$(shell pwd):/data" -u "$(shell id -u):$(shell id -g)" \
	plantuml/plantuml:latest -tpng /data/$(FILE)

__validate_FILE:
ifndef FILE
	$(error FILE is not defined; you must specify FILE like $$ make run FILE=xxx.pu)
endif

runserver:
	@docker run -d -p 8080:8080 --name plantuml-server plantuml/plantuml-server:jetty > /dev/null

stopserver:
	@docker stop plantuml-server > /dev/null
	@docker container rm plantuml-server > /dev/null

clean:
	@rm *.png
	@rm -rf \?
