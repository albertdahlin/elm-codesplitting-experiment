

all: node_modules build/tmp build/main.html build/main.js build/main.css build/worker.js

FORCE:

build/tmp/%.js: src/%.js
	cp $< $@

build/%.html: src/%.html
	cp $< $@

build/main.css: src/main.css build/tmp/UI.js
	npx tailwindcss --minify --input $< --output $@ --content build/tmp/UI.js

build/tmp/UI.js: FORCE
	elm make --optimize --output $@ src/UI_*.elm
	npx split-elm-bundle $@

build/worker.js: build/tmp/Worker.elm.js FORCE
	cp src/Worker.js build/tmp/Worker.js
	npx esbuild --minify --bundle --outfile=$@ build/tmp/Worker.js

build/tmp/Worker.elm.js: FORCE
	elm make --optimize --output $@ src/Worker.elm

build/main.js: build/tmp/main.js build/tmp/UI.js
	npx esbuild --minify --format=esm --bundle --splitting --outdir=build build/tmp/main.js


build/tmp:
	mkdir -p $@

node_modules:
	npm install

clean:
	rm -rf build/*
