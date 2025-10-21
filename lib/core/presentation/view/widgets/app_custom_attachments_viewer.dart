import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'dart:async';

import 'package:flutter_sound/flutter_sound.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;

import '../../../theme/app_colors.dart';
import 'app_loading_indicator.dart';

/// packages for this file are:
// # for manipulating paths: joining, splitting, normalizing, etc
/// path: ^1.9.0

/// # For youtube player
// youtube_player_flutter: ^8.1.0

// # play and record audio
/// flutter_sound: ^9.6.0
// #  view PDF documents seamlessly and efficiently in your mobile applications
/// syncfusion_flutter_pdfviewer: ^26.1.40

// # For Video Player
/// video_player: ^2.8.7

// # For video player
/// chewie: ^1.8.5

// # For Lunching URL
/// url_launcher: ^6.3.1

enum UrlType {
  image,
  memoryImage,
  youtube,
  video,
  voice,
  file,
  unknown,
}

class AppCustomAttachmentsViewer extends StatelessWidget {
  const AppCustomAttachmentsViewer({
    super.key,
    required this.multimediaLink,
  });
  final String multimediaLink;

  @override
  Widget build(BuildContext context) {
    final UrlType urlType = UrlTypeHelper.getType(multimediaLink);

    switch (urlType) {
      case UrlType.image:
        return PicturePreview(
          image: multimediaLink,
          isMemory: false,
        );
      case UrlType.memoryImage:
        return PicturePreview(
          image: multimediaLink,
          isMemory: true,
        );
      case UrlType.video:
        return VideoPreview(
          videourl: multimediaLink,
          isdownloadallowed: false,
        );
      case UrlType.voice:
        return SizedBox(
          height: 500,
          width: 200,
          child: MultiPlayback(
            isMe: false,
            audioUrl: multimediaLink,
          ),
        );
      case UrlType.file:
        return FilePreview(
          file: multimediaLink,
        );
      case UrlType.youtube:
        return YoutubePreview(
          videoUrl: multimediaLink,
          isDownloadAllowed: false,
        );
      default:
        return PicturePreview(
          image: multimediaLink,
          isMemory: false,
        );
    }
  }
}

/// IMAGE Preview Section

class PicturePreview extends StatelessWidget {
  const PicturePreview({
    super.key,
    required this.image,
    required this.isMemory,
  });

  final String image;
  final bool isMemory;
  final placeHolder = 'assets/images/image_not_found.png';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 4),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            fullscreenDialog: true,
            barrierColor: Colors.white,
            pageBuilder: (BuildContext context, _, __) {
              return FullScreenPage(
                dark: false,
                isScaleEnable: true,
                child: isMemory
                    ? Image.file(File(image))
                    : CachedNetworkImage(
                        imageUrl: image,
                        errorWidget: (context, error, stackTrace) => Image.asset(
                          placeHolder,
                          // size: 50,
                        ),
                      ),
              );
            },
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: isMemory
              ? Image.file(File(image))
              : CachedNetworkImage(
                  imageUrl: image,
                  errorWidget: (context, error, stackTrace) => const Icon(Icons.broken_image_outlined, size: 50),
                ),
        ),
      ),
    );
  }
}

class FullScreenPage extends StatefulWidget {
  const FullScreenPage({
    super.key,
    required this.child,
    required this.dark,
    required this.isScaleEnable,
  });

  final Widget child;
  final bool dark;
  final bool isScaleEnable;

  @override
  FullScreenPageState createState() => FullScreenPageState();
}

