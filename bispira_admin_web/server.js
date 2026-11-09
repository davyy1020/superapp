// ==============================================================================
// BISPIRA Backend - cPanel Passenger / Production Server Entry
// ==============================================================================
const path = require('path');
const http = require('http');
const { parse } = require('url');

// Always ensure app directory points to __dirname
const appDir = __dirname;
process.chdir(appDir);

// Force production mode on cPanel hosting to use pre-built .next artifacts
process.env.NODE_ENV = 'production';

const next = require('next');
const app = next({ 
  dev: false, 
  dir: appDir,
  quiet: false
});
const handle = app.getRequestHandler();

// cPanel Passenger passes port or unix socket via process.env.PORT
const port = process.env.PORT || 3000;
const hostname = '0.0.0.0';

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

  server.listen(port, () => {
    console.log(`> BISPIRA Production Backend running on port ${port} from ${appDir}`);
  });
}).catch((err) => {
  console.error('Fatal error during Next.js app preparation:', err);
  process.exit(1);
});
