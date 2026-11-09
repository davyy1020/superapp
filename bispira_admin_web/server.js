// ==============================================================================
// BISPIRA Backend - cPanel Passenger / Custom Node.js Server Entry
// ==============================================================================
const http = require('http');
const { parse } = require('url');
const next = require('next');

const dev = process.env.NODE_ENV !== 'production';
const hostname = '0.0.0.0';
// cPanel Passenger sets process.env.PORT automatically (either numeric port or passenger pipe)
const port = process.env.PORT || 3000;

const app = next({ dev, hostname, port });
const handle = app.getRequestHandler();

app.prepare().then(() => {
  const server = http.createServer((req, res) => {
    try {
      const parsedUrl = parse(req.url, true);
      handle(req, res, parsedUrl);
    } catch (err) {
      console.error('Error handling request:', req.url, err);
      res.statusCode = 500;
      res.end('Internal Server Error');
    }
  });

  server.listen(port, (err) => {
    if (err) throw err;
    console.log(`> BISPIRA Next.js Server is running on port ${port} (NODE_ENV=${process.env.NODE_ENV || 'production'})`);
  });
}).catch((err) => {
  console.error('Fatal error during Next.js app preparation:', err);
  process.exit(1);
});
