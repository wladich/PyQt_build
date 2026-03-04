#!/bin/bash
set -e

# list of source packages:
# curl --silent https://pypi.org/simple/pyqt5/ | sed -rn 's/.*href="([^"]+).*/\1/g p' | grep --fixed-strings '.tar.gz'
SDIST_URL="https://files.pythonhosted.org/packages/28/6c/640e3f5c734c296a7193079a86842a789edb7988dca39eab44579088a1d1/PyQt5-5.15.2.tar.gz#sha256=372b08dc9321d1201e4690182697c5e7ffb2e0770e6b4a45519025134b12e4fc"

mkdir dist
docker run --rm -ti -v "$(pwd)"/dist:/dist -v "$(dirname $0)":/src:ro -e SDIST_URL debian:11 bash -c '
  set -ex
  set -o pipefail

  cat /etc/apt/sources.list | grep -v "#" | sed 's/^deb/deb-src/' > /etc/apt/sources.list.d/debian-sources.list
  apt-get update
  apt-get dist-upgrade -y
  apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    python3 \
    python3-venv\
    p7zip \
    patch
  apt-get build-dep -y pyqt5 --no-install-recommends

  mkdir /qt
  cd /qt
  wget -i /src/binaries_urls.txt --no-clobber
  for f in *.7z; do 7zr x $f; done
  wget https://github.com/qtwebkit/qtwebkit/releases/download/qtwebkit-5.212.0-alpha4/qtwebkit-Linux-RHEL_7_6-GCC-Linux-RHEL_7_6-X86_64.7z
  7zr x -o5.15.2/gcc_64 qtwebkit-Linux-RHEL_7_6-GCC-Linux-RHEL_7_6-X86_64.7z

  python3 -m venv /opt/sip
  /opt/sip/bin/pip install PyQt-builder==1.9.0 PyQt5-sip==12.11.0 sip==6.6.2
  patch /opt/sip/lib/python3.9/site-packages/pyqtbuild/bundle/packages/pyqt5.py /src/pyqtbuild_bundle_packages_pyqt5.py.patch

  mkdir /build
  cd /build
  wget "$SDIST_URL"
  tar xaf *.tar*
  rm *.tar*
  cd PyQt*
  /opt/sip/bin/sip-wheel --confirm-license --jobs $(nproc) --target-qt-dir Qt/lib --pep484-pyi
  mkdir bundled
  cd bundled
  /opt/sip/bin/pyqt-bundle --verbose --qt-dir /qt/5.15.2/gcc_64 ../*.whl
  mv *.whl /dist
'
