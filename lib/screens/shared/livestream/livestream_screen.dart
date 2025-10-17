import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../../features/livestream/livestream_store.dart';
import '../../../core/webrtc/webrtc_client.dart';

class LivestreamScreen extends ConsumerStatefulWidget {
  const LivestreamScreen({
    super.key,
    required this.courseId,
    required this.isHost,
  });
  final String courseId;
  final bool isHost;

  @override
  ConsumerState<LivestreamScreen> createState() => _LivestreamScreenState();
}

class _LivestreamScreenState extends ConsumerState<LivestreamScreen> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeRenderers();
    _startLivestream();
  }

  Future<void> _initializeRenderers() async {
    await _localRenderer.initialize();
    setState(() => _isInitialized = true);
  }

  Future<void> _startLivestream() async {
    final roomId = 'room-${widget.courseId}';
    if (widget.isHost) {
      await ref.read(livestreamProvider.notifier).startLivestream(roomId, 1);
    } else {
      await ref.read(livestreamProvider.notifier).joinLivestream(roomId, 2);
    }

    // Set local stream to renderer
    Future.delayed(const Duration(milliseconds: 500), () {
      final state = ref.read(livestreamProvider);
      if (state.localStream != null) {
        _localRenderer.srcObject = state.localStream;
      }
    });
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(livestreamProvider);

    if (state.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Livestream')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  state.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    if (!state.isActive || !_isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Livestream')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Connecting...'),
            ],
          ),
        ),
      );
    }

    final totalParticipants = state.participants.length + 1; // +1 for local
    final gridCrossAxisCount = totalParticipants <= 2 ? 1 : 2;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isHost ? 'Hosting Livestream' : 'Viewing Livestream',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Participants'),
                  content: Text('Total: $totalParticipants online'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Participants grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridCrossAxisCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 3 / 4,
              ),
              itemCount: totalParticipants,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Local user
                  return _buildLocalVideoCard(state);
                } else {
                  // Remote participants
                  final participant = state.participants[index - 1];
                  return _buildRemoteVideoCard(participant);
                }
              },
            ),
          ),
          // Controls
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black87,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: state.isVideoEnabled
                        ? Icons.videocam
                        : Icons.videocam_off,
                    label: 'Video',
                    isActive: state.isVideoEnabled,
                    onPressed: () {
                      ref.read(livestreamProvider.notifier).toggleVideo();
                    },
                  ),
                  _buildControlButton(
                    icon: state.isAudioEnabled ? Icons.mic : Icons.mic_off,
                    label: 'Audio',
                    isActive: state.isAudioEnabled,
                    onPressed: () {
                      ref.read(livestreamProvider.notifier).toggleAudio();
                    },
                  ),
                  _buildControlButton(
                    icon: Icons.call_end,
                    label: 'End',
                    isActive: false,
                    color: Colors.red,
                    onPressed: () {
                      ref.read(livestreamProvider.notifier).endLivestream();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalVideoCard(LivestreamState state) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          state.isVideoEnabled
              ? RTCVideoView(_localRenderer, mirror: true)
              : Container(
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Icon(
                      Icons.videocam_off,
                      size: 64,
                      color: Colors.white54,
                    ),
                  ),
                ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.white),
                  const SizedBox(width: 4),
                  const Text(
                    'You',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (!state.isAudioEnabled)
                    const Icon(Icons.mic_off, size: 14, color: Colors.red),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoteVideoCard(Participant participant) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.grey.shade800,
            child: participant.videoEnabled
                ? participant.stream != null
                      ? RTCVideoView(
                          RTCVideoRenderer()..srcObject = participant.stream,
                        )
                      : const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                : const Center(
                    child: Icon(
                      Icons.videocam_off,
                      size: 64,
                      color: Colors.white54,
                    ),
                  ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    participant.role == 'instructor'
                        ? Icons.school
                        : Icons.person,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      participant.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  if (!participant.audioEnabled)
                    const Icon(Icons.mic_off, size: 14, color: Colors.red),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: color ?? (isActive ? Colors.white : Colors.white24),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(
                icon,
                color: color != null
                    ? Colors.white
                    : (isActive ? Colors.black87 : Colors.white),
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
