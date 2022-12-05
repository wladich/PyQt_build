define help
Available targets:
	help
	sources
	build sdist=<http://.../PyQt.tar.gz>
	test
	all (build + test)
	clean
endef
export help


help:
	@echo "$$help"

test:
	./run_test_in_docker.sh

build: clean
	SDIST_URL="$(sdist)" ./build_pyqt.sh

all: build test

sources:
	@curl --silent https://pypi.org/simple/pyqt5/ | sed -rn 's/.*href="([^"]+).*/\1/g p' | grep --fixed-strings '.tar.gz'

clean:
	rm -rf dist
