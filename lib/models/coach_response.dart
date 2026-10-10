class CoachResponse {
  final String message;
  final int? conversationId;
  final String? playbook;
  final bool safetyTriggered;
  final String? safetyLevel;

  CoachResponse({
    required this.message,
    this.conversationId,
    this.playbook,
    required this.safetyTriggered,
    this.safetyLevel,
  });

  factory CoachResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return CoachResponse(
      message: json['message']?.toString() ?? '',
      conversationId: json['conversationId'] as int?,
      playbook: json['playbook']?.toString(),
      safetyTriggered:
      json['safetyTriggered'] == true,
      safetyLevel:
      json['safetyLevel']?.toString(),
    );
  }
}