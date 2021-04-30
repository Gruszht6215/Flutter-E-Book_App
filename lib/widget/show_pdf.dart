import 'package:cartoon_app_test/models/cartoon_model.dart';
import 'package:cartoon_app_test/utility/my_style.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ShowPdf extends StatefulWidget {
  final CartoonModel cartoonModel;

  const ShowPdf({Key key, this.cartoonModel}) : super(key: key);

  @override
  _ShowPdfState createState() => _ShowPdfState();
}

class _ShowPdfState extends State<ShowPdf> {
  CartoonModel model;
  SfPdfViewer sfPdfViewer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    model = widget.cartoonModel;
    createPDF();
  }

  Future<Null> createPDF() async {
    try {
      var result = await SfPdfViewer.network(model.pdf);
      setState(() {
        sfPdfViewer = result;
      });
    } catch (e) {
      print('e ==> ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyStyle().darkColor,
          title: Text(model.name == null ? 'Read Cartoon' : model.name),
        ),
        body: sfPdfViewer == null
            ? Center(child: CircularProgressIndicator())
            : sfPdfViewer);
  }
}
