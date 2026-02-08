import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/genesis_kit.dart';
import '../../providers/genesis_provider.dart';
import '../../main.dart'; // To navigate to GameScreen

/// The Narrative Gate that users must pass before entering the system.
///
/// **Philosophy:**
/// "The Grid is locked until the Vow is made."
/// This screen establishes the "Digital Ephod" context.
class CovenantScreen extends ConsumerStatefulWidget {
  const CovenantScreen({super.key});

  @override
  ConsumerState<CovenantScreen> createState() => _CovenantScreenState();
}

class _CovenantScreenState extends ConsumerState<CovenantScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A12), // Deepest Void
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. The Sigil (Placeholder Icon)
              const Icon(
                Icons.shield_outlined,
                size: 80,
                color: Color(0xFFD4AF37), // Sovereign Gold
              ),
              const SizedBox(height: 48),

              // 2. The Title
              const Text(
                'THE COVENANT',
                style: TextStyle(
                  fontFamily: 'Roboto', // TODO: Switch to Cinzel or similar
                  fontSize: 24,
                  letterSpacing: 4.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
              ),
              const SizedBox(height: 32),

              // 3. The Vow Text
              const Text(
                'We do not build to escape life.\nWe build to govern it.\n\n'
                'By entering, you vow to use this tool\n'
                'for Stewardship, not Distraction.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.6,
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 64),

              // 4. The Action (Gate Key)
              if (_isLoading)
                const CircularProgressIndicator(color: Color(0xFFD4AF37))
              else
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFD4AF37)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: _makeVow,
                  child: const Text(
                    'I VOW',
                    style: TextStyle(
                      letterSpacing: 2.0,
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makeVow() async {
    setState(() => _isLoading = true);

    try {
      // 1. Spawn the Genesis Kit (The Steward Archetype)
      // This instantiates the Home, Barn, Truck, and Feed Log instantly.
      final genesisRepo = ref.read(genesisRepositoryProvider);
      
      // Spawn at the center of the grid (roughly 10,10 for now)
      await genesisRepo.spawnKit(GenesisKit.steward, 10, 10);
      
      // Spawn the Town nearby
      await genesisRepo.spawnKit(GenesisKit.town, 20, 15);

      if (mounted) {
        // 2. Navigate to the World
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GameScreen()),
        );
      }
    } catch (e) {
      // Handle error gracefully
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification Failed: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }
}