class FullScreenPageState extends State<FullScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 333),
                curve: Curves.fastOutSlowIn,
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: InteractiveViewer(
                  panEnabled: true,
                  scaleEnabled: widget.isScaleEnable,
                  minScale: 0.5,
                  maxScale: 4,
                  child: widget.child,
                ),
              ),
            ],
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: MaterialButton(
                padding: const EdgeInsets.all(15),
                elevation: 0,
                color: widget.dark ? Colors.black12 : Colors.white70,
                highlightElevation: 0,
                minWidth: double.minPositive,
                height: double.minPositive,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.close,
                  color: widget.dark ? Colors.white : Colors.black,
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///
///
///
/// [VideoPLayer Section]
///

class VideoPreview extends StatefulWidget {
  const VideoPreview({super.key, this.id, required this.videourl, required this.isdownloadallowed, this.aspectratio});
  final bool isdownloadallowed;
  final String videourl;
  final String? id;
  final double? aspectratio;

  @override
  VideoPreviewState createState() => VideoPreviewState();
}

class VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _videoPlayerController1;
  bool _isInitializing = true;
  late ChewieController _chewieController;
  bool isShowVideo = false;
  double? thisAspectRatio = 1.14;

  @override
  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.networkUrl(Uri.parse(widget.videourl));
    _videoPlayerController1.initialize().then((_) {
      setState(() {
        thisAspectRatio = widget.aspectratio;
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController1,
          allowFullScreen: true,
          showControlsOnInitialize: true,
          aspectRatio: thisAspectRatio,
          autoPlay: false,
          looping: false,
        );
        _isInitializing = false;
      });
    }).catchError((error) {
      debugPrint('Error initializing video player: $error');
    });
  }

  @override
  void dispose() {
    // if(!widget.inChat){
    try {
      _videoPlayerController1.dispose();
      _chewieController.dispose();
    } catch (_) {}

    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _isInitializing
              ? const LoadingIndicator() // Show loading indicator while initializing
              : Center(
                  child: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: SizedBox(
                    height: 500,
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  ),
                ))),
    );
  }
}

///
///
///
/// [VoicePlayer Section]
///

///
typedef Fn = void Function();

/// Example app.
class MultiPlayback extends StatefulWidget {
  // final String desc;
  // final String fileName;

  const MultiPlayback({
    super.key,
    this.audioUrl,
    // required this.fileName,
    this.isMe,
    this.onTapDownloadFn,
    // required this.desc,
  });
  final String? audioUrl;
  final bool? isMe;
  final Function? onTapDownloadFn;

  @override
  MultiPlaybackState createState() => MultiPlaybackState();
}

class MultiPlaybackState extends State<MultiPlayback> {
  FlutterSoundPlayer? _mPlayer1 = FlutterSoundPlayer(voiceProcessing: true);
  bool _mPlayer1IsInited = false;
  Uint8List? buffer1;
  String _playerTxt1 = '';

