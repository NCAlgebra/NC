#!/bin/bash

find "$1/$2" -type f -name "*.m" -exec sed -i "s/Get\[\"\([^\.]*.usage\)\"/Get[\"NCAlgebra\/$2\/\1\"/" {} +
