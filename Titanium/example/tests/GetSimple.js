var TiHTTP = require('ti.http');
module.exports = function() {

	var win = Ti.UI.createWindow({
		layout: 'vertical',
		backgroundColor: '#ccc'
	});

	var textField = Ti.UI.createTextField({
		top: 20, left: 20, right: 20,
		borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
		value: 'http://httpbin.org/get'
	});

	var btn = Ti.UI.createButton({
		top: 20, left: 20, right: 20,
		title: 'Send request'
	});

	var textArea = Ti.UI.createTextArea({
		editable:false,
		top: 20, left: 20, right: 20, bottom: 20
	});

	win.add(textField);
	win.add(btn);
	win.add(textArea);

	btn.addEventListener('click', function(){
		textField.blur();
		textArea.value = 'Loading, please wait...';
	    var xhr = TiHTTP.createClient();
	    xhr.onload = function() {
	    	textArea.value = this.responseText;
	    };
	    xhr.onerror = function() {
	    	alert(this.error);
	    };
	    xhr.open('GET', textField.value);
	    xhr.send();
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