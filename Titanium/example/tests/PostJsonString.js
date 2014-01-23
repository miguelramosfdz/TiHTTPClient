var TiHTTP = require('ti.http');
module.exports = function(_params) {

	var win = Ti.UI.createWindow({
		layout: 'vertical',
		backgroundColor: '#ccc'
	});

	var scrollView = Ti.UI.createScrollView({
		layout: 'vertical',
		width: Ti.UI.FILL,
		height: Ti.UI.FILL,
		contentHeight: Ti.UI.SIZE,
		contentWidth: Ti.UI.FILL
	});

	var view1 = Ti.UI.createView({
		left: 20, right: 20, top: 10,
		height: Ti.UI.SIZE
	});
	var key1 = Ti.UI.createTextField({
		left: 0, width: '40%',
		borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
		value: 'key1'
	});
	view1.add(key1);
	var value1 = Ti.UI.createTextField({
		right: 0, width: '40%',
		borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
		value: 'value1'
	});
	view1.add(value1);
	scrollView.add(view1)

	var view2 = Ti.UI.createView({
		left: 20, right: 20, top: 10,
		height: Ti.UI.SIZE
	});
	var key2 = Ti.UI.createTextField({
		left: 0, width: '40%',
		borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
		value: 'key2'
	});
	view2.add(key2);
	var value2 = Ti.UI.createTextField({
		right: 0, width: '40%',
		borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
		value: 'value2'
	});
	view2.add(value2);
	scrollView.add(view2)

	var view3 = Ti.UI.createView({
		left: 20, right: 20, top: 10,
		height: Ti.UI.SIZE
	});
	var key3 = Ti.UI.createTextField({
		left: 0, width: '40%',
		borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
		value: 'key3'
	});
	view3.add(key3);
	var value3 = Ti.UI.createTextField({
		right: 0, width: '40%',
		borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
		value: 'value3'
	});
	view3.add(value3);
	scrollView.add(view3)

	var btn = Ti.UI.createButton({
		top: 20, left: 20, right: 20,
		title: 'Send JSON string'
	});
	scrollView.add(btn);
	win.add(scrollView);

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

	    var obj = {};
	    obj[key1.value] = value1.value;
	    obj[key2.value] = value2.value;
	    obj[key3.value] = value3.value;
	    xhr.send(JSON.stringify(obj));
	});
	return win;
}