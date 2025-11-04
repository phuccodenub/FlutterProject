import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../core/webrtc/webrtc_client.dart';

class LivestreamState {
  const LivestreamState({
    this.isActive = false,
    this.roomId,
    this.hostId,
    this.localStream,
    this.participants = const [],
    this.isVideoEnabled = true,
    this.isAudioEnabled = true,
    this.error,
  });

  final bool isActive;
  final String? roomId;
  final int? hostId;
  final MediaStream? localStream;
  final List<Participant> participants;
  final bool isVideoEnabled;
  final bool isAudioEnabled;
  final String? error;

  LivestreamState copyWith({
    bool? isActive,
    String? roomId,
    int? hostId,
    MediaStream? localStream,
    List<Participant>? participants,
    bool? isVideoEnabled,
    bool? isAudioEnabled,
    String? error,
  }) {
    return LivestreamState(
      isActive: isActive ?? this.isActive,
      roomId: roomId ?? this.roomId,
      hostId: hostId ?? this.hostId,
      localStream: localStream ?? this.localStream,
      participants: participants ?? this.participants,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      error: error,
    );
  }
}

class LivestreamNotifier extends StateNotifier<LivestreamState> {
  LivestreamNotifier() : super(const LivestreamState()) {
    _webrtcClient = WebRTCClient();
    _setupCallbacks();
  }

  late WebRTCClient _webrtcClient;

  void _setupCallbacks() {
    _webrtcClient.onRemoteStream = (userId, stream) {
      _updateParticipants();
    };

    _webrtcClient.onParticipantLeft = (userId) {
      _updateParticipants();
    };

    _webrtcClient.onError = (error) {
      state = state.copyWith(error: error);
    };
  }

  Future<void> startLivestream(String roomId, int hostId) async {
    try {
      final stream = await _webrtcClient.startLocal(video: true, audio: true);
      if (stream == null) {
        state = state.copyWith(
          error:
              'Failed to access camera/microphone. Please check permissions.',
        );
        return;
      }

      state = state.copyWith(
        isActive: true,
        roomId: roomId,
        hostId: hostId,
        localStream: stream,
        isVideoEnabled: true,
        isAudioEnabled: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to start livestream: $e');
    }
  }

  Future<void> joinLivestream(String roomId, int userId) async {
    try {
      final stream = await _webrtcClient.startLocal(video: true, audio: true);
      if (stream == null) {
        state = state.copyWith(
          error:
              'Failed to access camera/microphone. Please check permissions.',
        );
        return;
      }

      state = state.copyWith(
        isActive: true,
        roomId: roomId,
        localStream: stream,
        isVideoEnabled: true,
        isAudioEnabled: true,
        error: null,
      );

      // Mock: Add some remote participants for demo
      _simulateRemoteParticipants();
    } catch (e) {
      state = state.copyWith(error: 'Failed to join livestream: $e');
    }
  }

  void _simulateRemoteParticipants() {
    // Simulate 2-3 remote participants for demo
    Future.delayed(const Duration(seconds: 2), () {
      _webrtcClient.addParticipant(
        Participant(
          userId: 101,
          userName: 'Instructor John',
          role: 'instructor',
          videoEnabled: true,
          audioEnabled: true,
        ),
      );
      _updateParticipants();
    });

    Future.delayed(const Duration(seconds: 4), () {
      _webrtcClient.addParticipant(
        Participant(
          userId: 102,
          userName: 'Student Alice',
          role: 'student',
          videoEnabled: true,
          audioEnabled: false,
        ),
      );
      _updateParticipants();
    });
  }

  Future<void> toggleVideo() async {
    await _webrtcClient.toggleVideo();
    state = state.copyWith(isVideoEnabled: _webrtcClient.videoEnabled);
  }

  Future<void> toggleAudio() async {
    await _webrtcClient.toggleAudio();
    state = state.copyWith(isAudioEnabled: _webrtcClient.audioEnabled);
  }

  void _updateParticipants() {
    state = state.copyWith(participants: _webrtcClient.participants);
  }

  void endLivestream() {
    _webrtcClient.dispose();
    state = const LivestreamState();
  }

  // Mock WebRTC signaling methods (to be replaced with real socket.io)
  Future<void> sendOffer(int toUserId) async {
    final pc = await _webrtcClient.createPeer(toUserId, isOffer: true);
    if (pc != null) {
      await _webrtcClient.createOffer(toUserId);
      // In real implementation: emit to socket
      // socket.emit('livestream:webrtc-offer', {...})
    }
  }

  Future<void> handleOffer(int fromUserId, String sdp) async {
    await _webrtcClient.createPeer(fromUserId, isOffer: false);
    await _webrtcClient.setRemoteDescription(
      fromUserId,
      RTCSessionDescription(sdp, 'offer'),
    );
    await _webrtcClient.createAnswer(fromUserId);
    // In real implementation: emit answer to socket
    // socket.emit('livestream:webrtc-answer', {...})
  }

  Future<void> handleAnswer(int fromUserId, String sdp) async {
    await _webrtcClient.setRemoteDescription(
      fromUserId,
      RTCSessionDescription(sdp, 'answer'),
    );
  }

  Future<void> handleIceCandidate(
    int fromUserId,
    Map<String, dynamic> candidateData,
  ) async {
    final candidate = RTCIceCandidate(
      candidateData['candidate'],
      candidateData['sdpMid'],
      candidateData['sdpMLineIndex'],
    );
    await _webrtcClient.addIceCandidate(fromUserId, candidate);
  }

  @override
  void dispose() {
    _webrtcClient.dispose();
    super.dispose();
  }
}

final livestreamProvider =
    StateNotifierProvider<LivestreamNotifier, LivestreamState>(
      (ref) => LivestreamNotifier(),
    );
