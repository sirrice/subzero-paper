BIBTEX=bibtex
LATEX=pdflatex

TARGET=main
all: $(TARGET)

override define __latex_code
#first passes for bbl/aux
	$(LATEX) $(LATEX_FLAGS) $< < /dev/null > /dev/null 2>&1 || true
	$(BIBTEX) $(TARGET) </dev/null || true
#and again; to get the citation order right
	$(LATEX) $(LATEX_FLAGS) $< < /dev/null > /dev/null 2>&1 || true
#and again; to make final version
	$(LATEX) $(LATEX_FLAGS) $< < /dev/null || (echo "LATEX CALL FAILED!!!"; exit 1)
endef


main: main.tex main.bib
	$(__latex_code)
	cp main.pdf ~/Dropbox/papers/mine/subzero.pdf
	pdftops main.pdf
	ps2pdf14 -dPDFSETTINGS=/prepress main.ps

clean:
	rm -f $(TARGETS) *.out *.log *.aux *~ *.pdf *.bbl
