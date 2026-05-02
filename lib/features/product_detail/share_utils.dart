import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../core/models/keto_score.dart';

Color scoreLabelToColor(ScoreLabel label) {
  switch (label) {
    case ScoreLabel.excellent:
      return const Color(0xFF2E7D32);
    case ScoreLabel.good:
      return Colors.lightGreen.shade600;
    case ScoreLabel.fair:
      return Colors.orange;
    case ScoreLabel.bad:
      return Colors.red.shade700;
    case ScoreLabel.noData:
      return Colors.grey;
  }
}

Future<Uint8List> composeShareImage({
  required ui.Image image,
  required Color badgeColor,
  required Color backgroundColor,
  required String productName,
  required double pixelRatio,
}) async {
  final w = image.width.toDouble();
  final h = image.height.toDouble();
  final headerPx = kToolbarHeight * pixelRatio;
  final totalH = h + headerPx;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, w, totalH));

  // Sfondo intero
  canvas.drawRect(
    Rect.fromLTWH(0, 0, w, totalH),
    Paint()..color = backgroundColor,
  );

  // Immagine catturata traslata sotto l'header
  canvas.drawImage(image, Offset(0, headerPx), Paint());

  // Nome prodotto nell'header, sinistra, verticalmente centrato
  final namePainter = TextPainter(
    text: TextSpan(
      text: productName,
      style: TextStyle(
        color: const Color(0xFF1A1A1A),
        fontSize: 18.0 * pixelRatio,
        fontWeight: FontWeight.w600,
      ),
    ),
    textDirection: TextDirection.ltr,
    ellipsis: '…',
    maxLines: 1,
  );
  final hPad = 16.0 * pixelRatio;
  namePainter.layout(maxWidth: w - hPad * 2);
  namePainter.paint(
    canvas,
    Offset(hPad, (headerPx - namePainter.height) / 2),
  );

  // Badge: corner in alto a destra del PNG totale
  final badgeR = w * 0.135;
  final cx = w - badgeR * 0.55;
  final cy = badgeR * 0.55;

  // Ombra
  canvas.drawPath(
    _starPath(cx, cy + badgeR * 0.08, badgeR, badgeR * 0.82, 12),
    Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, badgeR * 0.12),
  );

  // Corpo coccarda
  canvas.drawPath(
    _starPath(cx, cy, badgeR, badgeR * 0.82, 12),
    Paint()..color = badgeColor,
  );

  // Testo "Keto\nBuddy" — font ridotto
  final fontSize = badgeR * 0.30;
  final tp = TextPainter(
    text: TextSpan(
      text: 'Keto\nBuddy',
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        height: 1.15,
      ),
    ),
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.center,
  );
  tp.layout(maxWidth: badgeR * 1.4);
  tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));

  final picture = recorder.endRecording();
  final composited = await picture.toImage(w.round(), totalH.round());
  final byteData = await composited.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

Path _starPath(double cx, double cy, double outerR, double innerR, int points) {
  final path = Path();
  for (int i = 0; i < points * 2; i++) {
    final angle = (i * pi / points) - pi / 2;
    final r = i.isEven ? outerR : innerR;
    final x = cx + r * cos(angle);
    final y = cy + r * sin(angle);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  return path..close();
}
