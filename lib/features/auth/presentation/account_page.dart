import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../l10n/l10n.dart';
import '../application/session_controller.dart';
import '../data/auth_api.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({
    super.key,
    required this.session,
    required this.wipeLocal,
  });
  final SessionController session;
  final Future<void> Function(String) wipeLocal;
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false;
  bool _busy = false;
  bool _deleting = false;
  String? _error;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
      _password.clear();
      if (mounted) Navigator.of(context).pop();
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.code);
    } catch (_) {
      if (mounted) setState(() => _error = 'server_error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final signedIn = widget.session.user != null;
    final enabled = widget.session.api.enabled;
    final error = switch (_error) {
      null => null,
      'invalid_credentials' || 'unauthorized' => l.authInvalidCredentials,
      'weak_password' => l.authPasswordRule,
      'network' => l.authNetwork,
      'storage' => l.authStorage,
      'unavailable' => l.authUnavailable,
      _ => l.authFailure,
    };
    return PopScope(
      canPop: !_busy,
      child: Scaffold(
        appBar: AppBar(title: Text(l.account)),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l.authLocalNote),
                      const SizedBox(height: 24),
                      if (!enabled) Text(l.authUnavailable),
                      if (signedIn) ...[
                        Text(
                          widget.session.user!.email,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 24),
                        if (!_deleting) ...[
                          FilledButton(
                            onPressed: _busy
                                ? null
                                : () => _run(widget.session.logout),
                            child: Text(l.signOut),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: _busy
                                ? null
                                : () => setState(() => _deleting = true),
                            child: Text(l.deleteAccount),
                          ),
                        ],
                      ],
                      if (enabled && (!signedIn || _deleting)) ...[
                        if (_deleting) ...[
                          Text(l.deleteAccountBody),
                          const SizedBox(height: 16),
                        ],
                        if (!signedIn) ...[
                          Text(
                            l.email,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _email,
                            enabled: !_busy,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            autocorrect: false,
                            decoration: InputDecoration(hintText: l.email),
                            validator: (s) => s == null || s.trim().isEmpty
                                ? l.requiredField
                                : null,
                          ),
                          const SizedBox(height: 16),
                        ],
                        Text(
                          l.password,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _password,
                          enabled: !_busy,
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          autofillHints: [
                            _register
                                ? AutofillHints.newPassword
                                : AutofillHints.password,
                          ],
                          decoration: InputDecoration(hintText: l.password),
                          validator: (s) {
                            if (s == null || s.isEmpty) return l.requiredField;
                            if (_register &&
                                (s.runes.length < 12 ||
                                    utf8.encode(s).length > 72)) {
                              return l.authPasswordRule;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        if (_register) Text(l.authPasswordRule),
                        FilledButton(
                          onPressed: _busy
                              ? null
                              : () {
                                  if (!_form.currentState!.validate()) return;
                                  _run(
                                    () => _deleting
                                        ? widget.session.deleteAccount(
                                            _password.text,
                                            widget.wipeLocal,
                                          )
                                        : widget.session.signIn(
                                            _email.text.trim(),
                                            _password.text,
                                            register: _register,
                                          ),
                                  );
                                },
                          child: Text(
                            _deleting
                                ? l.deleteAccount
                                : _register
                                ? l.register
                                : l.signIn,
                          ),
                        ),
                        TextButton(
                          onPressed: _busy
                              ? null
                              : () => setState(() {
                                  if (_deleting) {
                                    _deleting = false;
                                  } else {
                                    _register = !_register;
                                  }
                                  _password.clear();
                                  _error = null;
                                  _form.currentState?.reset();
                                }),
                          child: Text(
                            _deleting
                                ? l.cancel
                                : _register
                                ? l.signIn
                                : l.register,
                          ),
                        ),
                      ],
                      if (_busy) ...[
                        const SizedBox(height: 16),
                        const Center(child: CircularProgressIndicator()),
                      ],
                      if (error != null) ...[
                        const SizedBox(height: 16),
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            error,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
