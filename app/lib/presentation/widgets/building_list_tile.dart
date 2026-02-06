/// OrBeit UI - Building List Tile Widget
///
/// Displays a single building in a list format.
/// Shows type, position, and selection state.

import 'package:flutter/material.dart';
import '../../domain/entities/building.dart';

/// List tile for displaying a building
class BuildingListTile extends StatelessWidget {
  final Building building;
  final bool isSelected;
  final VoidCallback? onTap;

  const BuildingListTile({
    super.key,
    required this.building,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected 
          ? theme.colorScheme.primaryContainer 
          : theme.cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: _buildIcon(theme),
        title: Text(
          _formatBuildingType(building.type),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          'Position: (${building.x.toStringAsFixed(1)}, ${building.y.toStringAsFixed(1)})',
          style: theme.textTheme.bodySmall,
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
            : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildIcon(ThemeData theme) {
    IconData icon;
    Color color;
    
    switch (building.type.toLowerCase()) {
      case 'home':
      case 'house':
      case 'farmhouse_white':
        icon = Icons.home;
        color = Colors.blue;
        break;
      case 'office':
      case 'work':
      case 'modern_office':
        icon = Icons.business;
        color = Colors.grey;
        break;
      case 'shop':
      case 'store':
        icon = Icons.storefront;
        color = Colors.orange;
        break;
      default:
        icon = Icons.location_city;
        color = theme.colorScheme.primary;
    }
    
    return CircleAvatar(
      backgroundColor: color.withAlpha(51),
      child: Icon(icon, color: color),
    );
  }

  String _formatBuildingType(String type) {
    return type
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty 
            ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}' 
            : '')
        .join(' ');
  }
}
