# cd /tmp
# wget https://www.python.org/ftp/python/3.9.18/Python-3.9.18.tgz
# tar -xzf Python-3.9.18.tgz
# cd Python-3.9.18
#
# ./configure --enable-optimizations --prefix=/usr/local
# make -j$(nproc)
# make install

#!/bin/bash
# Скрипт: install_python.sh
# Назначение: скачать готовый бинарный Python 3 и сделать его доступным как python3

# Версия Python
PYTHON_VERSION="3.11.8"
PYTHON_URL="https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz"
INSTALL_DIR="/usr/local/python3"

echo "=== Создаём директорию для Python ==="
mkdir -p $INSTALL_DIR

echo "=== Скачиваем Python $PYTHON_VERSION ==="
wget -q $PYTHON_URL -O /tmp/python3.tgz

echo "=== Распаковываем ==="
tar -xzf /tmp/python3.tgz -C $INSTALL_DIR --strip-components=1

echo "=== Проверка Python ==="
$INSTALL_DIR/python3 --version

echo "=== Создаём символическую ссылку ==="
ln -sf $INSTALL_DIR/python3 /usr/local/bin/python3
ln -sf $INSTALL_DIR/python3 /usr/local/bin/python

echo "✅ Python 3 установлен и доступен через python3 и python"

