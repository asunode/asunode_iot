import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/constants/network_constants.dart';
import '../models/status_dto.dart';
import '../models/command_dto.dart';

class ESPRemoteDataSource {
  final http.Client client;

  ESPRemoteDataSource({http.Client? client})
      : client = client ?? http.Client();

  /// ESP cihazından status alır (GET /status)
  Future<StatusDTO> getDeviceStatus(String ip) async {
    final url = Uri.http(
      '$ip:${NetworkConstants.apiPort}',
      NetworkConstants.endpointStatus,
    );

    final response = await client.get(url).timeout(
      NetworkConstants.connectionTimeout,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return StatusDTO.fromJson(json);
    } else {
      throw Exception('Status fetch failed: ${response.statusCode}');
    }
  }

  /// ESP'ye komut gönderir (POST /command)
  Future<bool> sendCommand(String ip, CommandDTO command) async {
    final url = Uri.http(
      '$ip:${NetworkConstants.apiPort}',
      NetworkConstants.endpointCommand,
    );

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
        'Connection': 'close',
      },
      body: jsonEncode(command.toJson()),
    ).timeout(NetworkConstants.requestTimeout);

    return response.statusCode >= 200 && response.statusCode < 300;
  }

  void dispose() {
    client.close();
  }
}
