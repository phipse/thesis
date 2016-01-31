#!/bin/bash

fn=$1_fix

ruby parse_formate.rb $1 $fn
ruby calc.rb $fn
tex=${fn}_plot.tex
xelatex -output-directory=./pdf $tex
