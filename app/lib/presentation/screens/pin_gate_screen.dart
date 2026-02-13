/// OrBeit Security — PIN Gate Screen
///
/// The first screen a user sees when opening the app.
/// Accepts either the master PIN (normal access) or the
/// duress PIN (panic mode — shows dummy world).
///
/// Design: Dark, minimal, no hints about what's behind the gate.
/// Looks like a standard app lock screen — nothing suspicious.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/secure_storage_service.dart';
import '../../services/duress_mode_service.dart';

class PinGateScreen extends StatefulWidget {
  final SecureStorageService secureStorage;
  final DuressModeService duressModeService;
  final VoidCallback onAuthenticated;

  const PinGateScreen({
    super.key,
    required this.secureStorage,
    required this.duressModeService,
    required this.onAuthenticated,
  });

  @override
  State<PinGateScreen> createState() => _PinGateScreenState();
}

class _PinGateScreenState extends State<PinGateScreen>
    with SingleTickerProviderStateMixin {
  String _enteredPin = '';
  bool _isSettingUp = false;
  bool _isLoading = true; // Wait for _checkFirstLaunch
  bool _isSubmitting = false;
  String _setupMasterPin = '';
  String _setupDuressPin = '';
  int _setupStep = 0; // 0=master, 1=confirm master, 2=duress, 3=confirm duress
  bool _showError = false;
  String _errorMessage = '';
  int _failedAttempts = 0;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    _checkFirstLaunch();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _checkFirstLaunch() async {
    try {
      final hasMasterPin = await widget.secureStorage.containsKey(SecureKeys.masterPin);
      debugPrint('[PIN Gate] Has master PIN: $hasMasterPin');
      if (!hasMasterPin) {
        setState(() {
          _isSettingUp = true;
          _setupStep = 0;
        });
      }
    } catch (e) {
      debugPrint('[PIN Gate] ERROR in _checkFirstLaunch: $e');
      // Assume first launch if keychain fails
      setState(() {
        _isSettingUp = true;
        _setupStep = 0;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String get _promptText {
    if (_isSettingUp) {
      switch (_setupStep) {
        case 0:
          return 'Create Your PIN';
        case 1:
          return 'Confirm Your PIN';
        case 2:
          return 'Set Emergency PIN';
        case 3:
          return 'Confirm Emergency PIN';
        default:
          return '';
      }
    }
    return 'Enter PIN';
  }

  String get _subtitleText {
    if (_isSettingUp) {
      switch (_setupStep) {
        case 0:
          return 'Choose a 6-digit PIN to unlock your world';
        case 1:
          return 'Enter it again to confirm';
        case 2:
          return 'Use this if forced to open the app\nIt shows a convincing empty world';
        case 3:
          return 'Confirm your emergency PIN';
        default:
          return '';
      }
    }
    if (_errorMessage.isNotEmpty) {
      return _errorMessage;
    }
    if (_failedAttempts > 0) {
      return 'Incorrect PIN';
    }
    return 'Welcome back';
  }

  /// Handle physical keyboard input
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Number keys (both main keyboard and numpad)
    final digitMap = {
      LogicalKeyboardKey.digit0: '0', LogicalKeyboardKey.numpad0: '0',
      LogicalKeyboardKey.digit1: '1', LogicalKeyboardKey.numpad1: '1',
      LogicalKeyboardKey.digit2: '2', LogicalKeyboardKey.numpad2: '2',
      LogicalKeyboardKey.digit3: '3', LogicalKeyboardKey.numpad3: '3',
      LogicalKeyboardKey.digit4: '4', LogicalKeyboardKey.numpad4: '4',
      LogicalKeyboardKey.digit5: '5', LogicalKeyboardKey.numpad5: '5',
      LogicalKeyboardKey.digit6: '6', LogicalKeyboardKey.numpad6: '6',
      LogicalKeyboardKey.digit7: '7', LogicalKeyboardKey.numpad7: '7',
      LogicalKeyboardKey.digit8: '8', LogicalKeyboardKey.numpad8: '8',
      LogicalKeyboardKey.digit9: '9', LogicalKeyboardKey.numpad9: '9',
    };

    if (digitMap.containsKey(key)) {
      _onDigitPressed(digitMap[key]!);
      return KeyEventResult.handled;
    }

    // Backspace
    if (key == LogicalKeyboardKey.backspace) {
      _onBackspace();
      return KeyEventResult.handled;
    }

    // Enter/Return — submit PIN
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
      if (_enteredPin.length == 6) {
        _doSubmit();
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void _onDigitPressed(String digit) {
    if (_enteredPin.length >= 6 || _isSubmitting) return;

    setState(() {
      _enteredPin += digit;
      _showError = false;
      _errorMessage = '';
    });

    debugPrint('[PIN Gate] Digit entered. Length: ${_enteredPin.length}');

    // Auto-submit when all 6 digits are entered
    if (_enteredPin.length == 6) {
      debugPrint('[PIN Gate] 6 digits reached — scheduling submit');
      // Use post-frame callback to ensure UI has updated
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _doSubmit();
      });
    }
  }

  void _onBackspace() {
    if (_enteredPin.isEmpty || _isSubmitting) return;
    setState(() {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      _showError = false;
      _errorMessage = '';
    });
  }

  /// Central submit — called from auto-submit, checkmark, or Enter key
  Future<void> _doSubmit() async {
    if (_enteredPin.length != 6 || _isSubmitting) {
      debugPrint('[PIN Gate] _doSubmit aborted: length=${_enteredPin.length}, submitting=$_isSubmitting');
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await _submitPin();
    } catch (e, stack) {
      debugPrint('[PIN Gate] EXCEPTION in _doSubmit: $e');
      debugPrint('[PIN Gate] Stack: $stack');
      setState(() {
        _showError = true;
        _errorMessage = 'System error: $e';
        _enteredPin = '';
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _submitPin() async {
    debugPrint('[PIN Gate] _submitPin called. isSettingUp=$_isSettingUp, step=$_setupStep, pin length=${_enteredPin.length}');
    if (_isSettingUp) {
      await _handleSetup();
    } else {
      await _handleLogin();
    }
  }

  Future<void> _handleSetup() async {
    final pin = _enteredPin;
    debugPrint('[PIN Gate] _handleSetup step=$_setupStep, pin="${pin.replaceAll(RegExp(r'.'), '*')}"');

    switch (_setupStep) {
      case 0: // Set master PIN
        _setupMasterPin = pin;
        setState(() {
          _enteredPin = '';
          _setupStep = 1;
        });
        debugPrint('[PIN Gate] Master PIN captured, moving to confirm step');
        break;

      case 1: // Confirm master PIN
        if (pin == _setupMasterPin) {
          await widget.secureStorage.setMasterPin(pin);
          setState(() {
            _enteredPin = '';
            _setupStep = 2;
          });
          debugPrint('[PIN Gate] Master PIN confirmed & saved, moving to duress step');
        } else {
          debugPrint('[PIN Gate] Master PIN confirmation FAILED — restarting');
          _triggerError();
          setState(() {
            _enteredPin = '';
            _setupStep = 0;
            _setupMasterPin = '';
          });
        }
        break;

      case 2: // Set duress PIN
        if (pin == _setupMasterPin) {
          // Can't use same PIN as master!
          debugPrint('[PIN Gate] Duress PIN same as master — rejected');
          _triggerError();
          setState(() {
            _enteredPin = '';
          });
          return;
        }
        _setupDuressPin = pin;
        setState(() {
          _enteredPin = '';
          _setupStep = 3;
        });
        debugPrint('[PIN Gate] Duress PIN captured, moving to confirm step');
        break;

      case 3: // Confirm duress PIN
        if (pin == _setupDuressPin) {
          await widget.secureStorage.setDuressPin(pin);
          debugPrint('[PIN Gate] Setup COMPLETE — signing in normally');
          widget.duressModeService.activateNormalMode();
          await widget.secureStorage.recordAuth();
          widget.onAuthenticated();
        } else {
          debugPrint('[PIN Gate] Duress PIN confirmation FAILED — restarting duress');
          _triggerError();
          setState(() {
            _enteredPin = '';
            _setupStep = 2;
            _setupDuressPin = '';
          });
        }
        break;
    }
  }

  Future<void> _handleLogin() async {
    final pin = _enteredPin;
    debugPrint('[PIN Gate] _handleLogin called');

    // Check duress PIN FIRST (before master)
    final isDuress = await widget.secureStorage.isDuressPin(pin);
    if (isDuress) {
      debugPrint('[PIN Gate] DURESS PIN detected');
      widget.duressModeService.activateDuressMode();
      widget.onAuthenticated();
      return;
    }

    // Check master PIN
    final isCorrect = await widget.secureStorage.verifyMasterPin(pin);
    if (isCorrect) {
      debugPrint('[PIN Gate] Master PIN correct — signing in');
      widget.duressModeService.activateNormalMode();
      await widget.secureStorage.recordAuth();
      widget.onAuthenticated();
      return;
    }

    // Wrong PIN
    _failedAttempts++;
    debugPrint('[PIN Gate] Wrong PIN. Attempts: $_failedAttempts');
    _triggerError();
    setState(() {
      _enteredPin = '';
    });
  }

  void _triggerError() {
    setState(() {
      _showError = true;
      _enteredPin = '';
    });
    _shakeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0A14),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
        ),
      );
    }

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A14),
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── Logo / Icon ──
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF00BCD4).withValues(alpha: 0.3),
                      const Color(0xFF0A0A14),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Color(0xFFD4AF37),
                  size: 36,
                ),
              ),

              const SizedBox(height: 32),

              // ── Prompt Text ──
              Text(
                _promptText,
                style: const TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _subtitleText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _showError
                      ? const Color(0xFFFF5252)
                      : const Color(0xFF808080),
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),

              const SizedBox(height: 40),

              // ── PIN Dots ──
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  final shake = _showError
                      ? (1 - _shakeAnimation.value) * 10 *
                          (_shakeAnimation.value * 3.14).remainder(1)
                      : 0.0;
                  return Transform.translate(
                    offset: Offset(shake, 0),
                    child: child,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    final filled = index < _enteredPin.length;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: filled
                            ? (_showError
                                ? const Color(0xFFFF5252)
                                : const Color(0xFFD4AF37))
                            : Colors.transparent,
                        border: Border.all(
                          color: _showError
                              ? const Color(0xFFFF5252).withValues(alpha: 0.5)
                              : const Color(0xFFD4AF37).withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // ── Digit count hint ──
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  '${_enteredPin.length} / 6',
                  style: TextStyle(
                    color: const Color(0xFF808080).withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // ── Number Pad ──
              _buildNumberPad(),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 16),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 16),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 16),
          _buildRow(['⌫', '0', '✓']),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        if (key == '⌫') {
          return _buildKey(key, onTap: _onBackspace);
        }
        if (key == '✓') {
          return _buildKey(
            key,
            onTap: () {
              debugPrint('[PIN Gate] Checkmark tapped. Length: ${_enteredPin.length}');
              if (_enteredPin.length == 6) {
                _doSubmit();
              }
            },
            highlight: _enteredPin.length == 6,
          );
        }
        return _buildKey(key, onTap: () => _onDigitPressed(key));
      }).toList(),
    );
  }

  Widget _buildKey(String label, {required VoidCallback onTap, bool highlight = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: highlight
              ? const Color(0xFFD4AF37).withValues(alpha: 0.2)
              : const Color(0xFF1A1A2E),
          border: Border.all(
            color: highlight
                ? const Color(0xFFD4AF37)
                : const Color(0xFFD4AF37).withValues(alpha: 0.15),
            width: highlight ? 2 : 1,
          ),
        ),
        child: Center(
          child: label == '⌫'
              ? const Icon(
                  Icons.backspace_outlined,
                  color: Color(0xFF808080),
                  size: 22,
                )
              : label == '✓'
                  ? Icon(
                      Icons.check,
                      color: highlight
                          ? const Color(0xFFD4AF37)
                          : const Color(0xFF808080),
                      size: 28,
                    )
                  : Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xFFE0E0E0),
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
        ),
      ),
    );
  }
}
