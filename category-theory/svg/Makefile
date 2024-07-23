../assets/%.svg: ../tex/%.pdf
	@ pdftocairo -svg $< $@

../tex/%.pdf: ../tex/%.tex
	@ cd $(@D); pdflatex $<
