import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/wells/pillar_photo_preview_page.dart';


class PillarPhotoPage extends StatefulWidget {
  final int taskID;
  final int wellID;
  final List<CameraDescription>? cameras;

  const PillarPhotoPage(
    {Key? key, required this.cameras, required this.taskID, required this.wellID}) : super(key:key);

  @override
  PillarPhotoPageState createState() => PillarPhotoPageState();
}

class PillarPhotoPageState extends State<PillarPhotoPage> {
  late CameraController _cameraController;
  bool _isRearCameraSelected = true;

  @override
  void initState() {
    super.initState();

    initCamera(widget.cameras![0]);
  }

  Future initCamera(CameraDescription cameraDescription) async {
    // create a CameraController
    _cameraController = CameraController(
      cameraDescription, ResolutionPreset.high);
    // Next, initialize the controller. This returns a Future.
    try {
      await _cameraController.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("Ошибка $e");
    }
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {return null;}
    if (_cameraController.value.isTakingPicture) {return null;}
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      Navigator.push(context, MaterialPageRoute(
                    builder: (context) => PillarPhotoPreviewPage(
                          picture: picture,
                          taskID: widget.taskID,
                          wellID: widget.wellID,
                        )));
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        (_cameraController.value.isInitialized)
            ? CameraPreview(_cameraController)
            : Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator())),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  color: Colors.black),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                    child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 30,
                  icon: Icon(
                      _isRearCameraSelected
                          ? CupertinoIcons.switch_camera
                          : CupertinoIcons.switch_camera_solid,
                      color: Colors.white),
                  onPressed: () {
                    setState(
                        () => _isRearCameraSelected = !_isRearCameraSelected);
                    initCamera(widget.cameras![_isRearCameraSelected ? 0 : 1]);
                  },
                )),
                Expanded(
                    child: IconButton(
                  onPressed: takePicture,
                  iconSize: 50,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.circle, color: Colors.white),
                )),
                const Spacer(),
              ]),
            )),
      ]),
    ));
  }
}