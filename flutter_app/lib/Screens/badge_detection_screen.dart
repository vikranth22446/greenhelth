import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';

class AugmentedFacesScreen extends StatefulWidget {
  const AugmentedFacesScreen({required Key key}) : super(key: key);

  @override
  _AugmentedFacesScreenState createState() => _AugmentedFacesScreenState();
}

class _AugmentedFacesScreenState extends State<AugmentedFacesScreen> {
  ArCoreFaceController arCoreFaceController =  new ArCoreFaceController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Augmented Faces'),
        ),
        body: ArCoreFaceView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enableAugmentedFaces: true,
        ),
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreFaceController controller) {
    arCoreFaceController = controller;
    loadMesh();
  }

  loadMesh() async {
    final ByteData textureBytes =
    await rootBundle.load('assets/Textures/green_check_mesh_texture.png');

    print("Ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    arCoreFaceController.loadMesh(
        textureBytes: textureBytes.buffer.asUint8List(),
        skin3DModelFilename: 'green_check.sfb');
  }

  @override
  void dispose() {
    arCoreFaceController.dispose();
    super.dispose();
  }
}