const TiRequestAuthDigest = 0;
const TiRequestAuthChallange = 1;
const TiRequestAuthBasic = 2;
var mainWindow = Ti.UI.createWindow();

var nav = Ti.UI.iOS.createNavigationWindow({
  window: mainWindow
});
var table = Ti.UI.createTableView({
  data: [
    {header : "GET requests", title: "Simple get", name: "GetSimple"},
    {title: "Progress", name: "GetProgress"},
    {title: "Response Headers", name: "GetHeaders"},
    {title: "Redirect", name: "GetRedirect"},
    {title: "Get gzip", name: "GetGzip"},

    {header : "POST requests",title: "Post form", name: "PostForm", method:"POST"},
    {title: "Post image", name: "PostImage", method:"POST"},
    {title: "Post form with image", name: "PostImageForm", method:"POST"},
    {title: "Post JSON string", name: "PostJsonString", method:"POST"},

    {header : "PUT requests", title: "Put form", name: "PostForm", method:"PUT"},
    {title: "Put image", name: "PostImage", method:"PUT"},
    {title: "Put form with image", name: "PostImageForm", method:"PUT"},
    {title: "Put JSON string", name: "PostJsonString", method:"PUT"},

    {header : "DELETE requests", title: "Put form", name: "PostForm", method:"DELETE"},
    {title: "Delete image", name: "PostImage", method:"DELETE"},
    {title: "Delete form with image", name: "PostImageForm", method:"DELETE"},
    {title: "Delete JSON string", name: "PostJsonString", method:"DELETE"},
    /*
    {header : "Auth",title: "Auth Basic", name: "Auth", method:"GET", "type": TiRequestAuthBasic},
    {title: "Auth Challange", name: "Auth", method:"GET", "type": TiRequestAuthChallange},
    {title: "Auth Digest", name: "Auth", method:"GET", "type": TiRequestAuthDigest},
    */
    {header : "Synchronous requests", title: "Get Synchronous", name: "Synchronous", method:"GET"},
    {title: "Post Synchronous", name: "Synchronous", method:"POST"},
    {title: "Put Synchronous", name: "Synchronous", method:"PUT"},
    {title: "Delete Synchronous", name: "Synchronous", method:"DELETE"},
    {title: "Patch Synchronous", name: "Synchronous", method:"PATCH"},
    /*
    {header : "Cookies",title: "Get Cookies", name: "CookiesGet"},
    {title: "Set Cookies", name: "CookiesSet"}
    */
  ]
});

table.addEventListener('click', function(e){
    nav.openWindow(
        require('tests/'+e.rowData.name)({
            method:e.rowData.method || 'GET'
        })
    );
});



mainWindow.add(table);

nav.open();