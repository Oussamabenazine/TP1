import 'package:flutter/material.dart';

class ProfilePageM3 extends StatelessWidget {
  const ProfilePageM3({super.key});

  // Fonction helper pour construire une "chip" de statistique
  Widget _buildStatChip(String value, String label, ColorScheme colorScheme) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // Utilise une couleur de surface Material 3 pour l'arrière-plan
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        actions: [
          // Bouton pour naviguer vers la liste des produits
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              // pushReplacementNamed pour éviter d'empiler les pages principales
              Navigator.pushReplacementNamed(context, '/products'); 
            },
            tooltip: 'Voir les produits',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Étape 1: Photo de profil avec badge
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 120, // 2 * radius (60)
                  height: 120, // 2 * radius (60)
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    // CORRECTION : Le code charge uniquement l'image. 
                    // Si elle n'est pas trouvée, la zone sera vide ou affichera l'icône d'erreur par défaut de Flutter.
                    child: Image.asset(
                      'images/profile_picture.png', // Chemin d'image souhaité
                      fit: BoxFit.cover,
                      // Suppression de l'errorBuilder pour éliminer le fallback de l'icône/texte
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Étape 2: Nom et titre
            Text(
              'Oussama Ben Azine',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Graphic & UI/UX Designer',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),

            // Étape 3: Statistiques (dans un Row avec le helper _buildStatChip)
            Row(
              children: [
                _buildStatChip('15', 'Projets', colorScheme),
                const SizedBox(width: 12),
                _buildStatChip('8', 'Ans Exp.', colorScheme),
                const SizedBox(width: 12),
                _buildStatChip('4.9', 'Note', colorScheme),
              ],
            ),
            const SizedBox(height: 32),
            
            // Étape 4: Section "À propos" dans une Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          'À propos',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Passionné par le développement mobile et les technologies innovantes. J\'aime créer des applications qui améliorent la vie des utilisateurs et respectent les derniers standards UX/UI.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Étape 5: Bouton flottant
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          debugPrint('Modification du profil');
        },
        icon: const Icon(Icons.edit),
        label: const Text('Modifier le profil'),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
    );
  }
}