  // ignore: cancel_subscriptions
  StreamSubscription? _playerSubscription1;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    _mPlayer1!.openPlayer().then((value) {
      setState(() {
        _mPlayer1IsInited = true;
      });

      _mPlayer1!.onProgress!.listen((event) {
        final duration = event.duration;
        final date = DateTime.fromMillisecondsSinceEpoch(duration.inMilliseconds, isUtc: true);
        final txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
        setState(() {
          _playerTxt1 = txt.substring(0, 8);
        });
      });
    });
  }

  @override
  void dispose() {
    /// Be careful : you must `close` the audio session when you have finished with it.
    cancelPlayerSubscriptions1();
    _mPlayer1!.closePlayer();
    _mPlayer1 = null;

    super.dispose();
  }

  /// -------  Player1 play a remote file -----------------------
  bool showPlayingLoader = false;

  void play1() async {
    try {
      setState(() {
        showPlayingLoader = true;
      });
      await _mPlayer1!.setSubscriptionDuration(const Duration(milliseconds: 10));
      _addListener1();

      await _mPlayer1!.startPlayer(
          fromURI: widget.audioUrl,
          // fromDataBuffer: widget.audioUrl,
          codec: Codec.mp3,
          whenFinished: () {
            setState(() {});
          });
    } catch (e) {
      setState(() {
        showPlayingLoader = false;
      });
    }
  }

  void cancelPlayerSubscriptions1() {
    if (_playerSubscription1 != null) {
      _playerSubscription1!.cancel();
      _playerSubscription1 = null;
    }
  }

  Future<void> stopPlayer1() async {
    cancelPlayerSubscriptions1();
    if (_mPlayer1 != null) {
      await _mPlayer1!.stopPlayer();
    }
    setState(() {});
  }

  Future<void> pause1() async {
    if (_mPlayer1 != null) {
      await _mPlayer1!.pausePlayer();
    }
    setState(() {});
  }

  Future<void> resume1() async {
    if (_mPlayer1 != null) {
      await _mPlayer1!.resumePlayer();
    }
    setState(() {});
  }

  /// ------------------------------------------------------------------------------------

  void _addListener1() {
    cancelPlayerSubscriptions1();
    _playerSubscription1 = _mPlayer1!.onProgress!.listen((e) {
      final date = DateTime.fromMillisecondsSinceEpoch(e.position.inMilliseconds, isUtc: true);
      final txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
      setState(() {
        _playerTxt1 = txt.substring(0, 8);
        showPlayingLoader = false;
      });
    });
  }

  /// ignore: body_might_complete_normally_nullable
  Fn? getPlaybackFn1() {
    try {
      if (!_mPlayer1IsInited) {
        return null;
      }
      return _mPlayer1!.isStopped
          ? play1
          : () {
              stopPlayer1().then((value) => setState(() {}));
            };
    } catch (e) {
      setState(() {
        showPlayingLoader = false;
      });
    }
  }

  Fn? getPauseResumeFn1() {
    if (!_mPlayer1IsInited || _mPlayer1!.isStopped) {
      return null;
    }
    return _mPlayer1!.isPaused ? resume1 : pause1;
  }

  @override
  Widget build(BuildContext context) {
    Widget makeBody() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.all(10.h),
                  // padding: const EdgeInsets.fromLTRB(7, 2, 14, 7),
                  height: 60,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: AppColors.secondary,
                    border: Border.all(
                      color: Colors.blueGrey.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    showPlayingLoader == true
                        ? Padding(
                            padding: const EdgeInsets.only(top: 7, left: 12, right: 7),
                            child: SizedBox(
                              height: 29,
                              width: 29,
                              child: Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.7,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.black900),
                                ),
                              ),
                            ),
                          )
                        : IconButton(
                            onPressed: getPlaybackFn1(),
                            icon: Icon(
                              _mPlayer1!.isStopped ? Icons.play_circle_outline_outlined : Icons.stop_circle_outlined,
                              size: 40,
                              color: AppColors.black900,
                            ),
                          ),
                    const SizedBox(
                      width: 2,
                    ),
                    IconButton(
                      onPressed: getPauseResumeFn1(),
                      icon: Icon(
                        _mPlayer1!.isPaused ? Icons.play_circle_filled_sharp : Icons.pause_circle_filled,
                        size: 40,
                        color: getPauseResumeFn1() == null
                            ? widget.isMe!
                                ? Colors.green[200]
                                : AppColors.hint
                            : AppColors.black900,
                      ),
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    _playerTxt1 == ''
                        ? (widget.onTapDownloadFn != null)
                            ? Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Stack(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        widget.onTapDownloadFn!();
                                      },
                                      icon: Icon(
                                        Icons.mic_rounded,
                                        color: Colors.green[400],
                                        size: 30,
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 6,
                                        right: 0,
                                        child: Icon(
                                          Icons.download,
                                          size: 16,
                                          color: Colors.green[200],
                                        ))
                                  ],
                                ),
                              )
                            : const SizedBox()
                        : Text(
                            _playerTxt1,
                            style: TextStyle(
                              height: 1.76,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black900,
                            ),
                          ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return makeBody();
  }
}

///
/// [File Preview Section]
///

class FilePreview extends StatelessWidget {
  const FilePreview({
    super.key,
    required this.file,
  });

  final String file;

  @override
  Widget build(BuildContext context) {
    final fileUrlLower = file.toLowerCase();
    return (file.isNotEmpty)
        ? ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                if (fileUrlLower.contains('.pdf'))
                  SfPdfViewer.network(
                    file,
                    pageLayoutMode: PdfPageLayoutMode.single,
                    interactionMode: PdfInteractionMode.pan,
                    enableTextSelection: false,
                    scrollDirection: PdfScrollDirection.horizontal,
                  ),
                if (fileUrlLower.contains('.xls') || fileUrlLower.contains('.xlsx'))
                  Center(
                      child: Image.asset(
                    'assets/images/excel.png',
                    height: 50,
                    width: 50,
                  )),
                if (fileUrlLower.contains('.doc') || fileUrlLower.contains('.docx'))
                  Center(
                      child: Image.asset(
                    'assets/images/word.png',
                    height: 50,
                    width: 50,
                  )),
                if (fileUrlLower.contains('.ppt') || fileUrlLower.contains('.pptx'))
                  Center(
                      child: Image.asset(
                    'assets/images/powerpoint.png',
                    height: 50,
                    width: 50,
                  )),
                GestureDetector(
                  onTap: () async {
                    if (fileUrlLower.contains('.pdf')) {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: MediaQuery.of(context).size.height,
                                child: SfPdfViewer.network(
                                  file,
                                  interactionMode: PdfInteractionMode.pan,
                                  enableTextSelection: false,
                                )),
                          );
                        },
                      );
                    }

                    if (fileUrlLower.contains('.pdf') == false) {
                      launchUrl(Uri.parse(file));
                    }
                  },
                ),
              ],
            ))
        : const Center(child: LoadingIndicator());
  }
}

