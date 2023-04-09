import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class PillarPhotoPreviewPage extends StatefulWidget {
  final int taskID;
  final int wellID;
  final XFile picture;

  PillarPhotoPreviewPage({required this.picture, required this.taskID, required this.wellID});

  @override
  PillarPhotoPreviewPageState createState() => PillarPhotoPreviewPageState();
}

class PillarPhotoPreviewPageState extends State<PillarPhotoPreviewPage> {
  TextEditingController _pictureNameController = TextEditingController();
  late File _file;
  bool isLoading = false;
  final themeColor = new Color(0xfff5a623);

  @override
  void initState() {
    super.initState();

    setState(() {
      _pictureNameController.text = widget.picture.name;
    });
  }

  Future<void> getFileFromXFile() async {
    setState(() {
      _file = File(widget.picture.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var savePhotoBtn = SizedBox(
      width: width,
      child: Text(
        "Сохранить",
        textAlign: TextAlign.center,
      )
    );

    return FutureBuilder(
      future: getFileFromXFile(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: const Text('Предпросмотр фото')),
            body: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    Padding (
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Image.file(
                        File(widget.picture.path), 
                        fit: BoxFit.cover, width: 250
                      ),
                    ),
                    const SizedBox(
                      height: 24
                    ),
                    Padding (
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: TextField(
                        controller: _pictureNameController
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: savePhotoBtn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () async {
                          // Directory? documentsDirectory = await getExternalStorageDirectory();
                          // print("MMMMMMMMM: ${documentsDirectory.path+'/'+'geology'}");
                          // new Directory('geology').create(recursive: true)
                          // // The created directory is returned as a Future.
                          // .then((Directory directory) {
                          //   print('Path of New Dir: '+directory.path);
                          // });
                          // widget.picture.saveTo('geology');
                          final dir = Directory((Platform.isAndroid
                            ? await getApplicationDocumentsDirectory() //FOR ANDROID
                            : await getApplicationSupportDirectory() //FOR IOS
                          )!.path + '/geology');
                          var status = await Permission.storage.status;
                          if (!status.isGranted) {
                            await Permission.storage.request();
                          }
                          if ((await dir.exists())) {} 
                          else {
                            dir.create(recursive: true);
                          }

                          var created = _file!.copy("${dir.path}/${widget.picture.name}");
                          setState(() {
                            isLoading = true;
                          });
                          created.then((value) => 
                            setState(() {
                              isLoading = false;
                            })
                          );
                        },
                      ),
                    ),
                    Positioned(
                      child: isLoading ? 
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ) :
                      Container(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        else {
          return CircularProgressIndicator();
        }
      }
    );
  }
}
