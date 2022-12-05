#!/bin/bash

docker run --rm -ti -v $(pwd):/data:ro debian:11 bash -c '
set -e
apt-get update
apt-get install -y --no-install-recommends \
  python3 \
  python3-pip \
  python3-venv \
  libqt5core5a \
  libqt5network5 \
  libqt5gui5 \
  libqt5widgets5 \
  libqt5bluetooth5 \
  libqt5dbus5 \
  libqt5designer5 \
  libqt5help5 \
  libqt5multimedia5 \
  libqt5multimediawidgets5 \
  libqt5networkauth5 \
  libqt5nfc5 \
  libqt5opengl5 \
  libqt5positioning5 \
  libqt5location5 \
  libqt5printsupport5 \
  libqt5quick5 \
  libqt5quickwidgets5 \
  libqt5remoteobjects5 \
  libqt5sensors5 \
  libqt5serialport5 \
  libqt5svg5 \
  libqt5test5 \
  libqt5texttospeech5 \
  libqt5webchannel5 \
  libqt5webkit5 \
  libqt5websockets5 \
  libqt5x11extras5 \
  libqt5xml5 \
  libqt5xmlpatterns5
cd /data
python3 -m venv /tmp/venv
/tmp/venv/bin/pip install -r requirements_test.txt
/tmp/venv/bin/pip install dist/*.whl
/tmp/venv/bin/pytest -p no:cacheprovider -v
'