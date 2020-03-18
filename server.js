var http = require('http');
var path = require('path');
var fs = require('fs');
var marked = require('marked');
var mime = require('./mime.json');
const { pathToFileURL } = require('url');
const { type } = require('os');
var server = http.createServer();

server.listen(8888, function() {
    console.log('服务器正在端口号：8888上运行......');
});

function load(request, response) {
    var url = request.url;

    fs.readFile('./' + decodeURI(url), 'utf-8', function(err, data) {
        var dtype = "text/plain";
        var ext = path.extname(url);
        if (mime[ext] != undefined) {
            console.log(mime[ext]);
            dtype = mime[ext];
            if (dtype.startsWith('text')) {
                dtype += '; chartset=utf8';
            }
        }
        response.writeHead(200, {
            "Content-Type": dtype
        });
        response.end(data);
    });
}

server.on('request', function(request, response) {
    console.log(request.url);
    load(request, response);
});