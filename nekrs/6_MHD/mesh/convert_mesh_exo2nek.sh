#!/bin/bash

exo2nek << EOF 2>&1 | tee log.exo2nek
1
fluid
1
solid
0
0
channel
EOF

mv channel.re2 ..