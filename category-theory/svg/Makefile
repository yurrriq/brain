%.svg: ../tex/%.pdf
	@ pdf2svg $< $@

../tex/%.pdf: ../tex/%.tex
	@ cd $(@D); pdflatex $<
