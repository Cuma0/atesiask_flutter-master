import 'package:audio_session/audio_session.dart';
import 'package:bizidealcennetine/main.dart';
import 'package:bizidealcennetine/yaveran/Degiskenler.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

import 'Notifier.dart';

class AudioService {
  static AudioPlayer? _player;
  static BehaviorSubject<Duration>? _positionSubject;
  static String parca_adi="...";
  static String seslendiren="...";
  static List<MediaItem> parca_listesi=[];

  static final progressNotifier  = ProgressNotifier();
  static final currentSongTitleNotifier = ValueNotifier<String>('...');
  static final currentSongSubTitleNotifier = ValueNotifier<String>('...');
  //final currentSongTitleNotifier = ValueNotifier<String>('');
  static final playlistNotifier = ValueNotifier<List<String>>([]);
  //final progressNotifier = ProgressNotifier();
  static final repeatButtonNotifier = RepeatButtonNotifier();
  static final isFirstSongNotifier = ValueNotifier<bool>(true);
  static final playButtonNotifier = PlayButtonNotifier();
  static final isLastSongNotifier = ValueNotifier<bool>(true);
  static final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  static bool _initialized = false;
  static int ilkkez=-1;

/*
  AudioService() {
    if (!_initialized) {
      await JustAudioBackground.init(
        androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      );
      _player = AudioPlayer();
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());

      _positionSubject = BehaviorSubject<Duration>();

      _player!.playbackEventStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          // Handle playback completion
        }
        _positionSubject!.add(event.updatePosition);
      }, onError: (Object e, StackTrace stackTrace) {
        print('A stream error occurred: $e');
      });

      player.currentIndexStream.listen((index) {
        print("currentIndexStream $index");
        setCurrentTrack(index);

      });
      player.playerStateStream.listen((playerState) {

        final isPlaying = playerState.playing;
        final processingState = playerState.processingState;



        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          playButtonNotifier.value = ButtonState.loading;
        } else if (!isPlaying) {
          playButtonNotifier.value = ButtonState.paused;
        } else if (processingState != ProcessingState.completed) {
          playButtonNotifier.value = ButtonState.playing;
        } else {
          player.seek(Duration.zero);
          player.pause();
        }
        print("TEST playerStateStream: ${isPlaying} ${playButtonNotifier.value}");
      });
      player.positionStream.listen((position) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: position,
          buffered: oldState.buffered,
          total: oldState.total,
        );
      });
      player.durationStream.listen((totalDuration) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: oldState.buffered,
          total: totalDuration ?? Duration.zero,
        );
      });
      player.bufferedPositionStream.listen((bufferedPosition) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: bufferedPosition,
          total: oldState.total,
        );
      });
      final shuffleEnabled = player.shuffleModeEnabled;
      player.setShuffleModeEnabled(!shuffleEnabled);

      _initialized = true;



    }
  }
*/

