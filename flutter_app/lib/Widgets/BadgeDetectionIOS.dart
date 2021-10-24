import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:green_helth/Models/Student.dart';
import 'package:green_helth/Services/FaceRecognitionApi.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class BadgeDetectionIOS extends StatefulWidget {
  @override
  _BadgeDetectionIOSState createState() => _BadgeDetectionIOSState();
}

class _BadgeDetectionIOSState extends State<BadgeDetectionIOS> {
  late ARKitController arkitController;
  ARKitNode? node;
  ARKitNode? nameNode;

  bool isLoading = false;
  late Student currentStudent;
  int frameNumber = 0;
  int frameLastDetected = -5000;

  Map<BadgeLevel, Color> badgeColors = {
    BadgeLevel.GreenBadge: Color.fromRGBO(11, 192, 127, 1),
    BadgeLevel.YellowBadge: Color.fromRGBO(245, 224, 34, 1),
    BadgeLevel.RedBadge: Color.fromRGBO(242, 48, 118, 1),
  };

  @override
  void dispose() async {
    arkitController.dispose();
    super.dispose();
  }

  @override
<<<<<<< HEAD
  Widget build(BuildContext context) { 
    print("we made it");
    return Scaffold(
    appBar: AppBar(title: const Text('Face Detection Sample')),
    body: Container(
      child: ARKitSceneView(
        configuration: ARKitConfiguration.faceTracking,
        onARKitViewCreated: onARKitViewCreated,
      ),
    ),
  ); 
  }
=======
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Face Detection Sample')),
        body: Container(
          child: ARKitSceneView(
            configuration: ARKitConfiguration.faceTracking,
            onARKitViewCreated: onARKitViewCreated,
          ),
        ),
      );
>>>>>>> 0214e474857b5bae596fa1d08c9c6d6ab6c3b098

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
    this.arkitController.onUpdateNodeForAnchor = _handleUpdateAnchor;
<<<<<<< HEAD
    this.arkitController.updateAtTime = (time) { print("at a time"); };
=======

    this.arkitController.updateAtTime = (time) {
      if ((frameNumber - frameLastDetected).abs() > 10) {
        // no face detected
        setState(() {
          frameLastDetected = -5000;
        });
      }
      setState(() {
        frameNumber = (frameNumber + 1) % 1000000;
      });
    };
>>>>>>> 0214e474857b5bae596fa1d08c9c6d6ab6c3b098
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitFaceAnchor)) {
      return;
    }
<<<<<<< HEAD

    print("here");

    final material = ARKitMaterial(fillMode: ARKitFillMode.lines);
    anchor.geometry.materials.value = [material];

    node = ARKitNode(geometry: anchor.geometry);
    arkitController.add(node!, parentNodeName: anchor.nodeName);
=======
>>>>>>> 0214e474857b5bae596fa1d08c9c6d6ab6c3b098

    setState(() {
      frameLastDetected = frameNumber;
    });
    handleNewFace();

    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.physicallyBased,
      diffuse: ARKitMaterialProperty.color(Colors.grey),
    );
    anchor.geometry.materials.value = [material];

    node = ARKitNode(name: "face node", geometry: anchor.geometry);
    nameNode = drawText("Loading", node!.position);

    arkitController.add(nameNode!, parentNodeName: anchor.nodeName);
    arkitController.add(node!, parentNodeName: anchor.nodeName);
  }

  void _handleUpdateAnchor(ARKitAnchor anchor) {
    if (anchor is ARKitFaceAnchor && mounted) {
      if (frameLastDetected < 0) {
        // new face
        handleNewFace();
      }
      setState(() {
        frameLastDetected = frameNumber;
      });

      if (isLoading) {
        arkitController.update(
          node!.name,
          materials: [
            ARKitMaterial(
              lightingModelName: ARKitLightingModel.physicallyBased,
              diffuse: ARKitMaterialProperty.color(Colors.grey),
            ),
          ],
        );
        nameNode!.position = node!.position;
      } else {
        arkitController.update(
          node!.name,
          materials: [
            ARKitMaterial(
              lightingModelName: ARKitLightingModel.physicallyBased,
              diffuse: ARKitMaterialProperty.color(
                  badgeColors[currentStudent.badgeLevel]!),
            ),
          ],
        );
        nameNode!.position = node!.position;
      }
      arkitController.updateFaceGeometry(node!, anchor.identifier);
<<<<<<< HEAD
      _updateEye(leftEye!, faceAnchor.leftEyeTransform,
          faceAnchor.blendShapes['eyeBlink_L'] ?? 0);
      _updateEye(rightEye!, faceAnchor.rightEyeTransform,
          faceAnchor.blendShapes['eyeBlink_R'] ?? 0);

      print("ohhhhh there");
=======
>>>>>>> 0214e474857b5bae596fa1d08c9c6d6ab6c3b098
    }
  }

  void handleNewFace() async {
    print("new face!");
    setState(() {
      isLoading = true;
    });

    var image = await arkitController.snapshot();
    Student receivedStudent = await FaceRecognitionApi.recognizeFace(image);

    setState(() {
      currentStudent = receivedStudent;
      isLoading = false;
    });
  }

  ARKitNode drawText(String text, vector.Vector3 point) {
    final textGeometry = ARKitText(
      text: text,
      extrusionDepth: 1,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty.color(Colors.black),
        )
      ],
    );
    const scale = 0.001;
    final vectorScale = vector.Vector3(scale, scale, scale);
    final textNode = ARKitNode(
      name: "name node",
      geometry: textGeometry,
      position: point,
      scale: vectorScale,
    );

    return textNode;
  }

}
