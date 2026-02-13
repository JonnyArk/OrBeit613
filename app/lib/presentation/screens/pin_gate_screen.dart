/// OrBeit Security — PIN Gate Screen
///
/// The first screen a user sees when opening the app.
/// Accepts either the master PIN (normal access) or the
/// duress PIN (panic mode — shows dummy world).
///
/// Design: Dark, minimal, no hints about what's behind the gate.
/// Looks like a standard app lock screen — nothing suspicious.

import 'package:flutter/material.dart';
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
  String _setupMasterPin = '';
  String _setupDuressPin = '';
  int _setupStep = 0; // 0=master, 1=confirm master, 2=duress, 3=confirm duress
  bool _showError = false;
  int _failedAttempts = 0;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

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
    super.dispose();
  }

  Future<void> _checkFirstLaunch() async {
    final hasMasterPin = await widget.secureStorage.containsKey(SecureKeys.masterPin);
    if (!hasMasterPin) {
      setState(() {
        _isSettingUp = true;
        _setupStep = 0;
      });
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
          return 'This unlocks your real world';
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
    if (_failedAttempts > 0) {
      return 'Incorrect PIN';
    }
    return 'Welcome back';
  }

  void _onDigitPressed(String digit) {
    if (_enteredPin.length >= 6) return;

    setState(() {
      _enteredPin += digit;
      _showError = false;
    });

    // Auto-submit when all 6 digits are entered
    if (_enteredPin.length == 6) {
      _submitPin();
    }
  }

  void _onBackspace() {
    if (_enteredPin.isEmpty) return;
    setState(() {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      _showError = false;
    });
  }

  Future<void> _submitPin() async {
    if (_isSettingUp) {
      await _handleSetup();
    } else {
      await _handleLogin();
    }
  }

  Future<void> _handleSetup() async {
    final pin = _enteredPin;

    switch (_setupStep) {
      case 0: // Set master PIN
        _setupMasterPin = pin;
        setState(() {
          _enteredPin = '';
          _setupStep = 1;
        });
        break;

      case 1: // Confirm master PIN
        if (pin == _setupMasterPin) {
          await widget.secureStorage.setMasterPin(pin);
          setState(() {
            _enteredPin = '';
            _setupStep = 2;
          });
        } else {
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
        break;

      case 3: // Confirm duress PIN
        if (pin == _setupDuressPin) {
          await widget.secureStorage.setDuressPin(pin);
          // Setup complete — sign in normally
          widget.duressModeService.activateNormalMode();
          await widget.secureStorage.recordAuth();
          widget.onAuthenticated();
        } else {
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

    // Check duress PIN FIRST (before master)
    final isDuress = await widget.secureStorage.isDuressPin(pin);
    if (isDuress) {
      // ⚠️ DURESS MODE — show dummy world
      widget.duressModeService.activateDuressMode();
      widget.onAuthenticated();
      return;
    }

    // Check master PIN
    final isCorrect = await widget.secureStorage.verifyMasterPin(pin);
    if (isCorrect) {
      widget.duressModeService.activateNormalMode();
      await widget.secureStorage.recordAuth();
      widget.onAuthenticated();
      return;
    }

    // Wrong PIN
    _failedAttempts++;
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
    return Scaffold(
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
                  return Container(
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

            const Spacer(flex: 1),

            // ── Number Pad ──
            _buildNumberPad(),

            const Spacer(flex: 1),
          ],
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
          _buildRow(['', '0', '⌫']),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        if (key.isEmpty) {
          return const SizedBox(width: 72, height: 72);
        }
        if (key == '⌫') {
          return _buildKey(key, onTap: _onBackspace);
        }
        return _buildKey(key, onTap: () => _onDigitPressed(key));
      }).toList(),
    );
  }

  Widget _buildKey(String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF1A1A2E),
          border: Border.all(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Center(
          child: label == '⌫'
              ? const Icon(
                  Icons.backspace_outlined,
                  color: Color(0xFF808080),
                  size: 22,
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
