// // ignore_for_file: must_be_immutable
// import 'dart:async';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:numynd/assets_helper/app_fonts.dart';
// import 'package:numynd/assets_helper/app_icons.dart';
// import 'package:numynd/assets_helper/app_image.dart';
// import 'package:numynd/features/home_screen/widget/star_shape.dart';
// import 'package:numynd/helpers/navigation_service.dart';
// import 'package:numynd/helpers/toast.dart';
// import 'package:numynd/helpers/ui_helpers.dart';
// import 'package:numynd/networks/api_acess.dart';

// class AudioScreen extends StatefulWidget {
//   dynamic id, title, description, audioURL, imageURL;
//   AudioScreen({
//     super.key,
//     this.id,
//     this.title,
//     this.description,
//     this.audioURL,
//     this.imageURL,
//   });

//   @override
//   State<AudioScreen> createState() => _AudioScreenState();
// }

// class _AudioScreenState extends State<AudioScreen> {
//   late int currentPosition, totalDuration;
//   // ====== AUDIO ======
//   final AudioPlayer _player = AudioPlayer();

//   static const String _fallbackUrl =
//       'https://diviextended.com/wp-content/uploads/2021/10/sound-of-waves-marine-drive-mumbai.mp3';

//   bool _isPlaying = false;

//   Duration _duration = Duration.zero;
//   Duration _position = Duration.zero;

//   StreamSubscription<Duration>? _durSub;
//   StreamSubscription<Duration>? _posSub;
//   StreamSubscription<PlayerState>? _stateSub;

//   // ====== UI SLIDER (0..1) ======
//   double get _value {
//     if (_duration.inMilliseconds == 0) return 0.0;
//     return _position.inMilliseconds / _duration.inMilliseconds;
//   }

//   set _value(double v) {
//     if (_duration.inMilliseconds == 0) return;
//     final ms =
//         (v * _duration.inMilliseconds).clamp(0, _duration.inMilliseconds);
//     _player.seek(Duration(milliseconds: ms.round()));
//   }

//   String _fmt(Duration d) {
//     final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
//     final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
//     final h = d.inHours;
//     return h > 0 ? '$h:$m:$s' : '$m:$s';
//   }

//   // * ===== INIT AUDIO (STREAM SAFE) =====
//   Future<void> _init() async {
//     log("Audio URL: ${widget.audioURL ?? _fallbackUrl}");
//     log("Image URL: ${widget.imageURL}");

//     await _player.setReleaseMode(ReleaseMode.stop);

//     // Duration listener (TOTAL DURATION)
//     _durSub = _player.onDurationChanged.listen((d) {
//       log("Duration Loaded: $d");

//       setState(() => _duration = d);

//       // 🔹 Total duration in seconds
//       log("Total Duration (seconds): ${d.inSeconds}");
//       totalDuration = d.inSeconds;
//     });

//     // Position listener (CURRENT POSITION)
//     _posSub = _player.onPositionChanged.listen((p) {
//       setState(() => _position = p);

//       // 🔹 Current position in seconds
//       log("Current Position (seconds): ${p.inSeconds}");
//       currentPosition = p.inSeconds;
//     });

//     // Player state listener
//     _stateSub = _player.onPlayerStateChanged.listen((st) {
//       setState(() => _isPlaying = st == PlayerState.playing);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }

//   @override
//   void dispose() {
//     _durSub?.cancel();
//     _posSub?.cancel();
//     _stateSub?.cancel();
//     _player.dispose();
//     super.dispose();
//   }

//   /// ===== PLAY / PAUSE =====
//   Future<void> _togglePlayPause() async {
//     if (_isPlaying) {
//       await _player.pause();
//     } else {
//       await _player.play(
//         UrlSource(widget.audioURL ?? _fallbackUrl),
//       );
//     }
//   }

//   /// ===== SKIP 15s =====
//   Future<void> _skip(int seconds) async {
//     if (_duration == Duration.zero) return;

//     final current = _position.inSeconds;
//     final target = (current + seconds).clamp(0, _duration.inSeconds);

//     await _player.seek(Duration(seconds: target));
//   }

//   @override
//   Widget build(BuildContext context) {
//     log("Audio ID: ${widget.id}");
//     log("Audio Title: ${widget.title}");
//     log("Audio Description: ${widget.description}");
//     log("Audio URL: ${widget.audioURL}");
//     log('Image URL: ${widget.imageURL}');

