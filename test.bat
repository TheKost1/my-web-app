#!/bin/bash
# test.sh - проверка, что сайт отвечает с кодом 200

response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:80)
if [ "$response" == "200" ]; then
    echo "Test passed"
    exit 0
else
    echo "Test failed"
    exit 1
fi