var TiHTTP = require('ti.http');
module.exports = function(_params) {

	var win = Ti.UI.createWindow({
		layout: 'vertical',
		backgroundColor: '#ccc'
	});

	var imageView = Ti.UI.createImageView({
		top: 20, left: 20, right: 20,
		height: Ti.UI.SIZE,
		image: 'photoDefault.png'
	});

	win.add(imageView);

	var btn = Ti.UI.createButton({
		top: 20, left: 20, right: 20,
		title: 'Send request'
	});

	win.add(btn);
	var blob = null;
	imageView.addEventListener('click', function(){
		Ti.Media.openPhotoGallery({
			success: function(e) {
				imageView.image = e.media;
				blob = e.media;
			}
		})
	});

	btn.addEventListener('click', function(){
	    var xhr = TiHTTP.createClient();
	    xhr.onload = function() {
    		alert('Please see log');
    		Ti.API.info(this.responseText);
	    };
	    xhr.onerror = function() {
	    	alert(this.error);
	    };
	    xhr.open(_params.method, 'http://httpbin.org/' + _params.method.toLowerCase());
	    xhr.send(blob);
	});

	function onKeyboard(e) {
		if(Ti.App.keyboardVisible) {
			textArea.animate({
				bottom: e.keyboardFrame.height + 20,
				duration: 0.25
			});
		} else {
			textArea.animate({
				bottom: 20,
				duration: 0.25
			});
		}
	}
	Ti.App.addEventListener('keyboardframechanged', onKeyboard);
	win.addEventListener('close', function() {
		Ti.App.removeEventListener('keyboardframechanged', onKeyboard);
	});
	return win;
}