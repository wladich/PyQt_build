#!/bin/bash

set -e

if [ -z "$SDIST_URL" ]; then
  echo SDIST_URL not set > /dev/stderr
  exit 1
fi

mkdir dist
docker run --rm -ti -v "$(pwd)"/dist:/dist -e SDIST_URL debian:11 bash -c '
  set -ex

  cat /etc/apt/sources.list | grep -v "#" | sed 's/^deb/deb-src/' > /etc/apt/sources.list.d/debian-sources.list
  apt-get update
  apt-get dist-upgrade -y
  apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    python3 \
    python3-venv
  apt-get build-dep -y pyqt5 --no-install-recommends

  python3 -m venv /opt/sip
  /opt/sip/bin/pip install PyQt-builder==1.13.0 PyQt5-sip==12.11.0 sip==6.6.2

  mkdir /build
  cd /build
  wget "$SDIST_URL"
  tar xaf *.tar*
  rm *.tar*
  cd PyQt*
  /opt/sip/bin/sip-wheel --confirm-license --jobs $(nproc)

  mv *.whl /dist
'
