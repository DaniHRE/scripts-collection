#!/bin/bash

# Show memory use after script runs
echo "Memory after:"
free -h

# Sincronyze data for disk
sync

# Cleans page cache, dentries e inodes
echo 3 > /proc/sys/vm/drop_caches

# Mostrar uso de memória depois
echo "Memory before:"
free -h

echo "Memory cleaned successfully!"