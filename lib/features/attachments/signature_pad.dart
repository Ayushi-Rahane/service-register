import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Opens a full-screen signature pad. Returns PNG bytes, or null.
Future<Uint8List?> captureSignature(BuildContext context) =>
    Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const _SignatureScreen(),
      ),
    );

class _SignatureScreen extends StatefulWidget {
  const _SignatureScreen();
  @override
  State<_SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<_SignatureScreen> {
  final _strokes = <List<Offset>>[];
  Size _size = Size.zero;

  Future<Uint8List?> _export() async {
    if (_strokes.isEmpty || _size.isEmpty) return null;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRect(Offset.zero & _size, Paint()..color = Colors.white);
    _SignaturePainter(_strokes, Colors.black).paint(canvas, _size);
    final image = await recorder.endRecording().toImage(
      _size.width.ceil(),
      _size.height.ceil(),
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Customer signature'),
      actions: [
        TextButton(
          onPressed: () => setState(_strokes.clear),
          child: const Text('Clear'),
        ),
      ],
    ),
    body: Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(Gap.lg),
          child: Text('Ask the customer to sign inside the box with a finger.'),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Gap.lg),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: context.colors.outline),
                borderRadius: BorderRadius.circular(12),
              ),
              child: LayoutBuilder(
                builder: (context, c) {
                  _size = Size(c.maxWidth, c.maxHeight);
                  return GestureDetector(
                    onPanStart: (d) =>
                        setState(() => _strokes.add([d.localPosition])),
                    onPanUpdate: (d) =>
                        setState(() => _strokes.last.add(d.localPosition)),
                    child: CustomPaint(
                      painter: _SignaturePainter(_strokes, Colors.black),
                      size: _size,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(Gap.lg),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  final png = await _export();
                  if (context.mounted) Navigator.pop(context, png);
                },
                icon: const Icon(Icons.check),
                label: const Text('Use this signature'),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _SignaturePainter extends CustomPainter {
  _SignaturePainter(this.strokes, this.color);
  final List<List<Offset>> strokes;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (final s in strokes) {
      if (s.length == 1) {
        canvas.drawCircle(s.first, 1.5, paint..style = PaintingStyle.fill);
        paint.style = PaintingStyle.stroke;
        continue;
      }
      final path = Path()..moveTo(s.first.dx, s.first.dy);
      for (final p in s.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
