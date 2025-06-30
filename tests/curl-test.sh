#!/bin/bash
curl -X POST http://localhost:5000/alert \
     -H "Content-Type: application/json" \
     -d '{"alert": "Test alert from curl-test.sh"}'
