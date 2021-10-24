import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';

class BadgeDetectionAndroid extends StatefulWidget {
  @override
  _BadgeDetectionAndroidState createState() => _BadgeDetectionAndroidState();
}

class _BadgeDetectionAndroidState extends State<BadgeDetectionAndroid> {
  ArCoreFaceController arCoreFaceController =  new ArCoreFaceController();

  @override
  Widget build(BuildContext context) {
    return ArCoreFaceView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enableAugmentedFaces: true,
    );
  }

  void _onArCoreViewCreated(ArCoreFaceController controller) {
    arCoreFaceController = controller;
    loadMesh();

  }

  loadMesh() async {
    final ByteData textureBytes =
    await rootBundle.load('assets/Textures/green_logo_mesh_texture.png');

    arCoreFaceController.loadMesh(
        textureBytes: textureBytes.buffer.asUint8List(),
        skin3DModelFilename: 'green_logo.sfb');
  }

  @override
  void dispose() {
    arCoreFaceController.dispose();
    super.dispose();
  }
}