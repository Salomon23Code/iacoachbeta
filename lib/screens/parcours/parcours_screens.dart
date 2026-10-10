import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cheicking_provider.dart';
import '../../providers/daily_action_provider.dart';
import '../../providers/goal_provider.dart';
import '../../providers/habit_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/weigtn_provider.dart';

import '../../theme/app_theme.dart';
import '../../widgets/coach_memory_card.dart';
import '../../widgets/habit_card.dart';
import '../../widgets/periode.dart';

class ParcoursScreen extends StatefulWidget {
  const ParcoursScreen({super.key});

  @override
  State<ParcoursScreen> createState() => _ParcoursScreenState();
}

class _ParcoursScreenState extends State<ParcoursScreen> {
  WeightPeriod _selectedPeriod = WeightPeriod.all;

  @override
  Widget build(BuildContext context) {
    final weightProvider = context.watch<WeightProvider>();

    final habitProvider = context.watch<HabitProvider>();

    final goalProvider = context.watch<GoalProvider>();

    final actionProvider = context.watch<DailyActionProvider>();

    final checkInProvider = context.watch<CheckInProvider>();

    final records = weightProvider.getRecordsForPeriod(_selectedPeriod);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mon parcours',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =========================
            // EVOLUTION
            // =========================
            const Text(
              'Votre évolution',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),

            const SizedBox(height: 15),

            WeightPeriodSelector(
              selected: _selectedPeriod,

              onChanged: (period) {
                setState(() {
                  _selectedPeriod = period;
                });
              },
            ),

            const SizedBox(height: 18),

            _WeightChart(records: records),

            const SizedBox(height: 24),

            // =========================
            // HABITUDES
            // =========================
            HabitStreakCard(streak: habitProvider.currentStreak),

            const SizedBox(height: 28),

            const Text(
              'Ce que mon Coach sait de moi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),

            const SizedBox(height: 14),

            // =========================
            // MON CAP
            // =========================
            CoachMemoryCard(
              icon: Icons.track_changes,
              title: 'Mon cap',

              content: goalProvider.targetWeight == null
                  ? 'Votre objectif sera affiché ici.'
                  : 'Atteindre ${goalProvider.targetWeight!.toStringAsFixed(1)} kg',

              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppTheme.primary),

                onPressed: () {
                  _showEditGoalDialog(context, goalProvider);
                },
              ),
            ),

            // =========================
            // DECLENCHEURS
            // =========================
            CoachMemoryCard(
              icon: Icons.notifications_active_outlined,

              title: 'Mes déclencheurs',

              content: actionProvider.committedActions.isEmpty
                  ? 'Aucun déclencheur enregistré.'
                  : actionProvider.committedActions
                        .map((action) => '• ${action.trigger}')
                        .join('\n'),
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppTheme.primary),