class YoutubePreview extends StatefulWidget {
  const YoutubePreview({
    super.key,
    required this.videoUrl,
    required this.isDownloadAllowed,
  });
  final bool isDownloadAllowed;
  final String videoUrl;

  @override
  YoutubePreviewState createState() => YoutubePreviewState();
}

class YoutubePreviewState extends State<YoutubePreview> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '',
      flags: const YoutubePlayerFlags(
        controlsVisibleAtStart: true,
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SizedBox(
              height: 1000, // Adjust height as needed
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                bottomActions: [
                  PlayPauseButton(controller: _controller),
                  const CurrentPosition(),
                  const ProgressBar(isExpanded: true),
                  FullScreenButton(
                    controller: _controller,
                    videoUrl: widget.videoUrl,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({super.key, required this.controller});
  final YoutubePlayerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, YoutubePlayerValue value, _) {
        return IconButton(
          icon: Icon(
            value.isPlaying ? Icons.pause : Icons.play_arrow,
            color: AppColors.secondary,
          ),
          onPressed: () {
            if (value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }
          },
        );
      },
    );
  }
}

class FullScreenButton extends StatelessWidget {
  const FullScreenButton({super.key, required this.controller, required this.videoUrl});
  final YoutubePlayerController controller;
  final String videoUrl;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        controller.value.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
        color: AppColors.secondary,
      ),
      onPressed: () {
        if (controller.value.isFullScreen) {
          // Exiting full screen mode
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
          Navigator.of(context).pop(); // Exit full-screen page
        } else {
          // Entering full screen mode
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ]);
          controller.pause();

          Navigator.push(
            context,
            PageRouteBuilder(
              opaque: false,
              barrierColor: AppColors.black900.withValues(alpha: 0.5),
              pageBuilder: (BuildContext context, _, __) {
                return FullScreenPageTwo(videoUrl: videoUrl);
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                final tween = Tween(begin: begin, end: end);
                final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
                final offsetAnimation = tween.animate(curvedAnimation);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        }
        // controller.toggleFullScreenMode();
      },
    );
  }
}

class FullScreenPageTwo extends StatefulWidget {
  const FullScreenPageTwo({super.key, required this.videoUrl});
  // late YoutubePlayerController controller;
  final String videoUrl;

  @override
  State<FullScreenPageTwo> createState() => _FullScreenPageTwoState();
}