//     final total =
//         _duration == Duration.zero ? const Duration(minutes: 0) : _duration;
//     log("Total Duration: $total");

//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(AppImages.audioImage),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 GestureDetector(
//                   onTap: () async {
//                     NavigationService.goBack;
//                     log("current position:- $currentPosition");
//                     log("total duration:= $totalDuration");
//                     log("Audio ID:= ${widget.id}");

//                     bool result = await postSendAudioRXObj.postSendAudioRX(
//                       audioId: widget.id,
//                       listenDuration: currentPosition,
//                       totalDuration: totalDuration,
//                       completed: 1,
//                     );

//                     if (result) {
//                       log("Listened data sent successfully");
//                     } else {
//                       log("Failed to send listened data");
//                     }
//                   },
//                   child: Row(
//                     children: [
//                       UIHelper.horizontalSpace(15.w),
//                       SvgPicture.asset(
//                         AppIcons.backIcons,
//                         height: 32.h,
//                         width: 32.w,
//                       ),
//                       UIHelper.horizontalSpace(40.w),
//                       Text(
//                         'Shift In Progress',
//                         style: TextFontStyle.textStyle12w400Lato.copyWith(
//                           color: Colors.white,
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 UIHelper.verticalSpace(45.h),
//                 PaintedFlowerImage(
//                   size: 200,
//                   assetImage: widget.imageURL,
//                   lobes: 8,
//                   innerRatio: 0.70,
//                   curve: 0.16,
//                   boost: 1.40,
//                 ),
//                 UIHelper.verticalSpace(30.h),
//                 Text(
//                   widget.title ?? 'N/A',
//                   style: TextFontStyle.textStyle12w400Lato.copyWith(
//                     color: Colors.white,
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 UIHelper.verticalSpace(15.h),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 20.w,
//                     vertical: 5,
//                   ),
//                   child: Text(
//                     widget.description ?? 'N/A',
//                     style: TextFontStyle.textStyle12w400Lato.copyWith(
//                       color: Colors.white,
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 UIHelper.verticalSpace(30.h),

//                 // === Controls ===
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: () => _skip(-15),
//                       child: SvgPicture.asset(
//                         AppIcons.skipBackIcon,
//                         width: 30.w,
//                         height: 30.h,
//                       ),
//                     ),
//                     UIHelper.horizontalSpace(40.w),
//                     GestureDetector(
//                       onTap: _togglePlayPause,
//                       child: SvgPicture.asset(
//                         _isPlaying ? AppIcons.pauseIcon : AppIcons.playIcon,
//                         width: 45.w,
//                         height: 45.h,
//                       ),
//                     ),
//                     UIHelper.horizontalSpace(40.w),
//                     GestureDetector(
//                       onTap: () => _skip(15),
//                       child: SvgPicture.asset(
//                         AppIcons.skipNextIcon,
//                         width: 30.w,
//                         height: 30.h,
//                       ),
//                     ),
//                   ],
//                 ),

//                 UIHelper.verticalSpace(30.h),

