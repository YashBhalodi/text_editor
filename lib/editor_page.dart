import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert'; // access to jsonEncode()
import 'dart:io';
import 'package:text_edior/editor_image.dart';

class EditorPage extends StatefulWidget {
    @override
    EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
    /// Allows to control the editor and the document.
    ZefyrController _controller;

    /// Zefyr editor like any other input field requires a focus node.
    FocusNode _focusNode;

    @override
    void initState() {
        super.initState();
        _focusNode = FocusNode();
        _loadDocument().then((document) {
            setState(() {
                _controller = ZefyrController(document);
            });
        });
    }

    @override
    Widget build(BuildContext context) {

        final Widget body = (_controller == null)
                            ? Center(child: CircularProgressIndicator())
                            : ZefyrScaffold(
            child: ZefyrEditor(
                padding: EdgeInsets.all(16),
                controller: _controller,
                focusNode: _focusNode,
            ),
        );

        // Note that the editor requires special `ZefyrScaffold` widget to be
        // one of its parents.
        return Scaffold(
            appBar: AppBar(title: Text("Editor page"),
                actions: <Widget>[
                    Builder(
                        builder: (context) => IconButton(
                            icon: Icon(Icons.save),
                            onPressed: () => _saveDocument(context),
                        ),
                    )
                ],
            ),
            body: body,
        );
    }

    /// Loads the document to be edited in Zefyr.
    Future<NotusDocument> _loadDocument() async {
        final file = File(Directory.systemTemp.path + "/quick_start.json");
        if (await file.exists()) {
            final contents = await file.readAsString();
            return NotusDocument.fromJson(jsonDecode(contents));
        }
        final Delta delta = Delta()..insert("Zefyr Quick Start\n");
        return NotusDocument.fromDelta(delta);
    }

    void _saveDocument(BuildContext context) {
        // Notus documents can be easily serialized to JSON by passing to
        // `jsonEncode` directly
        final contents = jsonEncode(_controller.document);
        // For this example we save our document to a temporary file.
        final file = File(Directory.systemTemp.path + "/quick_start.json");
        // And show a snack bar on success.
        file.writeAsString(contents).then((_) {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Saved.")));
        });
        print(contents);
    }
}