class _FullScreenPageTwoState extends State<FullScreenPageTwo> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '',
      flags: const YoutubePlayerFlags(
        controlsVisibleAtStart: true,
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.black900,
        body: Stack(
          children: [
            Center(
              child: YoutubePlayer(
                controller: controller,
                showVideoProgressIndicator: true,
                bottomActions: [
                  PlayPauseButton(controller: controller),
                  const CurrentPosition(),
                  const ProgressBar(isExpanded: true),
                  FullScreenButton(
                    controller: controller,
                    videoUrl: widget.videoUrl,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 40,
              right: 10,
              child: MaterialButton(
                padding: const EdgeInsets.all(15),
                elevation: 0,
                color: AppColors.black900.withValues(alpha: 0.7),
                highlightElevation: 0,
                minWidth: double.minPositive,
                height: double.minPositive,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // controller.toggleFullScreenMode();

                  SystemChrome.setPreferredOrientations(
                    [
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown,
                    ],
                  );
                },
                child: Icon(
                  Icons.close,
                  color: AppColors.secondary,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UrlTypeHelper {
  static final List<String> imageTypes = [
    'jpg',
    'jpeg',
    'jfif',
    'pjpeg',
    'pjp',
    'png',
    'svg',
    'gif',
    'apng',
    'webp',
    'avif',
  ];

  static final List<String> videoTypes = [
    '3g2',
    '3gp',
    'aaf',
    'asf',
    'avchd',
    'avi',
    'drc',
    'flv',
    'm2v',
    'm3u8',
    'm4p',
    'm4v',
    'mkv',
    'mng',
    'mov',
    'mp2',
    'mp4',
    'mpe',
    'mpeg',
    'mpg',
    'mpv',
    'mxf',
    'nsv',
    // "ogg",
    'ogv',
    'qt',
    'rm',
    'rmvb',
    'roq',
    'svi',
    'vob',
    'webm',
    'wmv',
    'yuv',
  ];

  static final List<String> voiceTypes = [
    'mp3',
    'wav',
    'aac',
    'flac',
    'aiff',
    'ogg',
    'wma',
    'midi',
    'amr',
    'alac',
    'pcm',
    'dsd',
    'ape',
    'ac3',
    'm4a',
    'opus',
    'speex',
    'vox',
    'wv',
    'tak',
    'mpc',
    'tta',
    'dts',
    'au',
    'ra',
    'rm',
    'mka',
    'mpeg-4',
    'mpeg-2',
    'mpeg-1',
    'mpeg-7',
    'mpeg-21',
    'mpeg-4 part 14',
    'mpeg-4 part 12',
    'mpeg-4 part 10',
    'mpeg-4 part 3',
    'mpeg-4 part 2',
    'mpeg-4 part 1',
    'mpeg-4 audio',
    'mpeg-4 avc',
    'mpeg-4 asp',
    'mpeg-4 aac',
    'mpeg-4 he-aac',
    'mpeg-4 bsac',
    'mpeg-4 celp',
    'mpeg-4 hvxc',
    'mpeg-4 er-aac',
    'mpeg-4 er-bsac',
    'mpeg-4 er-celp',
    'mpeg-4 er-hvxc',
    'mpeg-4 er-lbr',
    'mpeg-4 er-ld',
    'mpeg-4 er-mlp',
    'mpeg-4 er-ps',
    'mpeg-4 er-sbr',
    'mpeg-4 er-sld',
    'mpeg-4 er-td',
    'mpeg-4 er-usac',
    'mpeg-4 er-vm',
    'mpeg-4 er-xmt',
    'mpeg-4 er-3d audio',
    'mpeg-4 er-bsac',
    'mpeg-4 er-celp',
    'mpeg-4 er-hvxc',
    'mpeg-4 er-lbr',
    'mpeg-4 er-ld',
    'mpeg-4 er-mlp',
    'mpeg-4 er-ps',
    'mpeg-4 er-sbr',
    'mpeg-4 er-sld',
    'mpeg-4 er-td',
    'mpeg-4 er-usac',
    'mpeg-4 er-vm',
    'mpeg-4 er-xmt',
    'mpeg-4 er-3d audio',
  ];

  static final List<String> fileTypes = [
    'txt',
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'csv',
    'rtf',
    'html',
    'xml',
    'json',
    'zip',
    'rar',
    '7z',
    'tar',
    'gz',
    'bz2',
    'dmg',
    'iso',
    'img',
    'exe',
    'apk',
    'app',
    'deb',
    'rpm',
    'jar',
    'mp3',
    'wav',
    'aac',
    'flac',
    'aiff',
    // "ogg",
    'wma',
    'midi',
    'amr',
    'alac',
    'pcm',
    'dsd',
    'ape',
    'ac3',
    'm4a',
    'opus',
    'speex',
    'vox',
    'wv',
    'tak',
    'mpc',
    'tta',
    'dts',
    'au',
    'ra',
    'rm',
    'mka',
    'mpeg-4',
    'mpeg-2',
    'mpeg-1',
    'mpeg-7',
    'mpeg-21',
    'mpeg-4 part 14',
    'mpeg-4 part 12',
    'mpeg-4 part 10',
    'mpeg-4 part 3',
    'mpeg-4 part 2',
    'mpeg-4 part 1',
    'mpeg-4 audio',
    'mpeg-4 avc',
    'mpeg-4 asp',
    'mpeg-4 aac',
    'mpeg-4 he-aac',
    'mpeg-4 bsac',
    'mpeg-4 celp',
    'mpeg-4 hvxc',
    'mpeg-4 er-aac',
    'mpeg-4 er-bsac',
    'mpeg-4 er-celp',
    'mpeg-4 er-hvxc',
    'mpeg-4 er-lbr',
    'mpeg-4 er-ld',
    'mpeg-4 er-mlp',
    'mpeg-4 er-ps',
    'mpeg-4 er-sbr',
    'mpeg-4 er-sld',
    'mpeg-4 er-td',
    'mpeg-4 er-usac',
    'mpeg-4 er-vm',
    'mpeg-4 er-xmt',
    'mpeg-4 er-3d audio',
    'mpeg-4 er-bsac',
    'mpeg-4 er-celp',
    'mpeg-4 er-hvxc',
    'mpeg-4 er-lbr',
    'mpeg-4 er-ld',
    'mpeg-4 er-mlp',
    'mpeg-4 er-ps',
    'mpeg-4 er-sbr',
    'mpeg-4 er-sld',
    'mpeg-4 er-td',
    'mpeg-4 er-usac',
    'mpeg-4 er-vm',
    'mpeg-4 er-xmt',
    'mpeg-4 er-3d audio',
  ];

  static final List<String> supportedFileTypes = [
    ///files
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
  ];

  static final List<String> capedFileTypes = [
    ///files
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx',

    /// photos
    'jpg',
    'jpeg',
    'jfif',
    'pjpeg',
    'pjp',
    'png',
    'svg',
    'gif',
    'apng',
    'webp',
    'avif',

    ///videos
    '3g2',
    '3gp',
    'aaf',
    'asf',
    'avchd',
    'avi',
    'drc',
    'flv',
    'm2v',
    'm3u8',
    'm4p',
    'm4v',
    'mkv',
    'mng',
    'mov',
    'mp2',
    'mp4',
    'mpe',
    'mpeg',
    'mpg',
    'mpv',
    'mxf',
    'nsv',
    // "ogg",
    'ogv',
    'qt',
    'rm',
    'rmvb',
    'roq',
    'svi',
    'vob',
    'webm',
    'wmv',
    'yuv',

    /// voices
    'mp3',
    'wav',
    'aac',
    'flac',
    'aiff',
    'ogg',
    'wma',
    'midi',
    'amr',
    'alac',
    'pcm',
    'dsd',
    'ape',
    'ac3',
    'm4a',
    'opus',
    'speex',
    'vox',
    'wv',
    'tak',
    'mpc',
    'tta',
    'dts',
    'au',
    'ra',
    'rm',
    'mka',
    'mpeg-4',
    'mpeg-2',
    'mpeg-1',
    'mpeg-7',
    'mpeg-21',
    'mpeg-4 part 14',
    'mpeg-4 part 12',
    'mpeg-4 part 10',
    'mpeg-4 part 3',
    'mpeg-4 part 2',
    'mpeg-4 part 1',
    'mpeg-4 audio',
    'mpeg-4 avc',
    'mpeg-4 asp',
    'mpeg-4 aac',
    'mpeg-4 he-aac',
    'mpeg-4 bsac',
    'mpeg-4 celp',
    'mpeg-4 hvxc',
    'mpeg-4 er-aac',
    'mpeg-4 er-bsac',
    'mpeg-4 er-celp',
    'mpeg-4 er-hvxc',
    'mpeg-4 er-lbr',
    'mpeg-4 er-ld',
    'mpeg-4 er-mlp',
    'mpeg-4 er-ps',
    'mpeg-4 er-sbr',
    'mpeg-4 er-sld',
    'mpeg-4 er-td',
    'mpeg-4 er-usac',
    'mpeg-4 er-vm',
    'mpeg-4 er-xmt',
    'mpeg-4 er-3d audio',
    'mpeg-4 er-bsac',
    'mpeg-4 er-celp',
    'mpeg-4 er-hvxc',
    'mpeg-4 er-lbr',
    'mpeg-4 er-ld',
    'mpeg-4 er-mlp',
    'mpeg-4 er-ps',
    'mpeg-4 er-sbr',
    'mpeg-4 er-sld',
    'mpeg-4 er-td',
    'mpeg-4 er-usac',
    'mpeg-4 er-vm',
    'mpeg-4 er-xmt',
    'mpeg-4 er-3d audio',
  ];

  static UrlType getType(url) {
    try {
      final Uri uri = Uri.parse(url);
      String extension = p.extension(uri.path).toLowerCase();
      if (extension.isEmpty) {
        if (url.contains('youtube.com')) {
          return UrlType.youtube;
        }
        return UrlType.unknown;
      }
      extension = extension.split('.').last;
      if (imageTypes.contains(extension)) {
        if (url.contains('http')) {
          return UrlType.image;
        }
        return UrlType.memoryImage;
      } else if (videoTypes.contains(extension)) {
        return UrlType.video;
      } else if (voiceTypes.contains(extension)) {
        return UrlType.voice;
      } else if (fileTypes.contains(extension)) {
        return UrlType.file;
      }
    } catch (e) {
      return UrlType.unknown;
    }
    return UrlType.unknown;
  }
}
