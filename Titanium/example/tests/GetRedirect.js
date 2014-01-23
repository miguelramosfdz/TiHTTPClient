var TiHTTP = require('ti.http');
module.exports = function() {

	var win = Ti.UI.createWindow({
		layout: 'vertical',
		backgroundColor: '#ccc'
	});

	var textField = Ti.UI.createTextField({
		top: 20, left: 20, right: 20,
		borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
		value: 'http://httpbin.org/redirect/6'
	});

	var v = Ti.UI.createView({
		height: Ti.UI.SIZE,
		top: 20, layout: 'horizontal',
		left: 20, right: 20
	});

	var toggle = Ti.UI.createSwitch({
		left: 0, width: Ti.UI.SIZE,
		value: 1
	});

	v.add(toggle);

	var btn = Ti.UI.createButton({
		left: 0, width: Ti.UI.FILL,
		title: 'Send Redirect'
	});
	v.add(btn);

	var textArea = Ti.UI.createTextArea({
		editable:false,
		top: 20, left: 20, right: 20, bottom: 20
	});

	win.add(textField);
	win.add(v);
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
	    xhr.autoRedirect = toggle.value;
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