all:
	pdflatex -shell-escape valais.19.els.tex

bib: all
	bibtex valais.19.els
	pdflatex -shell-escape valais.19.els.tex
	pdflatex -shell-escape valais.19.els.tex

view:
	zsh -c 'evince valais.19.els.pdf &!'
