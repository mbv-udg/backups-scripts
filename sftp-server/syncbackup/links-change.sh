#!/bin/bash

if [[ $1 -gt 3 ]]; then
    rm -rf "${2}/monthly"
    ln -s "${3}" "${2}/monthly"
fi

if [[ $1 -gt 2 ]]; then
    rm -rf "${2}/weekly"
    ln -s "${3}" "${2}/weekly"
fi

if [[ $1 -gt 1 ]]; then
    rm -rf "${2}/daily"
    ln -s "${3}" "${2}/daily"
fi

rm -rf "${2}/hourly"
ln -s "${3}" "${2}/hourly"

