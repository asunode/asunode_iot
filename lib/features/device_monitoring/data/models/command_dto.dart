class CommandDTO {
  final String action;
  final String target;
  final String deviceIp;
  final dynamic value;
  final String timestamp;

  CommandDTO({
    required this.action,
    required this.target,
    required this.deviceIp,
    this.value,
    String? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'target': target,
      'deviceIp': deviceIp,
      if (value != null) 'value': value,
      'timestamp': timestamp,
    };
  }

  factory CommandDTO.toggleRelay(String deviceIp, String relayId) {
    return CommandDTO(
      action: 'toggle',
      target: relayId,
      deviceIp: deviceIp,
    );
  }

  factory CommandDTO.setRelay(String deviceIp, String relayId, bool state) {
    return CommandDTO(
      action: state ? 'open' : 'close',
      target: relayId,
      deviceIp: deviceIp,
    );
  }

  factory CommandDTO.rebootDevice(String deviceIp) {
    return CommandDTO(
      action: 'reboot',
      target: 'system',
      deviceIp: deviceIp,
    );
  }

  @override
  String toString() =>
      'CommandDTO(action: $action, target: $target, device: $deviceIp)';
}
