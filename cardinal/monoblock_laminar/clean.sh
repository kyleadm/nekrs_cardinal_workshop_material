#!/bin/bash

if [[ "$1" == "deep" ]]; then
    echo "Performing deep clean..."
    rm -r .cache *.nek5000 *0.f* *_out.e *_out_nek0.e *.log *.json *~
else
    echo "Performing clean..."
    rm -r *.nek5000 *0.f* *_out.e *_out_nek0.e log.run *.json *~
    if [[ -d .cache ]]; then
        echo "Warning: .cache directory still exists. Run './clean.sh deep' to remove it."
    fi
fi
