var TiHTTP = require('ti.http');
module.exports = function(_params) {

	var win = Ti.UI.createWindow({
		layout: 'vertical',
		backgroundColor: '#ccc'
	});

	var textField = Ti.UI.createTextField({
		top: 20, left: 20, right: 20,
		borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
		value: 'http://httpbin.org/' + _params.method.toLowerCase()
	});

	var btn = Ti.UI.createButton({
		top: 20, left: 20, right: 20,
		title: 'Send Synchronous request'
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
	    xhr.open(_params.method, textField.value, false);
	    xhr.send();

	    if(xhr.error) {
	    	alert(xhr.error);
	    } else {
	    	textArea.value = xhr.responseText;
	    }
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