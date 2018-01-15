#!/usr/bin/bash
#_*_coding=utf-8_*_


PART1=RT01-Real-Time-Environment.tex.pdf


function convert_to_false()
{
	sed -i 's/overviewtrue/overviewfalse/' realtimesystems-beamer.tex
	for iterator in {1..10}; do #`seq 1 10`; do
		match="part${iterator}true"
		replace="part${iterator}false"
		sed -i "s/${match}/${replace}/" realtimesystems-beamer.tex
		#echo $command
		#$command
		done
}

function convert_overview()
{
	sed -i 's/overviewfalse/overviewtrue/' realtimesystems-beamer.tex
	rm realtimesystems-beamer.pdf
	xelatex -interaction=nonstopmode -synctex=1 realtimesystems-beamer.tex
	mv realtimesystems-beamer.pdf convert/RT00-Introduction.tex.pdf
}

function convert_parts()
{
	sed -i "s/part1false/part1true/" realtimesystems-beamer.tex
	rm realtimesystems-beamer.pdf
	xelatex -interaction=nonstopmode -synctex=1 realtimesystems-beamer.tex
	mv realtimesystems-beamer.pdf final-pdfs/$PART1
}

convert_to_false
read -p "Enter to continue"
convert_overview
read -p "Enter to continue"
convert_parts

