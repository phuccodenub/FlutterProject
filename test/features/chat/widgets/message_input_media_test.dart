import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lms_mobile_flutter/features/chat/widgets/message_input.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: Center(child: child)));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('pick image success triggers onMediaSelected', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    File? picked;
    final fake = File('${Directory.systemTemp.path}/img_${DateTime.now().millisecondsSinceEpoch}.jpg')
      ..writeAsStringSync('x');

    await tester.pumpWidget(_wrap(MessageInput(
      controller: TextEditingController(),
      onSend: () {},
      onChanged: (_) {},
      onMediaSelected: (f) => picked = f,
      pickImageOverride: () async => fake,
    )));

    await tester.tap(find.byIcon(Icons.attach_file), warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.photo), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(picked, isNotNull);
    expect(picked!.path, equals(fake.path));
  });

  testWidgets('pick image error shows snackbar', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(_wrap(MessageInput(
      controller: TextEditingController(),
      onSend: () {},
      onChanged: (_) {},
      onMediaSelected: (_) {},
      pickImageOverride: () async => throw Exception('boom'),
    )));

    await tester.tap(find.byIcon(Icons.attach_file), warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hình ảnh'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('pick file success', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    File? picked;
    final fake = File('${Directory.systemTemp.path}/doc_${DateTime.now().millisecondsSinceEpoch}.txt')
      ..writeAsStringSync('x');

    await tester.pumpWidget(_wrap(MessageInput(
      controller: TextEditingController(),
      onSend: () {},
      onChanged: (_) {},
      onMediaSelected: (f) => picked = f,
      pickFileOverride: () async => fake,
    )));

    await tester.tap(find.byIcon(Icons.attach_file), warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.insert_drive_file), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(picked, isNotNull);
    expect(picked!.path, equals(fake.path));
  });

  testWidgets('pick video success', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    File? picked;
    final fake = File('${Directory.systemTemp.path}/vid_${DateTime.now().millisecondsSinceEpoch}.mp4')
      ..writeAsStringSync('x');

    await tester.pumpWidget(_wrap(MessageInput(
      controller: TextEditingController(),
      onSend: () {},
      onChanged: (_) {},
      onMediaSelected: (f) => picked = f,
      pickVideoOverride: () async => fake,
    )));

    await tester.tap(find.byIcon(Icons.attach_file), warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.videocam), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(picked, isNotNull);
    expect(picked!.path, equals(fake.path));
  });

  testWidgets('take photo success', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    File? picked;
    final fake = File('${Directory.systemTemp.path}/cam_${DateTime.now().millisecondsSinceEpoch}.jpg')
      ..writeAsStringSync('x');

    await tester.pumpWidget(_wrap(MessageInput(
      controller: TextEditingController(),
      onSend: () {},
      onChanged: (_) {},
      onMediaSelected: (f) => picked = f,
      takePhotoOverride: () async => fake,
    )));

    await tester.tap(find.byIcon(Icons.attach_file), warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.camera_alt), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(picked, isNotNull);
    expect(picked!.path, equals(fake.path));
  });

  testWidgets('audio record start/stop sends file', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    File? picked;
    final fake = File('${Directory.systemTemp.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a')
      ..writeAsStringSync('x');

    await tester.pumpWidget(_wrap(MessageInput(
      controller: TextEditingController(),
      onSend: () {},
      onChanged: (_) {},
      onMediaSelected: (f) => picked = f,
      startRecordingOverride: () async {},
      stopRecordingOverride: ({bool send = true}) async => fake,
    )));

    await tester.tap(find.byIcon(Icons.mic), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.byIcon(Icons.stop), warnIfMissed: false);
    await tester.pump();

    expect(picked, isNotNull);
    expect(picked!.path, equals(fake.path));
  });
}

