// lib/src/features/backend/embedded_server.dart
import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

class EmbeddedServer {
  static HttpServer? _server;
  static Future<void> start() async {
    if (_server != null) return;
    final router = Router()..post('/receipts', _handler);
    _server = await io.serve(router, '0.0.0.0', 8080);
    print('📡 Embedded server on ${_server!.address.host}:${_server!.port}');
  }

  static Future<Response> _handler(Request req) async {
    final body = jsonDecode(await req.readAsString());
    body['id'] = 'local_${DateTime.now().millisecondsSinceEpoch}';
    body['status'] = 'accepted';
    return Response.ok(jsonEncode(body),
        headers: {'content-type': 'application/json'});
  }

  static Future<void> stop() async => _server?.close();
}