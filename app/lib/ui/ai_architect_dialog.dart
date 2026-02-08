
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ai_service_provider.dart';
import '../providers/building_provider.dart';
import '../providers/life_event_provider.dart';
import '../services/ai_interface.dart';
import '../data/repositories/life_event_repository_impl.dart';

class AIArchitectDialog extends ConsumerStatefulWidget {
  const AIArchitectDialog({super.key});

  @override
  ConsumerState<AIArchitectDialog> createState() => _AIArchitectDialogState();
}

class _AIArchitectDialogState extends ConsumerState<AIArchitectDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _promptController = TextEditingController();
  final _contextController = TextEditingController();
  
  bool _isLoading = false;
  String? _statusMessage;
  String? _resultData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _promptController.dispose();
    _contextController.dispose();
    super.dispose();
  }

  Future<void> _generateAsset() async {
    if (_promptController.text.isEmpty) return;
    
    _setLoading('Summoning the Architect...');
    try {
      final aiService = ref.read(aiServiceProvider);
      final buildingRepo = ref.read(buildingRepositoryProvider);
      
      final request = AssetGenerationRequest(
        assetType: 'building',
        context: _promptController.text,
        size: 'medium',
      );
      
      // 1. Generate the asset
      final response = await aiService.generateAsset(request);
      
      // 2. Calculate position (next available spot diagonal)
      final existing = await buildingRepo.getAllBuildings();
      final offset = existing.length * 60.0;
      
      // 3. Persist to World Database
      await buildingRepo.createBuilding(
        type: 'ai_generated',
        x: 200.0 + offset, 
        y: 200.0 + (offset * 0.5), // Isometric slope
      );

      _setSuccess('Manifested! Credits: ${response.creditsUsed}\nAsset placed in sovereign space.');
    } catch (e) {
      _setError(e);
    }
  }

  Future<void> _distillContext() async {
    if (_contextController.text.isEmpty) return;

    _setLoading('Distilling Life Events...');
    try {
      final aiService = ref.read(aiServiceProvider);
      final request = ContextDistillationRequest(
        rawData: _contextController.text,
        dataType: 'note_text',
        occurredAt: DateTime.now(),
      );

      final response = await aiService.distillContext(request);
      
      // Persist distilled event to database
      final lifeEventRepo = ref.read(lifeEventRepositoryProvider);
      await lifeEventRepo.createEvent(
        eventType: _mapCategoryToType(response.category),
        title: response.title,
        description: response.description,
        occurredAt: DateTime.now(),
      );
      
      _setSuccess('Distilled & Saved: ${response.title}\nCategory: ${response.category}\nEntities: ${response.entities.length}');
    } catch (e) {
      _setError(e);
    }
  }
  
  LifeEventType _mapCategoryToType(String category) {
    switch (category.toLowerCase()) {
      case 'purchase': return LifeEventType.purchase;
      case 'appointment': return LifeEventType.appointment;
      case 'milestone': return LifeEventType.milestone;
      default: return LifeEventType.memory;
    }
  }

  void _setLoading(String message) {
    setState(() {
      _isLoading = true;
      _statusMessage = message;
      _resultData = null;
    });
  }

  void _setSuccess(String result) {
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _statusMessage = 'Success!';
      _resultData = result;
    });
  }

  void _setError(Object error) {
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _statusMessage = 'Error: $error';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFD4AF37), width: 1),
      ),
      titlePadding: EdgeInsets.zero,
      title: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFF134E5E))),
        ),
        child: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFD4AF37),
          labelColor: const Color(0xFFD4AF37),
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(icon: Icon(Icons.apartment), text: 'Architect'),
            Tab(icon: Icon(Icons.psychology), text: 'Scribe'),
          ],
        ),
      ),
      content: SizedBox(
        width: 300,
        height: 350,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildArchitectTab(),
            _buildScribeTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildArchitectTab() {
    return _buildTabContent(
      hint: 'Describe the building to verify...',
      controller: _promptController,
      actionLabel: 'Manifest',
      onAction: _generateAsset,
      icon: Icons.auto_fix_high,
    );
  }

  Widget _buildScribeTab() {
    return _buildTabContent(
      hint: 'Paste a note, transcript, or thought...',
      controller: _contextController,
      actionLabel: 'Distill',
      onAction: _distillContext,
      icon: Icons.create,
    );
  }

  Widget _buildTabContent({
    required String hint,
    required TextEditingController controller,
    required String actionLabel,
    required VoidCallback onAction,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white30),
              filled: true,
              fillColor: Colors.black12,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_statusMessage != null) ...[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _resultData != null ? Colors.green.withAlpha(50) : const Color(0xFF134E5E).withAlpha(100),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _statusMessage!,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                if (_resultData != null)
                  Text(
                    _resultData!,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (_isLoading)
          const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)))
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close', style: TextStyle(color: Colors.white54)),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.black,
                ),
                icon: Icon(icon, size: 18),
                label: Text(actionLabel),
              ),
            ],
          ),
      ],
    );
  }
}
