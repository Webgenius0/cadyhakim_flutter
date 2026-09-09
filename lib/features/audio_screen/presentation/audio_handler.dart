import 'dart:async';
import 'dart:developer';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:numynd/networks/api_acess.dart';


class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  MyAudioHandler._internal() {
    _init();
  }
  static final MyAudioHandler instance = MyAudioHandler._internal();

  final AudioPlayer _player = AudioPlayer();

  static const String fallbackUrl =
      'https://diviextended.com/wp-content/uploads/2021/10/sound-of-waves-marine-drive-mumbai.mp3';

  dynamic currentId;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<bool> get playingStream => _player.playingStream;
  Duration get position => _player.position;
  Duration get duration => _player.duration ?? Duration.zero;
  bool get isPlaying => _player.playing;

  Future<void> _init() async {

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    await session.setActive(true);

    // playbackState স্ট্রিম আপডেট করে — এটাই lock screen/notification controls চালায়
    _player.playbackEventStream.listen((event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.rewind,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.fastForward,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ));
    }, onError: (Object e, StackTrace st) {
      log("Player error: $e");
    });

    _player.durationStream.listen((d) {
      final item = mediaItem.value;
      if (item != null && d != null) {
        mediaItem.add(item.copyWith(duration: d));
      }
    });
  }

  /// নতুন audio লোড করবে, একই audio হলে restart করবে না (AudioScreen-এ
  /// back করে আবার ঢুকলে এই behavior-টাই বজায় থাকবে)
  Future<void> loadAndPlayIfNeeded({
    required dynamic id,
    required String? title,
    required String? description,
    required String? audioURL,
    bool autoResumeIfSame = true,
  }) async {
    if (currentId == id && autoResumeIfSame) {
      log("Same audio already active, not restarting: $id");
      return;
    }
    currentId = id;

    mediaItem.add(MediaItem(
      id: audioURL ?? fallbackUrl,
      title: title ?? 'N/A',
      artist: description,
    ));

    await _player.setUrl(audioURL ?? fallbackUrl);
    await play();
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() async {
    await _player.stop();
    currentId = null;
    await super.stop();
  }

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> skip(int seconds) async {
    final target = _player.position + Duration(seconds: seconds);
    final clamped = target < Duration.zero
        ? Duration.zero
        : (target > duration ? duration : target);
    await _player.seek(clamped);
  }

  Future<void> reportListenAndGoBack() async {
    final posSec = _player.position.inSeconds;
    final durSec = duration.inSeconds;
    log("current position:- $posSec");
    log("total duration:= $durSec");
    log("Audio ID:= $currentId");

    bool result = await postSendAudioRXObj.postSendAudioRX(
      audioId: currentId,
      listenDuration: posSec,
      totalDuration: durSec,
      completed: 1,
    );

    if (result) {
      log("Listened data sent successfully");
    } else {
      log("Failed to send listened data");
    }
  }
}
