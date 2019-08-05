var fs = require('fs');
var express = require('express-http2');
var app = express();

app.get('/', function (req, res) {
    res.send('hello, http2!');
});

var options = {
    key: fs.readFileSync('./server.key'),
    cert: fs.readFileSync('./server.crt')
};

require('http2').createServer(options, app).listen(8002);