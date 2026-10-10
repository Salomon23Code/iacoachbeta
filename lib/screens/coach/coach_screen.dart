import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat_message.dart';
import '../../providers/ai_provider.dart';
import '../../providers/daily_action_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../checkin/checkin_screen.dart';

class CoachScreen extends StatefulWidget {
  const CoachScreen({super.key});

  @override
  State<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  // ============================================================
  // SCROLL
  // ============================================================

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // ============================================================
  // ENVOYER UN MESSAGE
  // ============================================================

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();

    if (message.isEmpty) return;

    final userProvider = context.read<UserProvider>();

    final user = userProvider.currentUser;

    if (user == null) {
      _showError('Utilisateur introuvable.');
      return;
    }

    final aiProvider = context.read<AiProvider>();

    // Évite plusieurs requêtes simultanées
    if (aiProvider.isLoading) return;

    _messageController.clear();

    FocusScope.of(context).unfocus();

    await aiProvider.sendMessage(userId: user.id, message: message);

    if (!mounted) return;

    _scrollToBottom();

    // Afficher une erreur éventuelle
    if (aiProvider.error != null) {
      _showError(aiProvider.error!);
    }
  }

  // ============================================================
  // ERREUR
  // ============================================================

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // EFFACER LA CONVERSATION
  // ============================================================

  void _clearConversation() {
    final aiProvider = context.read<AiProvider>();

    if (aiProvider.messages.isEmpty) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Effacer la conversation'),
          content: const Text(
            'Voulez-vous vraiment supprimer les messages '
            'de cette conversation ?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                aiProvider.clearConversation();

                Navigator.pop(dialogContext);

                _scrollToBottom();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // MESSAGE COACH
  // ============================================================

  Widget _buildCoachMessage(BuildContext context, ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 60, bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar NEO
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy,
              color: AppTheme.primary,
              size: 22,
            ),
          ),

          const SizedBox(width: 10),

          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NEO',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    message.message,
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 15,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    _formatMessageTime(message),
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MESSAGE UTILISATEUR
  // ============================================================

  Widget _buildUserMessage(BuildContext context, ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(left: 60, right: 16, bottom: 14),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, AppTheme.darkGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(6),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.20),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                _formatMessageTime(message),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INDICATEUR DE CHARGEMENT
  // ============================================================

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 60, bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy,
              color: AppTheme.primary,
              size: 22,
            ),
          ),

          const SizedBox(width: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TypingDot(),
                SizedBox(width: 4),
                _TypingDot(),
                SizedBox(width: 4),
                _TypingDot(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ÉTAT VIDE
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                size: 46,
                color: AppTheme.primary,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Bonjour 👋',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Je suis NEO, votre coach.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Parlez-moi de votre journée, '
              'de vos repas, de votre activité '
              'ou de ce qui vous pose problème.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textMedium,
                fontSize: 15,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.07),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.favorite_outline, color: AppTheme.primary),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Chaque petit pas compte. '
                      'On avance ensemble, sans culpabilité.',
                      style: TextStyle(color: AppTheme.textDark, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CHAMP DE SAISIE
  // ============================================================

  Widget _buildMessageInput(BuildContext context) {
    final aiProvider = context.watch<AiProvider>();

    final isLoading = aiProvider.isLoading;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                enabled: !isLoading,
                minLines: 1,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.newline,
                onSubmitted: (_) {
                  if (!isLoading) {
                    _sendMessage();
                  }
                },
                decoration: InputDecoration(
                  hintText: isLoading ? 'NEO réfléchit...' : 'Écrivez à NEO...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 13,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: AppTheme.primary,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            GestureDetector(
              onTap: isLoading ? null : _sendMessage,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isLoading ? Colors.grey : AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(15),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ACTION QUOTIDIENNE
  // ============================================================

  Widget _buildActionProposal(BuildContext context) {
    final actionProvider = context.watch<DailyActionProvider>();

    final action = actionProvider.currentAction;

    if (action == null || action.committed) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withOpacity(0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🌱 Ma nouvelle petite action',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),

          const SizedBox(height: 16),

          _ActionInfo(
            icon: Icons.flag_outlined,
            title: 'Action',
            value: action.title,
          ),

          const SizedBox(height: 12),

          _ActionInfo(
            icon: Icons.notifications_none,
            title: 'Déclencheur',
            value: action.trigger,
          ),

          const SizedBox(height: 12),

          _ActionInfo(
            icon: Icons.schedule,
            title: 'Suivi',
            value: action.tracking,
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final user = context.read<UserProvider>().currentUser;
                    if (user == null) {
                      _showError('Utilisateur introuvable.');
                      return;
                    }
                    final committed = await actionProvider.commitAction(
                      userId: user.id,
                    );
                    if (!mounted) return;
                    if (!committed) {
                      _showError(
                        actionProvider.error ??
                            'Impossible d’enregistrer votre engagement.',
                      );
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Votre engagement est enregistré 🌱'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Je m’engage'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CheckInScreen()),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Modifier'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppTheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DATE / HEURE
  // ============================================================

  String _formatMessageTime(ChatMessage message) {
    // Ton ancien ChatMessage possède date.
    // On garde cette logique pour rester compatible
    // avec ton modèle actuel.

    final date = message.date;

    final hour = date?.hour.toString().padLeft(2, '0');

    final minute = date?.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final aiProvider = context.watch<AiProvider>();

    final messages = aiProvider.messages;

    final isLoading = aiProvider.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,

        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, color: AppTheme.primary),
            ),

            const SizedBox(width: 12),

            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEO',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  'Votre coach personnalisé',
                  style: TextStyle(color: AppTheme.textMedium, fontSize: 11),
                ),
              ],
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: messages.isEmpty || isLoading
                ? null
                : _clearConversation,
            tooltip: 'Effacer la conversation',
            icon: Icon(
              Icons.delete_outline,
              color: messages.isEmpty || isLoading
                  ? Colors.grey
                  : AppTheme.textMedium,
            ),
          ),

          const SizedBox(width: 6),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 20, bottom: 15),
                    itemCount: messages.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      // NEO réfléchit
                      if (isLoading && index == messages.length) {
                        return _buildTypingIndicator();
                      }

                      final message = messages[index];

                      if (message.sender == MessageSender.coach) {
                        return _buildCoachMessage(context, message);
                      }

                      return _buildUserMessage(context, message);
                    },
                  ),
          ),

          _buildActionProposal(context),

          _buildMessageInput(context),
        ],
      ),
    );
  }
}

// ================================================================
// ACTION INFO
// ================================================================

class _ActionInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ActionInfo({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 21, color: AppTheme.primary),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textMedium,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ================================================================
// TYPING DOT
// ================================================================

class _TypingDot extends StatefulWidget {
  const _TypingDot();

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 7,
        height: 7,
        decoration: const BoxDecoration(
          color: AppTheme.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
