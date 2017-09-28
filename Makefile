# Adapted from https://tex.stackexchange.com/questions/40738/

BUILDDIR = build
#AUXDIR   = aux

# You want latexmk to *always* run, because make does not have all the info.
# Also, include non-file targets in .PHONY so they are run regardless of any
# file of the given name existing.
.PHONY: thesis.pdf talk.pdf all clean

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.
all: thesis.pdf talk.pdf

# MAIN LATEXMK RULE

# -pdf tells latexmk to generate PDF directly (instead of DVI).
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.

# -interaction=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.

thesis.pdf: thesis.tex
	latexmk -pdf -output-directory=$(BUILDDIR) -pdflatex="pdflatex -interaction=nonstopmode" -use-make thesis.tex

talk.pdf: talk.tex
	latexmk -pdf -output-directory=$(BUILDDIR) -pdflatex="pdflatex -interaction=nonstopmode" -use-make talk.tex

clean:
	latexmk -CA -output-directory=$(BUILDDIR)
	rm -fr $(BUILDDIR)
