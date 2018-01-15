#!/usr/bin/bash
#_*_coding=utf-8_*_


PART1=RT01-Real-Time-Environment.tex.pdf


function convert_to_false()
{
	sed -i 's/overviewtrue/overviewfalse/' realtimesystems-beamer.tex
	input="IIIIIIIIII"
	for iterator in `seq 1 10`; do
		sed -i 's/part${input:0:$iterator}true/part${input:0:$iterator}false/' realtimesystems-beamer.tex
	done
}

convert_to_false

function convert_overview()
{
	sed -i 's/overviewfalse/overviewtrue/' realtimesystems-beamer.tex
	xelatex -interaction=nonstopmode -synctex=1 realtimesystems-beamer.tex
	mv realtimesystems-beamer.pdf convert/RT00-Introduction.tex.pdf
}

function convert_parts()
{
	sed -i 's/partIfalse/partItrue/' realtimesystems-beamer.tex
	xelatex -interaction=nonstopmode -synctex=1 realtimesystems-beamer.tex
	mv realtimesystems-beamer.pdf convert/$PART1
}

