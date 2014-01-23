var TiHTTP = require('ti.http');
module.exports = function() {

	var win = Ti.UI.createWindow({
		layout: 'vertical',
		backgroundColor: '#ccc',
		title: 'Progress'
	});

	var progressBar = Ti.UI.createProgressBar({
		top: 20, left: 20, right: 20,
		min: 0, max: 1, value: 0
	});
	progressBar.show();

	var btn = Ti.UI.createButton({
		top: 20, left: 20, right: 20,
		title: 'Download Big File'
	});

	win.add(progressBar);
	win.add(btn);

	btn.addEventListener('click', function(){
		progressBar.value = 0;
	    var xhr = TiHTTP.createClient();
	    xhr.onload = function() {
	    	alert('Done downloading');
	    };
	    xhr.onerror = function() {
	    	alert(this.error);
	    };
	    xhr.onsendstream = function(e) {
	    	progressBar.value = e.progress;
	    }
	    xhr.open('GET', 'http://cdn.petkaria.com/pictures/z.about.com/d/cameras/1/0/u/1/bigcat.JPG');
	    xhr.send();
	});

	return win;
}