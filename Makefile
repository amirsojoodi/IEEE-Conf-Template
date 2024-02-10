MAIN=main
OUT_DIR=Out

# Small cheat to allow synchronization between PDF and .tex for supported editors (run `make S=1`)
ifdef S
EXTRA = -synctex=1 -outdir=$(OUT_DIR) -output-directory=$(OUT_DIR)
else
endif

PYTHON3 := $(shell type -P python3 || echo "")

ifeq ($(PYTHON3),)
BUILD = pdflatex ${EXTRA} $< && (ls *.aux | xargs -n 1 bibtex) || pdflatex ${EXTRA} $< || pdflatex ${EXTRA} $<
else
BUILD = python3 .build/latexrun.py -O $(OUT_DIR) -Wall --latex-args="${EXTRA}" $<
endif

SOURCES=$(shell find . ./TexFiles -name '*.tex' -or -name '*.bib' -or -name '*.sty' -or -name 'Makefile')
IMAGES=$(shell find ./Figures -name '*.pdf' -or -name '*.png' -or -name '*.jpg')

all: $(addsuffix .pdf,${MAIN})

%.pdf: %.tex ${SOURCES} ${IMAGES}
	${BUILD}

view: $(addsuffix .view,${MAIN})

%.view: %.pdf
	open $< &

.PHONY: figures
figures:
# UCX Put figures
# python3 ./Data/UCX-Put/plot.py Beluga ./Data/UCX-Put/Beluga/ucx-put.results ./Data/UCX-Put/Beluga/ResultsFigures
# cp ./Data/UCX-Put/Beluga/ResultsFigures/figure_ucx_put_bw_beluga_all_types_combined.pdf \
# 	./Figures/figure_ucx_put_bw_beluga_all_types_combined.pdf

clean:
	rm -rf $(OUT_DIR)/* ./$(MAIN).pdf

# rm -rf *.toc *.aux $(addsuffix .bbl,${MAIN}) *.blg *.log *~* \
# 	*.bak *.out $(addsuffix .pdf,${MAIN}) cut.sh .latexrun.db* *.fls \
# 	*.rel _region_.* *.synctex.gz *.glg *.gls *.glo *.ist *.sdn *.slg *.sym
