// lib/services/audio_player_service.dart
import 'dart:async';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:numynd/networks/api_acess.dart';

/// অ্যাপ-ওয়াইড সিঙ্গেলটন — এই অবজেক্ট AudioScreen থেকে back করলেও ধ্বংস হবে না।
/// শুধু তখনই dispose হবে যখন পুরো অ্যাপ প্রসেস kill হবে।
class AudioPlayerService extends ChangeNotifier {
  AudioPlayerService._internal();
  static final AudioPlayerService instance = AudioPlayerService._internal();

  final AudioPlayer player = AudioPlayer();

  static const String fallbackUrl =
      'https://diviextended.com/wp-content/uploads/2021/10/sound-of-waves-marine-drive-mumbai.mp3';

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  // বর্তমানে কোন অডিও চলছে সেটার metadata (skip করলে posting-এর জন্য দরকার)
  dynamic currentId;
  int currentPositionSec = 0;
  int totalDurationSec = 0;

  StreamSubscription<Duration>? _durSub;
  StreamSubscription<Duration>? _posSub;
  StreamSubscription<PlayerState>? _stateSub;

  bool _listenersAttached = false;

  double get value {
    if (duration.inMilliseconds == 0) return 0.0;
    return position.inMilliseconds / duration.inMilliseconds;
  }

  set value(double v) {
    if (duration.inMilliseconds == 0) return;
    final ms = (v * duration.inMilliseconds).clamp(0, duration.inMilliseconds);
    player.seek(Duration(milliseconds: ms.round()));
  }

  String fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  /// একবারই attach হবে (multiple screens থেকে বারবার listener বসবে না)
  Future<void> _attachListenersOnce() async {
    if (_listenersAttached) return;
    _listenersAttached = true;

    await player.setReleaseMode(ReleaseMode.stop);

    // Lock screen / background এও audio চলতে থাকবে (Android এ ডিফল্টভাবে
    // process বেঁচে থাকা পর্যন্ত চলে; iOS এর জন্য Info.plist এ
    // UIBackgroundModes -> audio অ্যাড করতে হবে)
    _durSub = player.onDurationChanged.listen((d) {
      duration = d;
      totalDurationSec = d.inSeconds;
      notifyListeners();
    });

    _posSub = player.onPositionChanged.listen((p) {
      position = p;
      currentPositionSec = p.inSeconds;
      notifyListeners();
    });

    _stateSub = player.onPlayerStateChanged.listen((st) {
      isPlaying = st == PlayerState.playing;
      notifyListeners();
    });
  }

  /// নতুন অডিও লোড করার সময় কল করবে (audioURL পরিবর্তন হলে)
  Future<void> loadAndPlayIfNeeded({
    required dynamic id,
    required String? audioURL,
    bool autoResumeIfSame = true,
  }) async {
    await _attachListenersOnce();

    // যদি একই audio আগে থেকেই চলছে/লোড করা আছে, তাহলে আবার play করে
    // শুরু থেকে চালানোর দরকার নেই — এতেই back করে আবার ঢুকলেও চলতে থাকা
    // audio-টা resume হবে, নতুন করে শুরু হবে না।
    if (currentId == id && autoResumeIfSame) {
      log("Same audio already active, not restarting: $id");
      return;
    }

    currentId = id;
    await player.play(UrlSource(audioURL ?? fallbackUrl));
  }

  Future<void> togglePlayPause({
    required dynamic id,
    required String? audioURL,
  }) async {
    await _attachListenersOnce();

    if (isPlaying) {
      await player.pause();
    } else {
      if (currentId != id || player.source == null) {
        currentId = id;
        await player.play(UrlSource(audioURL ?? fallbackUrl));
      } else {
        await player.resume();
      }
    }
  }

  Future<void> skip(int seconds) async {
    if (duration == Duration.zero) return;
    final current = position.inSeconds;
    final target = (current + seconds).clamp(0, duration.inSeconds);
    await player.seek(Duration(seconds: target));
  }

  /// শুধু ইউজার সরাসরি stop/close চাইলে বা লগআউট হলে কল করবে —
  /// স্ক্রিন back করার সময় এটা কল করা যাবে না।
  Future<void> stopAndReset() async {
    await player.stop();
    currentId = null;
    position = Duration.zero;
    duration = Duration.zero;
    notifyListeners();
  }

  Future<void> reportListenAndGoBack() async {
    log("current position:- $currentPositionSec");
    log("total duration:= $totalDurationSec");
    log("Audio ID:= $currentId");

    bool result = await postSendAudioRXObj.postSendAudioRX(
      audioId: currentId,
      listenDuration: currentPositionSec,
      totalDuration: totalDurationSec,
      completed: 1,
    );

    if (result) {
      log("Listened data sent successfully");
    } else {
      log("Failed to send listened data");
    }
  }

  @override
  void dispose() {
    _durSub?.cancel();
    _posSub?.cancel();
    _stateSub?.cancel();
    player.dispose();
    super.dispose();
  }
}
