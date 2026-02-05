/// OrBeit Game - Building Selector UI
///
/// Floating panel for selecting building types to place.
/// Shows available building options with previews.

import 'package:flutter/material.dart';
import 'sprite_manager.dart';

/// Building type data
class BuildingType {
  final String id;
  final String name;
  final String description;
  final Color color;

  const BuildingType({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
  });
}

/// Available building types
const List<BuildingType> buildingTypes = [
  BuildingType(
    id: 'farmhouse_white',
    name: 'White Farmhouse',
    description: 'A cozy home for your family',
    color: Color(0xFFF5F5F5),
  ),
  BuildingType(
    id: 'farmhouse_red',
    name: 'Red Farmhouse',
    description: 'Classic country living',
    color: Color(0xFFB22222),
  ),
  BuildingType(
    id: 'barn',
    name: 'Barn',
    description: 'Storage and workspace',
    color: Color(0xFF8B4513),
  ),
  BuildingType(
    id: 'cottage',
    name: 'Cottage',
    description: 'Guest house or hobby space',
    color: Color(0xFF98FB98),
  ),
  BuildingType(
    id: 'mansion',
    name: 'Mansion',
    description: 'Your dream home',
    color: Color(0xFFD4AF37),
  ),
];

/// Building selector panel
class BuildingSelectorPanel extends StatelessWidget {
  final Function(BuildingType) onSelect;
  final VoidCallback onClose;

  const BuildingSelectorPanel({
    super.key,
    required this.onSelect,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withAlpha(240),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(128),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          ...buildingTypes.map((type) => _BuildingTile(
            type: type,
            onTap: () => onSelect(type),
          )),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.home_work, color: Color(0xFFD4AF37)),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Place Building',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white54),
          onPressed: onClose,
        ),
      ],
    );
  }
}

class _BuildingTile extends StatelessWidget {
  final BuildingType type;
  final VoidCallback onTap;

  const _BuildingTile({required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF134E5E)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: type.color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFD4AF37)),
                  ),
                  child: const Icon(Icons.home, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        type.description,
                        style: TextStyle(
                          color: Colors.white.withAlpha(153),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.add_circle_outline, color: Color(0xFFD4AF37)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
