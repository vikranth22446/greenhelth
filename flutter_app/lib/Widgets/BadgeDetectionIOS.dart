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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Face Detection Sample')),
        body: Container(
          child: ARKitSceneView(
            configuration: ARKitConfiguration.faceTracking,
            onARKitViewCreated: onARKitViewCreated,
          ),
        ),
      );

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
    this.arkitController.onUpdateNodeForAnchor = _handleUpdateAnchor;

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
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitFaceAnchor)) {
      return;
    }

    setState(() {
      frameLastDetected = frameNumber;
    });
    handleNewFace();

    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.physicallyBased,
      diffuse: ARKitMaterialProperty.color(Colors.grey),
    );
    anchor.geometry.materials.value = [material];

    setState(() {
      node = ARKitNode(name: "face node", geometry: anchor.geometry);
      nameNode = drawText("Loading", node!.position);
    });

    arkitController.add(node!, parentNodeName: anchor.nodeName);
    arkitController.add(nameNode!, parentNodeName: anchor.nodeName);
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
        arkitController.update(
          nameNode!.name,
          materials: [
            ARKitMaterial(
              diffuse: ARKitMaterialProperty.color(Colors.black),
            ),
          ],
        );
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
        arkitController.update(
          nameNode!.name,
          materials: [
            ARKitMaterial(
              diffuse: ARKitMaterialProperty.color(Colors.black),
            ),
          ],
        );
      }
      arkitController.updateFaceGeometry(node!, anchor.identifier);
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
