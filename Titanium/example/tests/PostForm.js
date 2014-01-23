var TiHTTP = require('ti.http');
module.exports = function(_params) {

	var win = Ti.UI.createWindow({
		backgroundColor: '#ccc'
	});
	var scrollView = Ti.UI.createScrollView({
		layout: 'vertical',
		width: Ti.UI.FILL,
		height: Ti.UI.FILL,
		contentHeight: Ti.UI.SIZE,
		contentWidth: Ti.UI.FILL
	});

	var nameLabel = Ti.UI.createLabel({
		top: 20,
		left: 20,
		text: 'First Name',
	});
	scrollView.add(nameLabel)
	var nameField = Ti.UI.createTextField({
		top: 8, left: 20, right: 20,
		borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
		value: 'Pedro'
	});
	scrollView.add(nameField);

	var lastNameLabel = Ti.UI.createLabel({
		top: 20,
		left: 20,
		text: 'Last Name',
	});
	scrollView.add(lastNameLabel)
	var lastNameField = Ti.UI.createTextField({
		top: 8, left: 20, right: 20,
		borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
		value: 'Enrique'
	});
	scrollView.add(lastNameField);

	var emailLabel = Ti.UI.createLabel({
		top: 20,
		left: 20,
		text: 'Email Address',
	});
	scrollView.add(emailLabel)
	var emailField = Ti.UI.createTextField({
		top: 8, left: 20, right: 20,
		borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
		value: 'penrique@appcelerator.com'
	});
	scrollView.add(emailField);


	var btn = Ti.UI.createButton({
		top: 20, left: 20, right: 20,
		title: 'Create Account'
	});
	scrollView.add(btn);
	win.add(scrollView);

	btn.addEventListener('click', function(){
		nameField.blur();
		lastNameField.blur();
		emailField.blur();
	    var xhr = TiHTTP.createClient();
	    xhr.onload = function() {
	    	alert('See logs for result');
	    	Ti.API.info(this.responseText);
	    };
	    xhr.onerror = function() {
	    	alert(this.error);
	    };
	    xhr.open(_params.method, 'http://httpbin.org/' + _params.method.toLowerCase());
	    xhr.send({
	    	first_name: nameField.value,
	    	last_name: lastNameField.value,
	    	email_address: emailField.value
	    });
	});

	return win;
}