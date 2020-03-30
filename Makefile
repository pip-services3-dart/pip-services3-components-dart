.PHONY: test gendoc docview

test:
	@pub run test ./test

gendoc:
	@dartdoc --no-auto-include-dependencies --no-include-source --show-progress --output ./docs/

docview:
	@dhttpd --path docs
