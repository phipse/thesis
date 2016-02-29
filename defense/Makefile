PDF = ./defense.pdf
PDF += ../images/system_layout_with_loadBalancer.pdf

TEX = ./defense.tex
TEX += ../images/system_layout_with_loadBalancer.tex


all : $(PDF) Makefile

%.pdf : %.tex
	xelatex -shell-escape $<
	xelatex -shell-escape $<
#	biber defense
#	xelatex -shell-escape $<

clean :
	$(RM) *.log *.aux *.out *.blg *.bbl *.snm *.nav *.toc *.vrb
