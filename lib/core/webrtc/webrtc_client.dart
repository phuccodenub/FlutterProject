import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'dart:async';

class Participant {
  Participant({
    required this.userId,
    required this.userName,
    required this.role,
    this.stream,
    this.videoEnabled = true,
    this.audioEnabled = true,
  });

  final int userId;
  final String userName;
  final String role;
  MediaStream? stream;
  bool videoEnabled;
  bool audioEnabled;
  RTCPeerConnection? peerConnection;
}

class WebRTCClient {
  WebRTCClient();

  final Map<int, Participant> _participants = {};
  MediaStream? _localStream;
  bool _videoEnabled = true;
  bool _audioEnabled = true;

  // Callbacks
  Function(int userId, MediaStream stream)? onRemoteStream;
  Function(int userId)? onParticipantLeft;
  Function(String error)? onError;

  Future<MediaStream?> startLocal({
    bool video = true,
    bool audio = true,
  }) async {
    try {
      final constraints = <String, dynamic>{
        'audio': audio,
        'video': video
            ? {
                'facingMode': 'user',
                'width': {'ideal': 1280},
                'height': {'ideal': 720},
                'frameRate': {'ideal': 30},
              }
            : false,
      };
      _localStream = await navigator.mediaDevices.getUserMedia(constraints);
      _videoEnabled = video;
      _audioEnabled = audio;
      return _localStream;
    } catch (e) {
      onError?.call('Failed to access camera/microphone: $e');
      return null;
    }
  }

  void stopLocal() {
    _localStream?.getTracks().forEach((t) => t.stop());
    _localStream?.dispose();
    _localStream = null;
  }

  MediaStream? get localStream => _localStream;
  bool get videoEnabled => _videoEnabled;
  bool get audioEnabled => _audioEnabled;

  Future<void> toggleVideo() async {
    if (_localStream == null) return;
    _videoEnabled = !_videoEnabled;
    final videoTracks = _localStream!.getVideoTracks();
    for (var track in videoTracks) {
      track.enabled = _videoEnabled;
    }
  }

  Future<void> toggleAudio() async {
    if (_localStream == null) return;
    _audioEnabled = !_audioEnabled;
    final audioTracks = _localStream!.getAudioTracks();
    for (var track in audioTracks) {
      track.enabled = _audioEnabled;
    }
  }

  Future<RTCPeerConnection?> createPeer(
    int userId, {
    bool isOffer = true,
  }) async {
    try {
      final config = {
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
          {'urls': 'stun:stun1.l.google.com:19302'},
          {'urls': 'stun:stun2.l.google.com:19302'},
        ],
        'sdpSemantics': 'unified-plan',
      };

      final pc = await createPeerConnection(config);

      // Add local stream tracks
      if (_localStream != null) {
        _localStream!.getTracks().forEach((track) {
          pc.addTrack(track, _localStream!);
        });
      }

      // Handle remote stream
      pc.onTrack = (RTCTrackEvent event) {
        if (event.streams.isNotEmpty) {
          final stream = event.streams[0];
          if (_participants.containsKey(userId)) {
            _participants[userId]!.stream = stream;
            onRemoteStream?.call(userId, stream);
          }
        }
      };

      // Handle ICE connection state
      pc.onIceConnectionState = (RTCIceConnectionState state) {
        if (state == RTCIceConnectionState.RTCIceConnectionStateFailed ||
            state == RTCIceConnectionState.RTCIceConnectionStateClosed ||
            state == RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
          removePeer(userId);
        }
      };

      if (!_participants.containsKey(userId)) {
        _participants[userId] = Participant(
          userId: userId,
          userName: 'User $userId',
          role: 'student',
        );
      }
      _participants[userId]!.peerConnection = pc;

      return pc;
    } catch (e) {
      onError?.call('Failed to create peer connection: $e');
      return null;
    }
  }

  Future<RTCSessionDescription?> createOffer(int userId) async {
    final pc = _participants[userId]?.peerConnection;
    if (pc == null) return null;

    try {
      final offer = await pc.createOffer({
        'offerToReceiveAudio': true,
        'offerToReceiveVideo': true,
      });
      await pc.setLocalDescription(offer);
      return offer;
    } catch (e) {
      onError?.call('Failed to create offer: $e');
      return null;
    }
  }

  Future<RTCSessionDescription?> createAnswer(int userId) async {
    final pc = _participants[userId]?.peerConnection;
    if (pc == null) return null;

    try {
      final answer = await pc.createAnswer({
        'offerToReceiveAudio': true,
        'offerToReceiveVideo': true,
      });
      await pc.setLocalDescription(answer);
      return answer;
    } catch (e) {
      onError?.call('Failed to create answer: $e');
      return null;
    }
  }

  Future<void> setRemoteDescription(
    int userId,
    RTCSessionDescription description,
  ) async {
    final pc = _participants[userId]?.peerConnection;
    if (pc == null) return;

    try {
      await pc.setRemoteDescription(description);
    } catch (e) {
      onError?.call('Failed to set remote description: $e');
    }
  }

  Future<void> addIceCandidate(int userId, RTCIceCandidate candidate) async {
    final pc = _participants[userId]?.peerConnection;
    if (pc == null) return;

    try {
      await pc.addCandidate(candidate);
    } catch (e) {
      onError?.call('Failed to add ICE candidate: $e');
    }
  }

  void addParticipant(Participant participant) {
    _participants[participant.userId] = participant;
  }

  Participant? getParticipant(int userId) => _participants[userId];
  List<Participant> get participants => _participants.values.toList();
  int get participantCount => _participants.length;

  void removePeer(int userId) {
    final participant = _participants[userId];
    if (participant != null) {
      participant.stream?.dispose();
      participant.peerConnection?.close();
      participant.peerConnection?.dispose();
      _participants.remove(userId);
      onParticipantLeft?.call(userId);
    }
  }

  void dispose() {
    stopLocal();
    for (var participant in _participants.values) {
      participant.stream?.dispose();
      participant.peerConnection?.close();
      participant.peerConnection?.dispose();
    }
    _participants.clear();
  }
}
