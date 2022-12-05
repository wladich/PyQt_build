define help
Available targets:
	help
	test
	clean
endef
export help


help:
	@echo "$$help"

test:
	./run_test_in_docker.sh

clean:
	rm -rf dist