//                 // === Slider ===
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                   child: SliderTheme(
//                     data: SliderTheme.of(context).copyWith(
//                       trackHeight: 6,
//                       activeTrackColor: Colors.white,
//                       inactiveTrackColor: const Color(0xFF3D5568),
//                       thumbColor: Colors.white,
//                       overlayColor: Colors.transparent,
//                       thumbShape:
//                           const RoundSliderThumbShape(enabledThumbRadius: 7),
//                     ),
//                     child: Slider(
//                       value: _value.isNaN ? 0 : _value.clamp(0.0, 1.0),
//                       min: 0,
//                       max: 1,
//                       onChanged: (v) => _value = v,
//                       onChangeEnd: (v) => _value = v,
//                     ),
//                   ),
//                 ),

//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 35.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         _fmt(_position),
//                         style: TextFontStyle.textStyle12w400Lato.copyWith(
//                           color: Colors.white,
//                           fontSize: 12.sp,
//                         ),
//                       ),
//                       Text(
//                         _fmt(total),
//                         style: TextFontStyle.textStyle12w400Lato.copyWith(
//                           color: Colors.white,
//                           fontSize: 12.sp,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 UIHelper.verticalSpace(28.h),

//                 Row(
//                   children: [
//                     const Expanded(child: SizedBox()),
//                     GestureDetector(
//                       onTap: () async {
//                         bool result = await postFavouriteRXObj.postFavouriteRX(
//                           id: widget.id,
//                         );
//                         if (result) {
//                           ToastUtil.showShortToast('Added to Favourite');
//                           NavigationService.goBack;
//                         } else {
//                           ToastUtil.showShortToast('Failed to add Favourite');
//                         }
//                       },
//                       child: SvgPicture.asset(
//                         AppIcons.loveIcons,
//                         height: 40.h,
//                         width: 40.w,
//                       ),
//                     ),
//                     UIHelper.horizontalSpace(30.w),
//                     SvgPicture.asset(
//                       AppIcons.shareBgIcons,
//                       height: 40.h,
//                       width: 40.w,
//                     ),
//                     const Expanded(child: SizedBox()),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// // * ########################################################################
// // ignore_for_file: must_be_immutable
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:numynd/assets_helper/app_fonts.dart';
// import 'package:numynd/assets_helper/app_icons.dart';
// import 'package:numynd/assets_helper/app_image.dart';
// import 'package:numynd/features/audio_screen/presentation/audio_player_service.dart';
// import 'package:numynd/features/home_screen/widget/star_shape.dart';
// import 'package:numynd/helpers/navigation_service.dart';
// import 'package:numynd/helpers/toast.dart';
// import 'package:numynd/helpers/ui_helpers.dart';
// import 'package:numynd/networks/api_acess.dart';

// class AudioScreen extends StatefulWidget {
//   dynamic id, title, description, audioURL, imageURL;
//   AudioScreen({
//     super.key,
//     this.id,
//     this.title,
//     this.description,
//     this.audioURL,
//     this.imageURL,
//   });

//   @override
//   State<AudioScreen> createState() => _AudioScreenState();
// }

// class _AudioScreenState extends State<AudioScreen> {
//   // এখন লোকাল AudioPlayer নেই — singleton service ব্যবহার হচ্ছে
//   final AudioPlayerService _service = AudioPlayerService.instance;

//   @override
//   void initState() {
//     super.initState();
//     _service.addListener(_onServiceChanged);
//     _service.loadAndPlayIfNeeded(id: widget.id, audioURL: widget.audioURL);
//   }

//   void _onServiceChanged() {
//     if (mounted) setState(() {});
//   }

//   @override
//   void dispose() {
//     // 🔴 গুরুত্বপূর্ণ: এখানে player dispose করা হচ্ছে না, শুধু
//     // এই স্ক্রিনের listener remove করা হচ্ছে। তাই back করলেও audio চলতে থাকবে।
//     _service.removeListener(_onServiceChanged);
//     super.dispose();
//   }

//   Future<void> _togglePlayPause() async {
//     await _service.togglePlayPause(id: widget.id, audioURL: widget.audioURL);
//   }

//   Future<void> _skip(int seconds) async {
//     await _service.skip(seconds);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final total = _service.duration == Duration.zero
//         ? const Duration(minutes: 0)
//         : _service.duration;

//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(AppImages.audioImage),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 GestureDetector(
//                   onTap: () async {
//                     NavigationService.goBack;
//                     await _service.reportListenAndGoBack();
//                   },
//                   child: Row(
//                     children: [
//                       UIHelper.horizontalSpace(15.w),
//                       SvgPicture.asset(
//                         AppIcons.backIcons,
//                         height: 32.h,
//                         width: 32.w,
//                       ),
//                       UIHelper.horizontalSpace(40.w),
//                       Text(
//                         'Shift In Progress',
//                         style: TextFontStyle.textStyle12w400Lato.copyWith(
//                           color: Colors.white,
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 UIHelper.verticalSpace(45.h),
//                 PaintedFlowerImage(
//                   size: 200,
//                   assetImage: widget.imageURL,
//                   lobes: 8,
//                   innerRatio: 0.70,
//                   curve: 0.16,
//                   boost: 1.40,
//                 ),
//                 UIHelper.verticalSpace(30.h),
//                 Text(
//                   widget.title ?? 'N/A',
//                   style: TextFontStyle.textStyle12w400Lato.copyWith(
//                     color: Colors.white,
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 UIHelper.verticalSpace(15.h),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 20.w,
//                     vertical: 5,
//                   ),
//                   child: Text(
//                     widget.description ?? 'N/A',
//                     style: TextFontStyle.textStyle12w400Lato.copyWith(
//                       color: Colors.white,
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 UIHelper.verticalSpace(30.h),

//                 // === Controls ===
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: () => _skip(-15),
//                       child: SvgPicture.asset(
//                         AppIcons.skipBackIcon,
//                         width: 30.w,
//                         height: 30.h,
//                       ),
//                     ),
//                     UIHelper.horizontalSpace(40.w),
//                     GestureDetector(
//                       onTap: _togglePlayPause,
//                       child: SvgPicture.asset(
//                         _service.isPlaying
//                             ? AppIcons.pauseIcon
//                             : AppIcons.playIcon,
//                         width: 45.w,
//                         height: 45.h,
//                       ),
//                     ),
//                     UIHelper.horizontalSpace(40.w),
//                     GestureDetector(
//                       onTap: () => _skip(15),
//                       child: SvgPicture.asset(
//                         AppIcons.skipNextIcon,
//                         width: 30.w,
//                         height: 30.h,
//                       ),
//                     ),
//                   ],
//                 ),

//                 UIHelper.verticalSpace(30.h),

//                 // === Slider ===
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                   child: SliderTheme(
//                     data: SliderTheme.of(context).copyWith(
//                       trackHeight: 6,
//                       activeTrackColor: Colors.white,
//                       inactiveTrackColor: const Color(0xFF3D5568),
//                       thumbColor: Colors.white,
//                       overlayColor: Colors.transparent,
//                       thumbShape:
//                           const RoundSliderThumbShape(enabledThumbRadius: 7),
//                     ),
//                     child: Slider(
//                       value: _service.value.isNaN
//                           ? 0
//                           : _service.value.clamp(0.0, 1.0),
//                       min: 0,
//                       max: 1,
//                       onChanged: (v) => setState(() => _service.value = v),
//                       onChangeEnd: (v) => _service.value = v,
//                     ),
//                   ),
//                 ),

//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 35.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         _service.fmt(_service.position),
//                         style: TextFontStyle.textStyle12w400Lato.copyWith(
//                           color: Colors.white,
//                           fontSize: 12.sp,
//                         ),
//                       ),
//                       Text(
//                         _service.fmt(total),
//                         style: TextFontStyle.textStyle12w400Lato.copyWith(
//                           color: Colors.white,
//                           fontSize: 12.sp,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 UIHelper.verticalSpace(28.h),

//                 Row(
//                   children: [
//                     const Expanded(child: SizedBox()),
//                     GestureDetector(
//                       onTap: () async {
//                         bool result = await postFavouriteRXObj.postFavouriteRX(
//                           id: widget.id,
//                         );
//                         if (result) {
//                           ToastUtil.showShortToast('Added to Favourite');
//                           NavigationService.goBack;
//                         } else {
//                           ToastUtil.showShortToast('Failed to add Favourite');
//                         }
//                       },
//                       child: SvgPicture.asset(
//                         AppIcons.loveIcons,
//                         height: 40.h,
//                         width: 40.w,
//                       ),
//                     ),
//                     UIHelper.horizontalSpace(30.w),
//                     SvgPicture.asset(
//                       AppIcons.shareBgIcons,
//                       height: 40.h,
//                       width: 40.w,
//                     ),
//                     const Expanded(child: SizedBox()),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// * ########################################################################
// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:numynd/assets_helper/app_fonts.dart';
import 'package:numynd/assets_helper/app_icons.dart';
import 'package:numynd/assets_helper/app_image.dart';
import 'package:numynd/features/audio_screen/presentation/audio_handler.dart';
import 'package:numynd/features/home_screen/widget/star_shape.dart';
import 'package:numynd/helpers/navigation_service.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/helpers/ui_helpers.dart';
import 'package:numynd/networks/api_acess.dart';

class AudioScreen extends StatefulWidget {
  dynamic id, title, description, audioURL, imageURL;
  AudioScreen({
    super.key,
    this.id,
    this.title,
    this.description,
    this.audioURL,
    this.imageURL,
  });

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final MyAudioHandler _handler = MyAudioHandler.instance;

  @override
  void initState() {
    super.initState();
    _handler.loadAndPlayIfNeeded(
      id: widget.id,
      title: widget.title,
      description: widget.description,
      audioURL: widget.audioURL,
    );
  }

  // dispose()-এ কিছুই করার দরকার নেই — handler singleton, screen বন্ধ
  // হলেও বেঁচে থাকবে, তাই back করলেও audio চলতে থাকবে

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.audioImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    NavigationService.goBack;
                    await _handler.reportListenAndGoBack();
                  },
                  child: Row(
                    children: [
                      UIHelper.horizontalSpace(15.w),
                      SvgPicture.asset(
                        AppIcons.backIcons,
                        height: 32.h,
                        width: 32.w,
                      ),
                      UIHelper.horizontalSpace(40.w),
                      Text(
                        'Shift In Progress',
                        style: TextFontStyle.textStyle12w400Lato.copyWith(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                UIHelper.verticalSpace(45.h),
                PaintedFlowerImage(
                  size: 200,
                  assetImage: widget.imageURL,
                  lobes: 8,
                  innerRatio: 0.70,
                  curve: 0.16,
                  boost: 1.40,
                ),
                UIHelper.verticalSpace(30.h),
                Text(
                  widget.title ?? 'N/A',
                  style: TextFontStyle.textStyle12w400Lato.copyWith(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                UIHelper.verticalSpace(15.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5),
                  child: Text(
                    widget.description ?? 'N/A',
                    style: TextFontStyle.textStyle12w400Lato.copyWith(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                UIHelper.verticalSpace(30.h),

                // === Controls ===
                StreamBuilder<bool>(
                  stream: _handler.playingStream,
                  initialData: _handler.isPlaying,
                  builder: (context, snapshot) {
                    final playing = snapshot.data ?? false;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _handler.skip(-15),
                          child: SvgPicture.asset(
                            AppIcons.skipBackIcon,
                            width: 30.w,
                            height: 30.h,
                          ),
                        ),
                        UIHelper.horizontalSpace(40.w),
                        GestureDetector(
                          onTap: _handler.togglePlayPause,
                          child: SvgPicture.asset(
                            playing ? AppIcons.pauseIcon : AppIcons.playIcon,
                            width: 45.w,
                            height: 45.h,
                          ),
                        ),
                        UIHelper.horizontalSpace(40.w),
                        GestureDetector(
                          onTap: () => _handler.skip(15),
                          child: SvgPicture.asset(
                            AppIcons.skipNextIcon,
                            width: 30.w,
                            height: 30.h,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                UIHelper.verticalSpace(30.h),

                // === Slider ===
                StreamBuilder<Duration>(
                  stream: _handler.positionStream,
                  initialData: Duration.zero,
                  builder: (context, posSnap) {
                    final pos = posSnap.data ?? Duration.zero;
                    final dur = _handler.duration;
                    final value = dur.inMilliseconds == 0
                        ? 0.0
                        : (pos.inMilliseconds / dur.inMilliseconds)
                            .clamp(0.0, 1.0);

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 6,
                              activeTrackColor: Colors.white,
                              inactiveTrackColor: const Color(0xFF3D5568),
                              thumbColor: Colors.white,
                              overlayColor: Colors.transparent,
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 7),
                            ),
                            child: Slider(
                              value: value,
                              min: 0,
                              max: 1,
                              onChanged: (v) {},
                              onChangeEnd: (v) {
                                final ms = (v * dur.inMilliseconds).round();
                                _handler.seek(Duration(milliseconds: ms));
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _fmt(pos),
                                style: TextFontStyle.textStyle12w400Lato
                                    .copyWith(
                                        color: Colors.white, fontSize: 12.sp),
                              ),
                              Text(
                                _fmt(dur),
                                style: TextFontStyle.textStyle12w400Lato
                                    .copyWith(
                                        color: Colors.white, fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),

                UIHelper.verticalSpace(28.h),

                Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: () async {
                        bool result = await postFavouriteRXObj.postFavouriteRX(
                          id: widget.id,
                        );
                        if (result) {
                          ToastUtil.showShortToast('Added to Favourite');
                          NavigationService.goBack;
                        } else {
                          ToastUtil.showShortToast('Failed to add Favourite');
                        }
                      },
                      child: SvgPicture.asset(
                        AppIcons.loveIcons,
                        height: 40.h,
                        width: 40.w,
                      ),
                    ),
                    UIHelper.horizontalSpace(30.w),
                    SvgPicture.asset(
                      AppIcons.shareBgIcons,
                      height: 40.h,
                      width: 40.w,
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
