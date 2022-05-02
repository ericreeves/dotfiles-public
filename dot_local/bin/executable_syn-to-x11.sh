#!/bin/bash
synclient  -l | awk '/=/{printf "Option \"%s\" \"%s\"\n",$1,$3}'
