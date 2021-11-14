## pica.js
[**pica**](https://github.com/nodeca/pica) - high quality image resize in browser

### Browserify - Convert node pica.js to browser pica.js
- [**Browserify**](browserify.org) - Let you require('modules') in the browser by bundling up all dependencies.

```sh
## install browserify
pacman -Sy npm
npm install -g browserify
npm install --save-dev babelify
npm install --save-dev @babel/core @babel/preset-env
npm install pica

## convert
# create require line in a temp file
echo "    pica = require('pica')();" > entry.js

# browserify entry.js to pica.js
browserify entry.js -o /root/node_modules/pica/dist/pica.js

# !important: 
#   - DON'T use /root/node_modules/pica/dist/pica.min.js
#   - manually minify with /root/node_modules/pica/dist/pica.js

# remove temp file
rm entry.js
```

## Usage
```js
var picaOption = {
	  unsharpAmount    : 100  // 0...500 Default = 0 (try 50-100)
	, unsharpThreshold : 5    // 0...100 Default = 0 (try 10)
	, unsharpRadius    : 0.6
//	, quality          : 3    // 0...3 Default = 3 (Lanczos win=3)
//	, alpha            : true // Default = false (black crop background)
};
var img = $( '#orinialImgage' ).attr( 'src' );
var picacanvas = document.createElement( 'canvas' ); // create canvas object
picacanvas.width = 100;                              // set width
picacanvas.height = 200;                             // set height
pica.resize( img, picacanvas, picaOption ).then( function() {
	// img resized to picacanvas
	var resizedbase64 = picacanvas.toDataURL( 'image/jpeg', 0.9 ); // canvas to base64 (jpg, qualtity)
} );
```