                onPressed: () {},
              ),
            ),

            // =========================
            // CHECK-INS
            // =========================
            CoachMemoryCard(
              icon: Icons.fact_check_outlined,

              title: 'Mes check-ins',

              content: checkInProvider.checkIns.isEmpty
                  ? 'Vos check-ins apparaîtront ici.'
                  : checkInProvider.checkIns
                        .map((checkIn) {
                          final data = checkIn is Map<String, dynamic>
                              ? checkIn
                              : <String, dynamic>{};
                          final dateValue =
                              data['checkInDate'] ??
                              data['createdAt'] ??
                              data['created_at'];
                          final date = DateTime.tryParse(
                            dateValue?.toString() ?? '',
                          );
                          final note = (data['reason'] ?? '').toString().trim();
                          final status = (data['status'] ?? '').toString();
                          final statusLabel = switch (status.toLowerCase()) {
                            'yes' => 'Oui',
                            'partially' => 'En partie',
                            'no' => 'Non',
                            _ => status,
                          };
                          final lines = [
                            if (date != null) _formatDate(date),
                            if (statusLabel.isNotEmpty) statusLabel,
                            if (note.isNotEmpty) note,
                          ];
                          return lines.join(' — ');
                        })
                        .join('\n'),
              trailing: IconButton(
                icon: const Icon(
                  Icons.fact_check_outlined,
                  color: AppTheme.primary,
                ),

                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MODIFIER LE CAP
  // ============================================================

  void _showEditGoalDialog(BuildContext context, GoalProvider provider) {
    final controller = TextEditingController(
      text: provider.targetWeight?.toStringAsFixed(1) ?? '',
    );

    final motivationController = TextEditingController(
      text: provider.motivation,
    );

    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Modifier mon cap'),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                TextField(
                  controller: controller,

                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),

                  decoration: const InputDecoration(
                    labelText: 'Poids objectif',
                    suffixText: 'kg',
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: motivationController,

                  maxLines: 3,

                  decoration: const InputDecoration(labelText: 'Ma motivation'),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text('Annuler'),
            ),

            ElevatedButton(
              onPressed: () async {
                final target = double.tryParse(
                  controller.text.replaceAll(',', '.'),
                );

                if (target == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veuillez saisir un poids valide.'),
                    ),
                  );

                  return;
                }

                final user = context.read<UserProvider>().currentUser;
                final mainGoal = provider.mainGoal;
                if (user == null || mainGoal == null || mainGoal.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Objectif utilisateur introuvable.'),
                    ),
                  );
                  return;
                }

                final updated = await provider.updateGoal(
                  userId: user.id,
                  mainGoal: mainGoal,
                  targetWeight: target,
                  motivation: motivationController.text.trim(),
                );

                if (!context.mounted) return;
                if (!updated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        provider.error ?? 'Mise à jour impossible.',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);
              },

              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

// ================================================================
// GRAPHIQUE DU POIDS
// ================================================================

class _WeightChart extends StatelessWidget {
  final List records;

  const _WeightChart({required this.records});

  @override
  Widget build(BuildContext context) {
    // Aucun enregistrement
    if (records.isEmpty) {
      return Container(
        height: 230,

        width: double.infinity,

        decoration: BoxDecoration(
          color: AppTheme.white,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(color: AppTheme.border),
        ),

        child: const Center(
          child: Text(
            'Pas encore suffisamment de données.',
            style: TextStyle(color: AppTheme.textMedium),
          ),
        ),
      );
    }

    // Récupération des poids
    final weights = records
        .map<double>((record) => record.weight as double)
        .toList();

    final minWeight = weights.reduce((a, b) => a < b ? a : b);

    final maxWeight = weights.reduce((a, b) => a > b ? a : b);

    return Container(
      height: 260,

      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppTheme.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: AppTheme.border),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Évolution du poids',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: CustomPaint(
              painter: _WeightChartPainter(
                weights: weights,
                minWeight: minWeight,
                maxWeight: maxWeight,
              ),

              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// PAINTER DU GRAPHIQUE
// ================================================================

class _WeightChartPainter extends CustomPainter {
  final List<double> weights;

  final double minWeight;

  final double maxWeight;

  _WeightChartPainter({
    required this.weights,
    required this.minWeight,
    required this.maxWeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (weights.isEmpty) {
      return;
    }

    final linePaint = Paint()
      ..color = AppTheme.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()
      ..color = AppTheme.primary
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = AppTheme.border.withOpacity(0.5)
      ..strokeWidth = 1;

    // ==========================================================
    // LIGNES HORIZONTALES
    // ==========================================================

    for (int i = 0; i < 4; i++) {
      final y = i * (size.height / 3);

      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // ==========================================================
    // CALCUL DE L'ECART
    // ==========================================================

    final range = (maxWeight - minWeight) == 0 ? 1 : maxWeight - minWeight;

    final path = Path();

    // ==========================================================
    // DESSIN DE LA COURBE
    // ==========================================================

    for (int i = 0; i < weights.length; i++) {
      final x = weights.length == 1
          ? size.width / 2
          : i * (size.width / (weights.length - 1));

      final normalized = (weights[i] - minWeight) / range;

      final y = size.height - normalized * (size.height - 15);

      final point = Offset(x, y);

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }

      // Point
      canvas.drawCircle(point, 4, pointPaint);
    }

    // Courbe
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter oldDelegate) {
    return oldDelegate.weights != weights;
  }
}
