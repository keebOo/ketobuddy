import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/models/keto_score.dart';

class ScoreGaugeWidget extends StatelessWidget {
  final KetoScore score;
  final double size;

  const ScoreGaugeWidget({super.key, required this.score, this.size = 160});

  @override
  Widget build(BuildContext context) {
    if (!score.hasEnoughData) {
      return SizedBox(
        width: size,
        height: size,
        child: const Center(
          child: Icon(Icons.help_outline, size: 48, color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GaugePainter(score.score),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${score.score}',
                style: TextStyle(
                  fontSize: size * 0.25,
                  fontWeight: FontWeight.bold,
                  color: _scoreColor(score.score),
                ),
              ),
              Text(
                '/100',
                style: TextStyle(
                  fontSize: size * 0.1,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _scoreColor(int score) {
    if (score >= 75) return const Color(0xFF2E7D32);
    if (score >= 50) return const Color(0xFF7CB342);
    if (score >= 25) return const Color(0xFFEF6C00);
    return const Color(0xFFC62828);
  }
}

class _GaugePainter extends CustomPainter {
  final int score;

  _GaugePainter(this.score);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const startAngle = pi * 0.75;
    const sweepAngle = pi * 1.5;

    final trackPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    final scoreFraction = score / 100.0;
    final scorePaint = Paint()
      ..color = _scoreColor(score)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * scoreFraction,
      false,
      scorePaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.score != score;

  Color _scoreColor(int score) {
    if (score >= 75) return const Color(0xFF2E7D32);
    if (score >= 50) return const Color(0xFF7CB342);
    if (score >= 25) return const Color(0xFFEF6C00);
    return const Color(0xFFC62828);
  }
}
