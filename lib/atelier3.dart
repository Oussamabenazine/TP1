import 'package:flutter/material.dart';
// Assurez-vous d'importer atelier2.dart ou d'avoir le modèle Product accessible
// Ici, on fait une copie du modèle pour que le fichier soit complet si vous le copiez seul
import 'atelier2.dart'; 

class ProductDetailPage extends StatefulWidget {
  final Product product;
  
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // Gère l'état simple de la quantité
  final ValueNotifier<int> _quantity = ValueNotifier<int>(1);
 
  @override
  void dispose() {
    _quantity.dispose();
    super.dispose();
  }

  // Widget utilitaire pour le sélecteur de quantité [cite: 10]
  Widget _buildQuantitySelector(ColorScheme colorScheme, BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _quantity,
      builder: (context, quantity, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outline),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: quantity > 1
                    ? () {
                        _quantity.value--;
                      }
                    : null, // Désactiver si quantité = 1
              ),
              SizedBox(
                width: 40,
                child: Text(
                  quantity.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _quantity.value++;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget utilitaire pour l'affichage du prix total en bas
  Widget _buildBottomPriceDisplay(double basePrice, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<int>(
      valueListenable: _quantity, // Écoute les changements de quantité
      builder: (context, quantity, child) {
        final totalPrice = basePrice * quantity;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
             Text('Prix total:', style: Theme.of(context).textTheme.bodySmall),
             Text(
              '${totalPrice.toStringAsFixed(2)}€',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ],
        );
      },
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      // Utilisation de CustomScrollView avec Slivers pour un effet d'image étirable
      body: CustomScrollView(
        slivers: [
          // TODO Étape 1: SliverAppBar avec l'image du produit [cite: 7]
          SliverAppBar(
            expandedHeight: 300,
            pinned: true, // Laisse l'App Bar visible lors du défilement
            flexibleSpace: FlexibleSpaceBar(
              // Le titre s'affiche quand l'App Bar est réduite
              title: Text(
                widget.product.name, 
                style: TextStyle(color: colorScheme.onSurface),
              ),
              background: Image.network(
                widget.product.image,
                fit: BoxFit.cover,
              ),
            ),
            // NOUVEAU: Bouton pour revenir à la liste des produits
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            // NOUVEAU: Bouton pour aller à la section profil
            actions: [
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () {
                  // Utiliser pushReplacement pour remplacer la pile (revenir à /products puis /profile)
                  Navigator.pushReplacementNamed(context, '/profile');
                },
                tooltip: 'Gérer le profil',
              ),
            ],
          ),
          
          // TODO Étape 2: Contenu détaillé (informations produit) [cite: 8]
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Prix et Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.product.price.toStringAsFixed(2)}€',
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber.shade600, size: 20),
                          const SizedBox(width: 4),
                          // Placeholder pour le nombre d'avis
                          Text('${widget.product.rating} (128 avis)', style: textTheme.bodyLarge),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Description
                  Text('Description', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    'Découvrez le ${widget.product.name}, un produit haute performance conçu pour répondre à tous vos besoins. Design élégant et fonctionnalités avancées.',
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 32),

                  // TODO Étape 3: Sélecteur de quantité
                  Text('Quantité', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildQuantitySelector(colorScheme, context),
                  
                  // Espace pour le bouton fixe en bas [cite: 1]
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ),
        ],
      ),
      
      // TODO Étape 4: Bouton fixe en bas (bottomNavigationBar) [cite: 12]
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          // Ligne de séparation
          border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
        ),
        child: SafeArea( // Garantit que le contenu est sous la zone de sécurité (encoche, etc.)
          child: Row(
            children: [
              // Zone d'affichage du prix résultant
              _buildBottomPriceDisplay(widget.product.price, context),
              
              const SizedBox(width: 12),
              
              // Bouton "Ajouter au panier"
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    // Action d'ajout au panier
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${_quantity.value}x ${widget.product.name} ajouté au panier.'),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Ajouter au panier'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}