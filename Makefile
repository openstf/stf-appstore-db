inventory_json := inventory.json
apps := $(shell jq -r '"app-" + keys[]' $(inventory_json))

# Don't autoremove any intermediate files; they should be cached.
.SECONDARY:
.PHONY: clean

all: $(apps)

clean:
	rm -rf build dist

$(apps): app-% : \
	dist/icon/24x24/%.png \
	dist/icon/96x96/%.png

build/platforms/android:
	mkdir -p $@

build/platforms/android/%.png: build/platforms/android
	if [ -f 'static/android/$*.png' ]; then \
		cp 'static/android/$*.png' $@ \
		; \
	fi

dist/icon/24x24:
	mkdir -p $@

dist/icon/24x24/%.png: build/platforms/android/%.png | dist/icon/24x24
	gm convert $< -resize 24x24 $@
	pngcrush -q -brute $@ $@.crushed && mv $@.crushed $@

dist/icon/96x96:
	mkdir -p $@

dist/icon/96x96/%.png: build/platforms/android/%.png | dist/icon/96x96
	gm convert $< -resize 96x96 $@
	pngcrush -q -brute $@ $@.crushed && mv $@.crushed $@
