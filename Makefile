GO=~/go/bin/go1.18.1

.PHONY: wasm
wasm:
	GOOS=js GOARCH=wasm $(GO) build -o ./web/webwormhole.wasm ./web
	cp $(shell $(GO) env GOROOT)/misc/wasm/wasm_exec.js ./web/wasm_exec.js

.PHONY: webwormhole-ext.zip
webwormhole-ext.zip: wasm
	zip -j webwormhole-ext.zip ./web/* -x '*.git*' '*.go' '*Dockerfile'

.PHONY: webwormhole-src.zip
webwormhole-src.zip:
	zip -r -FS webwormhole-src.zip  * -x '*.git*' webwormhole-src.zip webwormhole-ext.zip

.PHONY: all
all: webwormhole-ext.zip

.PHONY: fmt
fmt:
	prettier -w --use-tabs web/*.ts
	$(GO) fmt ./...

.PHONY: js
js:
	tsc -T ES2018 --strict web/ww.ts
	tsc -T ES2018 --strict web/sw.ts
