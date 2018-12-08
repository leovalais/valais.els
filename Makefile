all: els19 bib

bib: bib19

els19:
	pdflatex -shell-escape valais.19.els.tex

bib19: els19
	bibtex valais.19.els
	pdflatex -shell-escape valais.19.els.tex
	pdflatex -shell-escape valais.19.els.tex

view:
	zsh -c 'evince valais.19.els.pdf &!'

clean:
	$(RM) *.aux *.bbl *.blg *.log *.out *.pdf *.pyg
	$(RM) -r _minted-valais.19.els
	$(RM) -r auto assets/19/auto
