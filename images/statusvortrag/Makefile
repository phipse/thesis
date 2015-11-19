PDF = ./statusvortrag.pdf
PDF_IMG = ./scheduling_curr.pdf ./scheduling_curr_rq.pdf \
	./scheduling_curr_fiasco.pdf ./scheduling_curr_bal_time.pdf \
	./scheduling_curr_bal_cache.pdf ./placementGenerator_inside.pdf \
	./arch_interval_cycle.pdf

TEX = ./statusvortrag.tex
TEX += ./scheduling_curr.tex
TEX += ./scheduling_curr_fiasco.tex
TEX += ./scheduling_curr_rq.tex
TEX += ./scheduling_curr_bal_time.tex
TEX += ./placementGenerator_inside.tex
TEX += ./arch_interval_cycle.tex


all : $(PDF_IMG) $(PDF) Makefile

%.pdf : %.tex
	xelatex -shell-escape $<
	xelatex -shell-escape $<

clean :
	$(RM) *.log *.aux *.out *.blg *.bbl *.snm *.nav *.toc *.vrb