  AudioPlayer get player {
    if (_player == null) {
      throw Exception("AudioService has not been initialized.");
    }
    return _player!;
  }
  BehaviorSubject<Duration> get positionSubject {
    if (_positionSubject == null) {
      throw Exception("AudioService has not been initialized.");
    }
    return _positionSubject!;
  }
  Future<void> init() async {
    if (!_initialized) {
      await JustAudioBackground.init(
        androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      );
      _player = AudioPlayer();
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());

      _positionSubject = BehaviorSubject<Duration>();

      _player!.playbackEventStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          // Handle playback completion
        }
        _positionSubject!.add(event.updatePosition);
      }, onError: (Object e, StackTrace stackTrace) {
        print('A stream error occurred: $e');
      });

      player.currentIndexStream.listen((index) {
        //print("currentIndexStream $index");
        setCurrentTrack(index);

      });
      player.playerStateStream.listen((playerState) {

        final isPlaying = playerState.playing;
        final processingState = playerState.processingState;



        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          playButtonNotifier.value = ButtonState.loading;
        } else if (!isPlaying) {
          playButtonNotifier.value = ButtonState.paused;
        } else if (processingState != ProcessingState.completed) {
          playButtonNotifier.value = ButtonState.playing;
        } else {
          player.seek(Duration.zero);
          player.pause();
        }
        //print("TEST playerStateStream: ${isPlaying} ${playButtonNotifier.value}");
      });
      player.positionStream.listen((position) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: position,
          buffered: oldState.buffered,
          total: oldState.total,
        );
      });
      player.durationStream.listen((totalDuration) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: oldState.buffered,
          total: totalDuration ?? Duration.zero,
        );
      });
      player.bufferedPositionStream.listen((bufferedPosition) {
        final oldState = progressNotifier.value;
        progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: bufferedPosition,
          total: oldState.total,
        );
      });
      final shuffleEnabled = player.shuffleModeEnabled;
      player.setShuffleModeEnabled(!shuffleEnabled);

      _initialized = true;



    }
  }

  Future<void> setPlaylist(List<AudioSource> sources) async {
    //print("LAVANTA");

    try {
      //if(!_initialized) await init();
      await player.setAudioSource(ConcatenatingAudioSource(children: sources));
      //Degiskenler.songListNotifier.value=sources;
      //print("TESTTTTT ${Degiskenler.songListNotifier.value}");
      next();
    } catch (e, stackTrace) {
      print("Error loading playlist: $e");
      print(stackTrace);
    }
  }
  setCurrentTrack(index){
    if (index != null && ilkkez!=-1) {
      parca_adi = degiskenler.listDinle[index]["parca_adi"];
      seslendiren = degiskenler.listDinle[index]["seslendiren"];
      currentSongTitleNotifier.value = parca_adi;
      currentSongSubTitleNotifier.value = seslendiren;
    }
    if (index != null) ilkkez=index; //ilk parça listenin hep ilk parçası oluyordu bunu engelledik ayrıca playlist yüklenince direkt next yapıyor
    /*if (index >= 0 && index < parca_listesi.length) {
      // İstenilen index numarası geçerli bir aralıkta mı kontrol ediyoruz
      var desiredAudio = parca_listesi[index];
      //MediaItem mediaItem = desiredAudio. as MediaItem;
      //MediaItem mediaItem = desiredAudio.tag as MediaItem;

      print("Parça Adı: ${desiredAudio.title}");
      print("Seslendiren: ${desiredAudio.artist}");
      //print("URL: ${desiredAudio.uri}");
      print("Resim URL: ${desiredAudio.artUri}");
    } else {
      print("Geçersiz index numarası.");
    }*/
    // Güncellenen bilgileri AudioInfoNotifier aracılığıyla bildir
    //_audioInfoNotifier.setTrackInfo(player.playing, parca_adi, seslendiren);
  }
  Future<void> play() async {
    //print("TEST play: ${player.playing}");
    await player.play();
  }
  Future<void> pause() async {
    //print("TEST pause: ${player.playing}");
    await player.pause();

  }
  Future<void> play_pause() async {
    //print("TEST play_pause: ${player.playing}");
    if(player.playing) await pause();
    else await play();
  }
  Future<void> next() async {
    await player.seekToNext();
  }
  Future<void> previous() async {
    await player.seekToPrevious();
  }
  Future<void> seek(Duration position) async {
    player.seek(position);
  }
  Future<void> playAtIndex(int index) async {
    if (index < 0 || index >= player.audioSource!.sequence.length) {
      print("Invalid index: $index");
      return;
    }

    await player.seek(Duration.zero, index: index);
    await play();
  }
  Future<void> playAtId(int id) async {
    if (id < 0 || id >= player.audioSource!.sequence.length) {
      print("Invalid index: $id");
      return;
    }
    var songid=-1;
    for (var item in Degiskenler.songListNotifier.value){
      //print(item);
      if(item['sira_no']==id) {
        songid=id;
        break;
      }
    }
    if(songid==-1) return;
    await player.seek(Duration.zero, index: songid-1);
    await play();
  }
  Future<void> repeat() async {
    if (repeatButtonNotifier.value == RepeatState.on) {
      await player.setLoopMode(LoopMode.all);
      repeatButtonNotifier.value = RepeatState.off;
    }
    else {
      await player.setLoopMode(LoopMode.one);
      repeatButtonNotifier.value = RepeatState.on;
    }
  }

  dynamic getCurrentTrackName() {
    print("Dinleniyor: ${parca_adi}");
    return parca_adi;
  }
  dynamic getCurrentTrackName2() {
    print("Dinleniyor: ${seslendiren}");
    return seslendiren;
  }

  void dispose() {
    _player?.dispose();
    _positionSubject?.close();
    _initialized = false;
  }

// Add more methods as needed...




  void onRepeatButtonPressed() {
    // TODO
  }

  void onPreviousSongButtonPressed() {
    // TODO
  }

  void onNextSongButtonPressed() {
    // TODO
  }

  void onShuffleButtonPressed() async {
    // TODO
  }
}

