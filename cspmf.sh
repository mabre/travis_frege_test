#!/bin/bash

java -Xss16m -Xmx2g -cp dist:dist/frege.jar frege.main.Main "$@"
