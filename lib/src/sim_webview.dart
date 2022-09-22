import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:wakelock/wakelock.dart';

class SimpleWebview extends StatefulWidget {
  String? title;
  String? url;
  Map<String, String>? header;
  Widget? appBar;
  bool isRefresh;

  SimpleWebview({this.title, this.url, this.header, this.appBar, this.isRefresh = false});
  @override
  _SimpleWebviewState createState() => _SimpleWebviewState();
}

class _SimpleWebviewState extends State<SimpleWebview> {
  bool finish = false;

  WebViewController? flutterWebviewPlugin;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();

    print("Normal -->");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
        actions: [
          widget.isRefresh ? IconButton(onPressed: () {}, icon: Icon(Icons.refresh)) : Container()
        ],
      ),
      body: Column(
        children: [
          progress > 0 && progress < 1 || progress == 0
              ? LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  color: Colors.teal)
              : Container(),
          Expanded(
            child: WebView(
              initialUrl: widget.url,
              zoomEnabled: false,
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: Set.from([
                JavascriptChannel(
                    name: 'jsfunc1',
                    onMessageReceived: (JavascriptMessage message) async {
                      String jsMessage = message.message;
                      print(jsMessage);

                      // print(jsMessage.toString() + " Message ====>");

                      if (message.message == "success") {
                        Navigator.of(context).pop(true);
                      } else if (message.message == 'fail') {
                        Navigator.of(context).pop();
                      }
                    }),
              ]),
              onProgress: (progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
              onWebViewCreated: (WebViewController con) {
                flutterWebviewPlugin = con;
                if (widget.header != null) {
                  con.loadUrl(widget.url!, headers: widget.header);
                } else {
                  con.loadUrl(widget.url!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Wakelock.disable();

    super.dispose();
  }
}

//"${BASE_WEB_URL}/webview/wholesale/order/${widget.orInfoData.orderNumber}"
