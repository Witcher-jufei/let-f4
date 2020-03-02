import 'dart:io';

import 'package:Bidder/common/bidder_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PersonalView extends StatefulWidget {
  // 请求数据
  dynamic info;
  PersonalView({Key key, this.info}) : super(key: key);
  @override
  _PersonalViewState createState() => _PersonalViewState();
}

class _PersonalViewState extends State<PersonalView> {
  File imageFile;
  
  var _vnameController = TextEditingController();

  var _imgPath = '';

  void _editUserName() async {
    if (_vnameController.text == widget.info['name']) return;
    // 发送 登录 请求
    var res = await Api.getInstance().editUserName(_vnameController.text);
    print(res);
    var code = res["code"] as String;
    if (code == "200") {
      Fluttertoast.showToast(msg: '修改成功');
    }
  }

  void _uploadHeader(String _filepath) async {
    setState(() {
        _imgPath = _filepath;
      });
    // 发送 登录 请求
    var res = await Api.getInstance().uploadHeader(_filepath);
    print(res);
    var code = res["code"] as String;
    if (code == "200") {
      imageFile = null;
      setState(() {
        _imgPath = res["data"][0]['picPath'];
      });
      Navigator.pop(context);
      Fluttertoast.showToast(msg: '上传成功');
    }
  }

  Future _openModalBottomSheet() async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('拍照', textAlign: TextAlign.center),
                  onTap: () async {
                    // _takeImage();
                    _getImage();
                  },
                ),
                ListTile(
                  title: Text('从相册选择', textAlign: TextAlign.center),
                  onTap: () async {
                    // _pickImage();
                    _chooseImage();
                  },
                ),
                ListTile(
                  title: Text('取消', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, '取消');
                  },
                ),
              ],
            ),
          );
        });

    print(option);
  }

  // Future<Null> _takeImage() async {
  //   imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
  //   if (imageFile != null) {
  //     // _cropImage();
  //     _uploadHeader(imageFile);
  //   }
  // }
  ///拍摄照片
  Future _getImage() async {
    // await ImagePicker.pickImage(source: ImageSource.camera)
    //     .then((image) => _cropImage(image));
    await ImagePicker.pickImage(source: ImageSource.camera, maxWidth:800, maxHeight:800)
        .then((image) => _uploadHeader(image.path));
  }
  ///从相册选取
  Future _chooseImage() async {
    // await ImagePicker.pickImage(source: ImageSource.gallery)
    //     .then((image) => _cropImage(image));
    await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth:800, maxHeight:800)
        .then((image) => _uploadHeader(image.path));
  }

  // Future<Null> _pickImage() async {
  //   imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   if (imageFile != null) {
  //     // _cropImage();
  //     _uploadHeader(imageFile);
  //   }
  // }

  // Future<Null> _cropImage(File img) async {
  //   File croppedFile = await ImageCropper.cropImage(
  //     sourcePath: img.path
  //   );
  //   if (croppedFile != null) {
  //     _uploadHeader(croppedFile);
  //   }
  // }
  void _cropImage(File originalImage) async {
    print('裁剪');
    // File croppedFile = await ImageCropper.cropImage(
    //   sourcePath:originalImage.path,
    //   aspectRatioPresets:[
    //     CropAspectRatioPreset.square,
    //     CropAspectRatioPreset.ratio3x2,
    //     CropAspectRatioPreset.original,
    //     CropAspectRatioPreset.ratio4x3,
    //     CropAspectRatioPreset.ratio16x9
    //   ],
    //   androidUiSettings:AndroidUiSettings(
    //     toolbarTitle:'编辑图片',
    //     toolbarColor: Colors.white,
    //     toolbarWidgetColor: Colors.black,
    //     initAspectRatio: CropAspectRatioPreset.original,
    //     lockAspectRatio:false
    //     ),
    //   iosUiSettings:IOSUiSettings(
    //     minimumAspectRatio:1.0,
    //   )
    // );

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: originalImage.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      )
    );


    if (croppedFile != null) {
      _uploadHeader(croppedFile.path);
    }
  // String result = await Navigator.push(context,
  //     MaterialPageRoute(builder: (context) => CropImageRoute(originalImage)));
  // if (result == null || result.isEmpty) {
  //   print('上传失败');
  // } else {
  //   //result是图片上传后拿到的url
  //   _uploadHeader(result);
  // }
}

  @override
  void initState() {
    super.initState();
    _vnameController.text = widget.info['name'];
    _imgPath = widget.info['pic'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: HeadView(),
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Color.fromRGBO(249, 249, 249, 1),
          leading: BackButton(color: Colors.black),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "个人资料",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        // bottomNavigationBar: _buildBottomNavigationBar(),
        body: SafeArea(
          child: widget.info == null
              ? Container(
                  color: Colors.white,
                )
              : Container(
                  // color: Colors.red,
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(15),
                      right: ScreenUtil().setWidth(15)),
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: () {
                      // 触摸收起键盘
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Container(
                      // color: Colors.black,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _openModalBottomSheet();
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(20)),
                                // color: Colors.black,
                                height: ScreenUtil().setHeight(200),
                                width: ScreenUtil().setHeight(200),
                                // 圆形图片
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: _imgPath,
                                    placeholder: (context, url) =>
                                        Image.asset("images/app.png"),
                                    errorWidget: (context, url, error) =>
                                        Image.asset("images/app.png"),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(10)),
                              child: Text('点击更换'),
                            ),
                            Container(
                                // height: ScreenUtil().setHeight(125),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color.fromRGBO(211, 211, 211, 1),
                                        width: 1)),
                                height: ScreenUtil().setWidth(40),
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(40)),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(20),
                                      right: ScreenUtil().setWidth(15)),
                                  color: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Text('用户名:'),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: TextField(
                                          inputFormatters: <TextInputFormatter>[
                                            LengthLimitingTextInputFormatter(
                                                10) //限制长度
                                          ],
                                          controller: _vnameController,
                                          cursorColor: Colors.black,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '请输入用户名',
                                              hintStyle: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(12),
                                                  color: Color.fromRGBO(
                                                      168, 168, 168, 1))),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Container(
                              width: ScreenUtil().setWidth(302),
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(40)),
                              padding: EdgeInsets.only(
                                  bottom: ScreenUtil().setWidth(40)),
                              child: RaisedButton(
                                color: Color(0xFF414141),
                                child: Text(
                                  "保存",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.0),
                                ),
                                onPressed: () {
                                  _editUserName();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ));
  }
}
