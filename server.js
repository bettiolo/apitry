var http = require('http');
var port = process.env.port || 10080;
var server = http.createServer(function (req, res) {
	res.writeHead(200, {'Content-Type': 'text/plain'});
	res.end('Hello World\n');
})
server.listen(port);
console.log('Server running on port ' + port);