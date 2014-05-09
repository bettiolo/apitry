var http = require('http');
var os = require('os')
var port = process.env.PORT || process.env.port || 8000;
var nodeEnv = process.env.NODE_ENV || 'unknown';
var apitryEnv = process.env.APITRY_ENV || 'unknown';
var server = http.createServer(function (req, res) {
	res.writeHead(200, {'Content-Type': 'text/plain'});
	res.write('Hello World\n');
	res.write('Environment: ' + apitryEnv + '\n');
	res.write('Production Mode: ' + (nodeEnv == 'production' ? 'yes' : 'no') + '\n');
	res.write('Host: ' + os.hostname() + '\n');
	res.write('OS Type: ' + os.type() + '\n');
	res.write('OS Platform: ' + os.platform() + '\n');
	res.write('OS Arch: ' + os.arch() + '\n');
	res.write('OS Release: ' + os.release() + '\n');
	res.write('OS Uptime: ' + os.uptime() + '\n');
	res.write('OS Free memory: ' + os.freemem() / 1024 / 1024 + 'mb\n');
	res.write('OS Total memory: ' + os.totalmem() / 1024 / 1024 + 'mb\n');
	res.write('OS CPU count: ' + os.cpus().length + '\n');
	res.write('OS CPU model: ' + os.cpus()[0].model + '\n');
	res.write('OS CPU speed: ' + os.cpus()[0].speed + 'mhz\n');
	res.write('Headers:\n');
	res.write(JSON.stringify(req.headers, null, 2) + '\n');
	res.end('\n');
});
server.listen(port);
console.log('Server running on port ' + port);