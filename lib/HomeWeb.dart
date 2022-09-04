import 'dart:ui' as one;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'IosIconWeb.dart';
import 'constants/constants.dart';

const fileName = '/pspdfkit-flutter-quickstart-guide.pdf';

// URL of the PDF file you'll download.
const imageUrl = 'https://pspdfkit.com/downloads' + fileName;

class HomeWeb extends StatefulWidget {
  const HomeWeb({Key? key}) : super(key: key);

  @override
  _HomeWebState createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  bool _hasCallSupport = false;
  Future<void>? _launched;
  String _phone = '9930436814';

  // Track the progress of a downloaded file here.
  double progress = 0;

  // Track if the PDF was downloaded here.
  bool didDownloadPDF = false;

  // Show the progress status to the user.
  String progressString = 'File has not been downloaded yet.';

  // This method uses Dio to download a file from the given URL
  // and saves the file to the provided `savePath`.
  Future download(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: updateProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      // var file = File(savePath).openSync(mode: FileMode.write);
      // file.writeFromSync(response.data);
      // await file.close();

      // Here, you're catching an error and printing it. For production
      // apps, you should display the warning to the user and give them a
      // way to restart the download.
    } catch (e) {
      print(e);
    }
  }

  // You can update the download progress here so that the user is
  // aware of the long-running task.
  void updateProgress(done, total) {
    progress = done / total;
    setState(() {
      if (progress >= 1) {
        progressString =
            '✅ File has finished downloading. Try opening the file.';
        didDownloadPDF = true;
      } else {
        progressString = 'Download progress: ' +
            (progress * 100).toStringAsFixed(0) +
            '% done.';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Check for phone call support.
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchInWebViewWithoutJavaScript(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
    )) {
      throw 'Could not launch $url';
    }
  }

  // Future<void> _launchInWebViewWithoutDomStorage(Uri url) async {
  //   if (!await launchUrl(
  //     url,
  //     mode: LaunchMode.inAppWebView,
  //     webViewConfiguration: const WebViewConfiguration(enableDomStorage: false),
  //   )) {
  //     throw 'Could not launch $url';
  //   }
  // }
  //
  // Future<void> _launchUniversalLinkIos(Uri url) async {
  //   final bool nativeAppLaunchSucceeded = await launchUrl(
  //     url,
  //     mode: LaunchMode.externalNonBrowserApplication,
  //   );
  //   if (!nativeAppLaunchSucceeded) {
  //     await launchUrl(
  //       url,
  //       mode: LaunchMode.inAppWebView,
  //     );
  //   }
  // }
  //
  // Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
  //   if (snapshot.hasError) {
  //     return Text('Error: ${snapshot.error}');
  //   } else {
  //     return const Text('');
  //   }
  // }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'assets/macos-big-sur-apple-layers-fluidic-colorful-wwdc-stock-4096x2304-1455.jpg'),
                  fit: BoxFit.cover)),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: Container(
            height: MediaQuery.of(context).size.height * 0.18,
            margin: EdgeInsets.symmetric(
              vertical: 25,
              horizontal: MediaQuery.of(context).size.width > 1066
                  ? MediaQuery.of(context).size.width * 0.15
                  : MediaQuery.of(context).size.width * 0.12,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: one.ImageFilter.blur(
                  sigmaX: 15.0,
                  sigmaY: 15.0,
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  color: Colors.white.withOpacity(0.45),
                  child: MediaQuery.of(context).size.width > 1500
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () => showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: const Text("Call Shahid"),
                                    content: const Text(
                                        "Are you sure you want to call Shahid Siddiqui ?"),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text("YES"),
                                        onPressed: _hasCallSupport
                                            ? () => setState(() {
                                                  _launched =
                                                      _makePhoneCall(_phone);
                                                })
                                            : null,
                                      ),
                                      CupertinoDialogAction(
                                        child: const Text("NO"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                },
                              ),
                              child: Image.asset('assets/apple-phone.png',
                                  scale: 1.8),
                            ),
                            InkWell(
                              onTap: () => showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: const Text("Open Mail"),
                                    content: const Text(
                                        "Are you sure you want to Mail Shahid Siddiqui?"),
                                    actions: [
                                      CupertinoDialogAction(
                                          child: const Text("YES"),
                                          onPressed: () {
                                            setState(() {
                                              _launched =
                                                  _launchInBrowser(toMail);
                                              Navigator.of(context).pop();
                                            });
                                          }),
                                      CupertinoDialogAction(
                                        child: const Text("NO"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                },
                              ),
                              child: Image.asset('assets/apple-mail.png',
                                  scale: 1.8),
                            ),
                            InkWell(
                              onTap: () => showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: const Text("Open Browser"),
                                    content: const Text(
                                        "Are you sure you want to visit Shahid Siddiqui's Github?"),
                                    actions: [
                                      CupertinoDialogAction(
                                          child: const Text("YES"),
                                          onPressed: () {
                                            setState(() {
                                              _launched =
                                                  _launchInBrowser(toWPMessage);
                                              Navigator.of(context).pop();
                                            });
                                          }),
                                      CupertinoDialogAction(
                                        child: const Text("NO"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                },
                              ),
                              child:
                                  Image.asset('assets/safari.png', scale: 1.8),
                            ),
                            Image.asset('assets/app-store.png', scale: 1.8),
                            Image.asset('assets/apple-music.png', scale: 1.8),
                            Image.asset('assets/contacts.png', scale: 1.8),
                            Image.asset('assets/facetime.png', scale: 1.8),
                            Image.asset('assets/ios-message.png', scale: 1.8)
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: const Text("Call Shaid"),
                                    content: const Text(
                                        "Are you sure you want to call Shahid Siddiqui?"),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text("YES"),
                                        onPressed: _hasCallSupport
                                            ? () => setState(() {
                                                  _launched =
                                                      _makePhoneCall(_phone);
                                                })
                                            : null,
                                      ),
                                      CupertinoDialogAction(
                                        child: const Text("NO"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                },
                              ),
                              child: Image.asset(
                                'assets/apple-phone.png',
                                scale: 1.6,
                              ),
                            ),
                            InkWell(
                              onTap: () => showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: const Text("Open Mail"),
                                    content: const Text(
                                        "Are you sure you want to Mail Shahid Siddiqui?"),
                                    actions: [
                                      CupertinoDialogAction(
                                          child: const Text("YES"),
                                          onPressed: () {
                                            setState(() {
                                              _launched =
                                                  _launchInBrowser(toMail);
                                              Navigator.of(context).pop();
                                            });
                                          }),
                                      CupertinoDialogAction(
                                        child: const Text("NO"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                },
                              ),
                              child: Image.asset(
                                'assets/apple-mail.png',
                                scale: 1.6,
                              ),
                            ),
                            InkWell(
                              onTap: () => showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: const Text("Open Browser"),
                                    content: const Text(
                                        "Are you sure you want to visit Shahid Siddiqui's Github?"),
                                    actions: [
                                      CupertinoDialogAction(
                                          child: const Text("YES"),
                                          onPressed: () {
                                            setState(() {
                                              _launched =
                                                  _launchInBrowser(toLaunchGit);
                                              Navigator.of(context).pop();
                                            });
                                          }),
                                      CupertinoDialogAction(
                                        child: const Text("NO"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                },
                              ),
                              child: Image.asset(
                                'assets/safari.png',
                                scale: 1.8,
                              ),
                            ),
                            InkWell(
                                child: Image.asset(
                              'assets/apple-music.png',
                              scale: 1.8,
                            )),
                            InkWell(
                                child: Image.asset(
                              'assets/facetime.png',
                              scale: 1.8,
                            )),
                            InkWell(
                                child: Image.asset(
                              'assets/ios-message.png',
                              scale: 1.8,
                            ))
                          ],
                        ),
                ),
              ),
            ),
          ),
          body: Container(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height < 700
                      ? MediaQuery.of(context).size.height * 0.25
                      : MediaQuery.of(context).size.height * 0.29,
                  padding: const EdgeInsets.all(24),
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width > 1066
                          ? MediaQuery.of(context).size.width * 0.1
                          : MediaQuery.of(context).size.width * 0.12,
                      vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IosIconWeb(
                        Name: 'App Store',
                        IconsNames: 'assets/app-store.png',
                      ),
                      InkWell(
                        onTap: () => showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text("Open Shahid's Resume"),
                              content: const Text(
                                  "Are you sure you want to visit Shahid Siddiqui's Resume?"),
                              actions: [
                                CupertinoDialogAction(
                                    child: const Text("YES"),
                                    onPressed: () {
                                      setState(() {
                                        _launched =
                                            _launchInBrowser(toLaunchResume);
                                        Navigator.of(context).pop();
                                      });
                                    }),
                                CupertinoDialogAction(
                                  child: const Text("NO"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          },
                        ),
                        child: IosIconWeb(
                          Name: 'Resume',
                          IconsNames: 'assets/apple-notes.png',
                        ),
                      ),
                      IosIconWeb(
                        Name: 'Clock',
                        IconsNames: 'assets/apple-clock.png',
                      ),
                      IosIconWeb(
                        Name: 'Music',
                        IconsNames: 'assets/apple-camera.png',
                      ),
                      InkWell(
                        onTap: () => showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text("Open Shahid's Certificate"),
                              content: const Text(
                                  "Are you sure you want to See Shahid Siddiqui's Internship Certificates?"),
                              actions: [
                                CupertinoDialogAction(
                                    child: const Text("YES"),
                                    onPressed: () {
                                      setState(() {
                                        _launched = _launchInBrowser(
                                            toLaunchCertificate);
                                        Navigator.of(context).pop();
                                      });
                                    }),
                                CupertinoDialogAction(
                                  child: const Text("NO"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          },
                        ),
                        child: IosIconWeb(
                          Name: 'Certificate',
                          IconsNames: 'assets/contacts.png',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height < 700
                      ? MediaQuery.of(context).size.height * 0.25
                      : MediaQuery.of(context).size.height * 0.29,
                  padding: const EdgeInsets.all(24),
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width > 1066
                          ? MediaQuery.of(context).size.width * 0.1
                          : MediaQuery.of(context).size.width * 0.12,
                      vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text("Open WhatsApp"),
                              content: const Text(
                                  "Are you sure you want to Send Shahid Siddiqui a WhatsApp message?"),
                              actions: [
                                CupertinoDialogAction(
                                    child: const Text("YES"),
                                    onPressed: () {
                                      setState(() {
                                        _launched =
                                            _launchInBrowser(toWPMessage);
                                        Navigator.of(context).pop();
                                      });
                                    }),
                                CupertinoDialogAction(
                                  child: const Text("NO"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          },
                        ),
                        child: IosIconWeb(
                          Name: 'Whatsapp',
                          IconsNames: 'assets/whatsapp.png',
                        ),
                      ),
                      InkWell(
                        onTap: () => showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text("Open Instagram"),
                              content: const Text(
                                  "Are you sure you want to visit Shahid Siddiqui's Instagram?"),
                              actions: [
                                CupertinoDialogAction(
                                    child: const Text("YES"),
                                    onPressed: () {
                                      setState(() {
                                        _launched =
                                            _launchInBrowser(toLaunchInsta);
                                        Navigator.of(context).pop();
                                      });
                                    }),
                                CupertinoDialogAction(
                                  child: const Text("NO"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          },
                        ),
                        child: IosIconWeb(
                          Name: 'Instagram',
                          IconsNames: 'assets/instagram.png',
                        ),
                      ),
                      InkWell(
                        onTap: () => showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text("Open Linkedin"),
                              content: const Text(
                                  "Are you sure you want to visit Shahid Siddiqui's Linkedin?"),
                              actions: [
                                CupertinoDialogAction(
                                    child: const Text("YES"),
                                    onPressed: () {
                                      setState(() {
                                        _launched =
                                            _launchInBrowser(toLaunchLinkedin);
                                        Navigator.of(context).pop();
                                      });
                                    }),
                                CupertinoDialogAction(
                                  child: const Text("NO"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          },
                        ),
                        child: IosIconWeb(
                          Name: 'Linkedin',
                          IconsNames: 'assets/linkedin.png',
                        ),
                      ),
                      InkWell(
                        onTap: () => showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text("Open Youtube"),
                              content: const Text(
                                  "Are you sure you want to visit Shahid Siddiqui's Youtube channel?"),
                              actions: [
                                CupertinoDialogAction(
                                    child: const Text("YES"),
                                    onPressed: () {
                                      setState(() {
                                        _launched =
                                            _launchInBrowser(toLaunchYoutube);
                                        Navigator.of(context).pop();
                                      });
                                    }),
                                CupertinoDialogAction(
                                  child: const Text("NO"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          },
                        ),
                        child: IosIconWeb(
                          Name: 'Youtube',
                          IconsNames: 'assets/youtube.png',
                        ),
                      ),
                      IosIconWeb(
                        Name: 'Twitter',
                        IconsNames: 'assets/twitter.png',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
