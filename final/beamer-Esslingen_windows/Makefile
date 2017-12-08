examples = \
  example-beamer \
  example-handout \
  example-article

all: $(examples:%=%.pdf)

%.pdf: %.tex
	pdflatex $(@:%.pdf=%.tex)
	pdflatex $(@:%.pdf=%.tex)

clean:
	rm -f *.aux *.log *.nav *.out *.snm *.toc *.vrb
