import 'package:flutter/material.dart';

class HouseLists extends StatelessWidget {
  const HouseLists({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 1. Outside Margin to ensure the shadow is visible
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 248, 247, 247),
        borderRadius: BorderRadius.circular(24),
        // 2. The Shadow Implementation
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.15,
            ), // Very light black/grey
            blurRadius: 20, // Softness of the shadow
            spreadRadius: 2, // Size of the shadow
            offset: const Offset(0, 2), // Moves shadow downwards
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=800',
              height: 100,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Details Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prestige Grand Apartment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF303030),
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.location_on, 'San Francisco, Californi'),
                _buildInfoRow(Icons.square_foot, '3480 Sq. Ft'),
                _buildInfoRow(Icons.person, 'William Henry'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      '\$3,000',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    Text(
                      '/month',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for the icon rows
  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF4CAF50)),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
