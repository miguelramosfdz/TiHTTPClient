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

	var imageView = Ti.UI.createImageView({
		top: 20, left: 20, right: 20,
		height: Ti.UI.SIZE,
		image: 'photoDefault.png'
	});

	scrollView.add(imageView);

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
	    xhr.send({
	    	image: blob,
	    	first_name: nameField.value,
	    	last_name: lastNameField.value,
	    	email_address: emailField.value
	    });
	});
	return win;
}