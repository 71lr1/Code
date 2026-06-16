import idaapi
import idc
import idautils
import ida_hexrays
import ida_funcs
import ida_name
import json
import threading
from http.server import HTTPServer, BaseHTTPRequestHandler

PORT = 3100

def get_func_pseudocode(ea):
    try:
        cfunc = ida_hexrays.decompile(ea)
        if cfunc:
            return str(cfunc)
    except:
        pass
    return None

def get_func_disasm(ea):
    func = ida_funcs.get_func(ea)
    if not func:
        return None
    lines = []
    for head in idautils.Heads(func.start_ea, func.end_ea):
        lines.append(f"{hex(head)}: {idc.GetDisasm(head)}")
    return "\n".join(lines)

def get_all_strings():
    results = []
    for s in idautils.Strings():
        results.append({
            "addr": hex(s.ea),
            "value": str(s),
            "len": s.length
        })
    return results

def search_strings(query):
    results = []
    query = query.lower()
    for s in idautils.Strings():
        val = str(s)
        if query in val.lower():
            results.append({
                "addr": hex(s.ea),
                "value": val
            })
    return results

def get_xrefs_to(ea):
    results = []
    for xref in idautils.XrefsTo(ea):
        fname = ida_funcs.get_func_name(xref.frm) or "unknown"
        results.append({
            "from": hex(xref.frm),
            "func": fname,
            "type": xref.type
        })
    return results

def get_imports():
    results = []
    nimps = idaapi.get_import_module_qty()
    for i in range(nimps):
        name = idaapi.get_import_module_name(i)
        def cb(ea, fname, ordinal):
            results.append({
                "module": name,
                "name": fname or f"ord_{ordinal}",
                "addr": hex(ea)
            })
            return True
        idaapi.enum_import_names(i, cb)
    return results

def get_functions(limit=100, offset=0):
    funcs = []
    all_funcs = list(idautils.Functions())
    for ea in all_funcs[offset:offset+limit]:
        funcs.append({
            "addr": hex(ea),
            "name": ida_funcs.get_func_name(ea) or "unknown"
        })
    return {"total": len(all_funcs), "funcs": funcs}

def addr_from_str(s):
    try:
        if s.startswith("0x") or s.startswith("0X"):
            return int(s, 16)
        return int(s, 16)
    except:
        ea = idc.get_name_ea_simple(s)
        if ea != idc.BADADDR:
            return ea
    return None

class MCPHandler(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        pass

    def send_json(self, code, data):
        body = json.dumps(data).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", len(body))
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(body)

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def do_GET(self):
        if self.path == "/":
            self.send_json(200, {"status": "ok", "name": "ida-mcp"})
        elif self.path == "/sse":
            self.send_response(200)
            self.send_header("Content-Type", "text/event-stream")
            self.send_header("Cache-Control", "no-cache")
            self.send_header("Access-Control-Allow-Origin", "*")
            self.end_headers()
            manifest = {
                "jsonrpc": "2.0",
                "method": "notifications/initialized",
                "params": {}
            }
            self.wfile.write(f"data: {json.dumps(manifest)}\n\n".encode())
            self.wfile.flush()
        else:
            self.send_json(404, {"error": "not found"})

    def do_POST(self):
        length = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(length)
        try:
            req = json.loads(body)
        except:
            self.send_json(400, {"error": "invalid json"})
            return

        method = req.get("method", "")
        params = req.get("params", {})
        req_id = req.get("id")

        def ok(result):
            self.send_json(200, {"jsonrpc": "2.0", "id": req_id, "result": result})

        def err(msg):
            self.send_json(200, {"jsonrpc": "2.0", "id": req_id, "error": {"code": -1, "message": msg}})

        if method == "initialize":
            ok({
                "protocolVersion": "2024-11-05",
                "capabilities": {"tools": {}},
                "serverInfo": {"name": "ida-mcp", "version": "1.0.0"}
            })

        elif method == "tools/list":
            ok({"tools": [
                {
                    "name": "pseudocode",
                    "description": "Get Hex-Rays pseudocode for a function at address or name",
                    "inputSchema": {
                        "type": "object",
                        "properties": {"addr": {"type": "string"}},
                        "required": ["addr"]
                    }
                },
                {
                    "name": "disasm",
                    "description": "Get disassembly for a function at address or name",
                    "inputSchema": {
                        "type": "object",
                        "properties": {"addr": {"type": "string"}},
                        "required": ["addr"]
                    }
                },
                {
                    "name": "strings",
                    "description": "Search strings in binary. Pass empty query for all strings.",
                    "inputSchema": {
                        "type": "object",
                        "properties": {"query": {"type": "string"}},
                        "required": []
                    }
                },
                {
                    "name": "xrefs",
                    "description": "Get cross-references to an address or name",
                    "inputSchema": {
                        "type": "object",
                        "properties": {"addr": {"type": "string"}},
                        "required": ["addr"]
                    }
                },
                {
                    "name": "imports",
                    "description": "List all imported functions",
                    "inputSchema": {"type": "object", "properties": {}}
                },
                {
                    "name": "functions",
                    "description": "List functions in the binary",
                    "inputSchema": {
                        "type": "object",
                        "properties": {
                            "limit": {"type": "number"},
                            "offset": {"type": "number"}
                        }
                    }
                }
            ]})

        elif method == "tools/call":
            name = params.get("name")
            args = params.get("arguments", {})

            def text(s):
                ok({"content": [{"type": "text", "text": str(s)}]})

            if name == "pseudocode":
                ea = addr_from_str(args.get("addr", ""))
                if ea is None:
                    err("invalid address")
                    return
                code = get_func_pseudocode(ea)
                text(code if code else "decompilation failed")

            elif name == "disasm":
                ea = addr_from_str(args.get("addr", ""))
                if ea is None:
                    err("invalid address")
                    return
                text(get_func_disasm(ea) or "no function at address")

            elif name == "strings":
                q = args.get("query", "")
                if q:
                    text(json.dumps(search_strings(q), indent=2))
                else:
                    text(json.dumps(get_all_strings()[:500], indent=2))

            elif name == "xrefs":
                ea = addr_from_str(args.get("addr", ""))
                if ea is None:
                    err("invalid address")
                    return
                text(json.dumps(get_xrefs_to(ea), indent=2))

            elif name == "imports":
                text(json.dumps(get_imports(), indent=2))

            elif name == "functions":
                limit = int(args.get("limit", 100))
                offset = int(args.get("offset", 0))
                text(json.dumps(get_functions(limit, offset), indent=2))

            else:
                err(f"unknown tool: {name}")
        else:
            ok({})


class IDAMCPPlugin(idaapi.plugin_t):
    flags = idaapi.PLUGIN_KEEP
    comment = "MCP Server for Claude"
    help = ""
    wanted_name = "IDA MCP"
    wanted_hotkey = "Ctrl-Shift-M"

    def init(self):
        return idaapi.PLUGIN_KEEP

    def run(self, arg):
        t = threading.Thread(target=self._start, daemon=True)
        t.start()
        idaapi.msg(f"[MCP] Server started on port {PORT}\n")

    def _start(self):
        srv = HTTPServer(("0.0.0.0", PORT), MCPHandler)
        srv.serve_forever()

    def term(self):
        pass


def PLUGIN_ENTRY():
    return IDAMCPPlugin()