from http.server import SimpleHTTPRequestHandler, HTTPServer
import os, json, time

PORT = 8000
HOSTNAME = os.getenv("HOSTNAME", "app-v2")

class Handler(SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/info":
            info = {"version": "v2", "hostname": HOSTNAME, "time": time.strftime("%Y-%m-%d %H:%M:%S")}
            self.send_response(200)
            self.send_header("Content-Type","application/json")
            self.end_headers()
            self.wfile.write(json.dumps(info).encode())
            return

        return SimpleHTTPRequestHandler.do_GET(self)

if __name__ == "__main__":
    if os.path.isdir("/usr/share/app"):
        os.chdir("/usr/share/app")
    httpd = HTTPServer(("", PORT), Handler)
    print(f"Serving v2 on {PORT}")
    httpd.serve_forever()
