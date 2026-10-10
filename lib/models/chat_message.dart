enum MessageSender { user, coach }

class ChatMessage {
  final int? id;
  final int? conversationId;
  final int userId;
  final MessageSender sender;
  final String message;
  final String? detectedPlaybook;
  final bool safetyTriggered;
  final String? safetyLevel;
  final DateTime? date;

  ChatMessage({
    this.id,
    this.conversationId,
    required this.userId,
    required this.sender,
    required this.message,
    this.detectedPlaybook,
    this.safetyTriggered = false,
    this.safetyLevel,
    this.date,
  });

  bool get isFormUser => sender == MessageSender.user;

  DateTime get displayDate => date ?? DateTime.now();
}
