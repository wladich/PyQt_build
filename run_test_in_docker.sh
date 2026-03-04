#!/bin/bash

docker run --rm -ti -v $(pwd):/data:ro debian:13 bash -c '
set -e
apt-get update
apt-get install -y --no-install-recommends \
  python3 \
  python3-pip \
  python3-venv \
  libglib2.0-0t64 \
  libdbus-1-3 \
  libgl1 \
  libgssapi-krb5-2 \
  libx11-6 \
  libpulse-mainloop-glib0 \
  libxcomposite1 \
  libxrender1 \
  libxslt1.1 \
  libgstreamer-plugins-base1.0-0

cd /data
python3 -m venv /tmp/venv
/tmp/venv/bin/pip install -r requirements_test.txt
/tmp/venv/bin/pip install dist/*.whl "pyqt5-sip<12.18"
/tmp/venv/bin/pytest -p no:cacheprovider -v
'