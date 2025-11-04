import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/auth_state.dart';
import '../../../core/models/user_session.dart';
import '../../../core/repositories/user_sessions_repository.dart';
import '../../../core/services/snackbar_service.dart';

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  final bool loadSessionsOnInit;
  final List<UserSession>? initialSessions; // for tests/harness only
  // Test-only seam: when provided, renders a small button to trigger terminate
  final String? debugTerminateSessionId;
  // Test-only seam: when provided, will be called with result of terminate (true=success, false=error)
  final void Function(bool success)? onDebugTerminateResult;
  final bool debugAutoTrigger;
  final void Function(VoidCallback trigger)? debugExposeTerminate;
  const SecuritySettingsScreen({
    super.key,
    this.loadSessionsOnInit = true,
    this.initialSessions,
    this.debugTerminateSessionId,
    this.onDebugTerminateResult,
    this.debugAutoTrigger = true,
    this.debugExposeTerminate,
  });

  @override
  ConsumerState<SecuritySettingsScreen> createState() =>
      _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState
    extends ConsumerState<SecuritySettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isSubmitting = false;
  bool _showPasswords = false;
  bool _isLoadingSessions = false;
  String? _sessionsError;
  List<UserSession> _sessions = const [];
  bool _debugResultNotified = false;

  @override
  void initState() {
    super.initState();
    if (widget.debugExposeTerminate != null && widget.debugTerminateSessionId != null) {
      final targetId = widget.debugTerminateSessionId!;
      widget.debugExposeTerminate!(() {
        final s = _sessions.firstWhere(
          (e) => e.id == targetId,
          orElse: () => UserSession(
            id: '_missing_',
            device: '',
            platform: '',
            ip: '',
            lastActive: DateTime(1970, 1, 1),
            current: false,
          ),
        );
        if (s.id != '_missing_') {
          _terminateSession(s);
        }
      });
    }
    if (widget.initialSessions != null) {
      _sessions = List<UserSession>.from(widget.initialSessions!);
      _isLoadingSessions = false;
      assert(() {
        debugPrint('SecuritySessions DEBUG init: seeded len=${_sessions.length}, ids=${_sessions.map((s) => s.id).toList()}');
        return true;
      }());
      final dbgId = widget.debugTerminateSessionId;
      if (dbgId != null) {
        final s = _sessions.firstWhere(
          (e) => e.id == dbgId,
          orElse: () => UserSession(
            id: '_missing_',
            device: '',
            platform: '',
            ip: '',
            lastActive: DateTime(1970, 1, 1),
            current: false,
          ),
        );
        if (s.id != '_missing_') {
          if (widget.debugExposeTerminate != null) {
            widget.debugExposeTerminate!(() => _terminateSession(s));
          }
          // auto-trigger is deferred to addPostFrame section
        }
      }
    }
    // Defer until after first frame to avoid inherited widget access in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.loadSessionsOnInit && widget.initialSessions == null) {
        _loadSessions();
      }
      // Auto-trigger debug terminate (for both initialSessions and loaded sessions)
      if (!mounted) return;
      final dbgId = widget.debugTerminateSessionId;
      if (dbgId != null && widget.debugAutoTrigger) {
        assert(() {
          debugPrint('SecuritySessions DEBUG auto-trigger: looking for session $dbgId in ${_sessions.map((s) => s.id).toList()}');
          return true;
        }());
        final match = _sessions.firstWhere(
          (e) => e.id == dbgId,
          orElse: () => UserSession(
            id: '_missing_',
            device: '',
            platform: '',
            ip: '',
            lastActive: DateTime(1970, 1, 1),
            current: false,
          ),
        );
        if (match.id != '_missing_') {
          assert(() {
            debugPrint('SecuritySessions DEBUG auto-trigger: found session ${match.id}, triggering terminate');
            return true;
          }());
          Future.microtask(() {
            if (!mounted) return;
            _terminateSession(match);
          });
        } else {
          assert(() {
            debugPrint('SecuritySessions DEBUG auto-trigger: session $dbgId not found');
            return true;
          }());
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant SecuritySettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSessions != null && widget.initialSessions != oldWidget.initialSessions) {
      setState(() {
        _sessions = List<UserSession>.from(widget.initialSessions!);
        _isLoadingSessions = false;
        _sessionsError = null;
      });
    }
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      final state = widget.initialSessions == null ? 'null' : 'provided';
      debugPrint('SecuritySessions DEBUG build: initialSessions is $state');
      return true;
    }());
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('security.title')),
        actions: const [],
      ),
      floatingActionButton: widget.debugTerminateSessionId != null
          ? FloatingActionButton(
              key: const ValueKey('debug_terminate_fab'),
              tooltip: 'DEBUG terminate',
              onPressed: () {
                final id = widget.debugTerminateSessionId!;
                final s = _sessions.firstWhere(
                  (e) => e.id == id,
                  orElse: () => UserSession(
                    id: '_missing_',
                    device: '',
                    platform: '',
                    ip: '',
                    lastActive: DateTime(1970, 1, 1),
                    current: false,
                  ),
                );
                if (s.id != '_missing_') {
                  _terminateSession(s);
                }
              },
              child: const Icon(Icons.bug_report),
            )
          : null,
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          // Test render anchor: helps tests ensure the tree is mounted before interactions
          const Offstage(
            offstage: true,
            key: ValueKey('render_anchor'),
            child: SizedBox.shrink(),
          ),
          _buildChangePasswordCard(context),
          const SizedBox(height: 16),
          _buildSecurityOptionsCard(context),
          const SizedBox(height: 16),
          _buildActiveSessionsCard(context),
        ],
      ),
    );
  }

  void _notifyDebugResult(bool success) {
    if (widget.onDebugTerminateResult != null && !_debugResultNotified) {
      assert(() {
        debugPrint('SecuritySessions DEBUG notify: success=$success');
        return true;
      }());
      _debugResultNotified = true;
      widget.onDebugTerminateResult!(success);
    }
  }

  Widget _buildChangePasswordCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr('security.changePassword'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _currentController,
                obscureText: !_showPasswords,
                decoration: InputDecoration(
                  labelText: tr('security.currentPassword'),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                validator: (v) => (v == null || v.isEmpty)
                    ? tr('security.enterCurrentPassword')
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _newController,
                obscureText: !_showPasswords,
                decoration: InputDecoration(
                  labelText: tr('security.newPassword'),
                  prefixIcon: const Icon(Icons.lock_reset),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return tr('security.enterNewPassword');
                  }
                  if (v.length < 8) {
                    return tr('security.passwordTooShort');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmController,
                obscureText: !_showPasswords,
                decoration: InputDecoration(
                  labelText: tr('security.confirmNewPassword'),
                  prefixIcon: const Icon(Icons.check_circle_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPasswords ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _showPasswords = !_showPasswords),
                  ),
                ),
                validator: (v) => v != _newController.text
                    ? tr('security.confirmNotMatch')
                    : null,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitChangePassword,
                  icon: const Icon(Icons.save),
                  label: Text(
                    _isSubmitting
                        ? tr('security.updating')
                        : tr('security.updatePassword'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityOptionsCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: Text(tr('security.biometricsTitle')),
            subtitle: Text(tr('security.comingSoon')),
            trailing: const Switch(value: false, onChanged: null),
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: Text(tr('security.twoFactor')),
            subtitle: Text(tr('security.comingSoon')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSessionsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    tr('security.activeSessions'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  // Test-only seam: expose a deterministic button to trigger terminate
                  if (widget.debugTerminateSessionId != null)
                    TextButton.icon(
                      key: const ValueKey('debug_terminate'),
                      onPressed: () {
                        final id = widget.debugTerminateSessionId!;
                        final s = _sessions.firstWhere(
                          (e) => e.id == id,
                          orElse: () => UserSession(
                            id: '_missing_',
                            device: '',
                            platform: '',
                            ip: '',
                            lastActive: DateTime(1970, 1, 1),
                            current: false,
                          ),
                        );
                        if (s.id != '_missing_') {
                          _terminateSession(s);
                        }
                      },
                      icon: const Icon(Icons.bug_report, size: 18),
                      label: const Text('DEBUG'),
                    ),
                  IconButton(
                    tooltip: tr('security.refresh'),
                    icon: const Icon(Icons.refresh),
                    onPressed: _isLoadingSessions ? null : _loadSessions,
                  ),
                ],
              ),
            ),
            // Debug: surface state in test logs
            Builder(
              builder: (_) {
                // This is safe in production; it only prints in debug/test modes
                // and helps stabilize tests by revealing state timing.
                assert(() {
                  final err = _sessionsError ?? 'null';
                  debugPrint('SecuritySessions DEBUG: len=$_sessions.length, loading=$_isLoadingSessions, error=$err');
                  return true;
                }());
                return const SizedBox.shrink();
              },
            ),
            if (_isLoadingSessions)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_sessionsError != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  _sessionsError!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (_sessions.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(tr('security.noSessions')),
              )
            else
              ..._sessions.map(
                (s) => Column(
                  children: [
                    ListTile(
                      key: ValueKey('session_${s.id}'),
                      leading: Icon(_iconForPlatform(s.platform)),
                      title: Text('${s.device} • ${s.platform}'),
                      subtitle: Text('${s.ip} • ${s.lastActiveDisplay}'),
                      trailing: s.current
                          ? Chip(label: Text(tr('security.current')))
                          : TextButton.icon(
                              key: ValueKey('logout_${s.id}'),
                              onPressed: () => _terminateSession(s),
                              icon: const Icon(Icons.logout),
                              label: Text(tr('security.logout')),
                            ),
                    ),
                    const Divider(height: 0),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitChangePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);
    final ok = await ref
        .read(authProvider.notifier)
        .changePassword(
          currentPassword: _currentController.text,
          newPassword: _newController.text,
        );
    if (!mounted) {
      return;
    }
    setState(() => _isSubmitting = false);

    if (ok) {
      SnackbarService.showSuccess(
        context,
        tr('security.changePasswordSuccess'),
      );
      _currentController.clear();
      _newController.clear();
      _confirmController.clear();
    } else {
      final err =
          ref.read(authProvider).error ?? tr('security.changePasswordFailed');
      SnackbarService.showError(context, err);
    }
  }

  Future<void> _loadSessions() async {
    setState(() {
      _isLoadingSessions = true;
      _sessionsError = null;
    });

    try {
      final repo = ref.read(userSessionsRepositoryProvider);
      final sessions = await repo.getSessions();
      if (!mounted) return;
      setState(() => _sessions = sessions);
    } catch (e) {
      if (!mounted) return;
      setState(() => _sessionsError = tr(
            'security.loadSessionsError',
            args: [e.toString()],
          ));
      SnackbarService.showError(
        context,
        tr('security.sessionsErrorSnack', args: [e.toString()]),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingSessions = false);
      }
    }
  }

  Future<void> _terminateSession(UserSession session) async {
    assert(() {
      debugPrint('SecuritySessions DEBUG terminate start: id=${session.id}');
      return true;
    }());
    try {
      final repo = ref.read(userSessionsRepositoryProvider);
      await repo.terminateSession(session.id);
      assert(() {
        debugPrint('SecuritySessions DEBUG _notifyDebugResult: true');
        return true;
      }());
      _notifyDebugResult(true);
      if (!mounted) return;
      setState(() {
        _sessions = _sessions.where((s) => s.id != session.id).toList();
      });
      SnackbarService.showSuccess(context, tr('security.logoutSuccess'));
    } catch (e) {
      assert(() {
        debugPrint('SecuritySessions DEBUG _notifyDebugResult: false');
        return true;
      }());
      _notifyDebugResult(false);
      if (mounted) {
        SnackbarService.showError(
          context,
          tr('security.logoutFailed', args: [e.toString()]),
        );
      }
    }
  }

  IconData _iconForPlatform(String platform) {
    final p = platform.toLowerCase();
    if (p.contains('ios') || p.contains('iphone') || p.contains('ipad')) {
      return Icons.phone_iphone;
    }
    if (p.contains('android')) {
      return Icons.android;
    }
    if (p.contains('mac') || p.contains('darwin')) {
      return Icons.laptop_mac;
    }
    if (p.contains('windows')) {
      return Icons.desktop_windows;
    }
    if (p.contains('linux')) {
      return Icons.laptop;
    }
    if (p.contains('web') || p.contains('chrome') || p.contains('safari') || p.contains('firefox') || p.contains('edge')) {
      return Icons.public;
    }
    return Icons.devices_other;
  }
}
