import 'package:flutter/material.dart';
// IMPORTANT : Nous importons la définition unique de Product depuis atelier2.dart
import 'atelier2.dart'; 

// CONVERSION EN STATEFULWIDGET pour gérer l'interaction et le retour
class ProductDetailPage extends StatefulWidget {
  final Product product;
  
  const ProductDetailPage({super.key, required this.product});
  
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // Copie locale du produit pour pouvoir basculer l'état
  late Product _localProduct;
  
  // AJOUT DE L'ÉTAT : Quantité
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    // Initialiser la copie locale avec le produit passé
    _localProduct = widget.product;
  }

  // Fonction pour basculer l'état "favori" localement
  void _toggleFavorite() {
    setState(() {
      // Utiliser copyWith de la classe Product pour basculer l'état
      _localProduct = _localProduct.copyWith(isFavorite: !_localProduct.isFavorite);
    });
  }
  
  // Fonction pour incrémenter/décrémenter la quantité
  void _updateQuantity(int delta) {
    setState(() {
      _quantity = (_quantity + delta).clamp(1, 10); // Limite la quantité entre 1 et 10
    });
  }

  // Widget pour le compteur de quantité
  Widget _buildQuantityCounter(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8), 
        border: Border.all(color: colorScheme.outlineVariant)
      ),
      width: 140, // Largeur fixe
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 20),
            onPressed: _quantity > 1 ? () => _updateQuantity(-1) : null,
            color: colorScheme.onSurface,
            disabledColor: colorScheme.outline,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              _quantity.toString(),
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          
          IconButton(
            icon: const Icon(Icons.add, size: 20),
            onPressed: _quantity < 10 ? () => _updateQuantity(1) : null,
            color: colorScheme.onSurface,
            disabledColor: colorScheme.outline,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  // Fonction pour afficher une ligne d'information
  Widget _buildDetailRow(IconData icon, String label, String value, ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.secondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: textTheme.titleMedium,
            ),
          ),
          Text(
            value,
            style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    // Le prix est affiché et utilise maintenant la quantité locale (_quantity)
    final double totalPrice = _localProduct.price * _quantity; 
    
    return PopScope(
      // Quand l'utilisateur revient en arrière
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (!didPop) {
          // Renvoyer le produit mis à jour à la page précédente
          Navigator.pop(context, _localProduct);
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            
            // SliverAppBar avec l'image étirable
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              // NOUVEAU : Ajout de l'icône de favori avec l'interaction
              actions: [
                IconButton(
                  icon: Icon(
                    // Utiliser l'état local du produit
                    _localProduct.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _localProduct.isFavorite ? Colors.red.shade700 : Colors.white, 
                    shadows: const [
                        Shadow(offset: Offset(0, 1), blurRadius: 4, color: Colors.black54)
                    ]
                  ),
                  onPressed: _toggleFavorite, // APPEL À LA MISE À JOUR D'ÉTAT LOCAL
                ),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                // LE TITRE (NOM DU PRODUIT) EST SUPPRIMÉ
                centerTitle: false,
                background: Image.network(
                  _localProduct.image,
                  fit: BoxFit.cover,
                  // Gestion d'erreur si l'image ne charge pas
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      // FOND BLANC POUR LE FALLBACK DE L'IMAGE
                      color: const Color(0xFFFFFFFF), 
                      child: Center(
                        child: Icon(Icons.image_not_supported, size: 50, color: colorScheme.onSurfaceVariant),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Contenu principal de la page
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    // Prix et Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_localProduct.price.toStringAsFixed(2)}€',
                          style: textTheme.headlineLarge!.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 24),
                            const SizedBox(width: 4),
                            Text(
                              _localProduct.rating.toString(),
                              style: textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 40),

                    // Description
                    Text(
                      'Description du Produit',
                      style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ceci est la description détaillée du ${_localProduct.name}. Un produit de qualité supérieure avec un indice de satisfaction client élevé (Note: ${_localProduct.rating}). Ce modèle offre la meilleure technologie du moment.',
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 30),
                    
                    // Détails Techniques/Spécifiques
                     Text(
                      'Spécifications',
                      style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, color: colorScheme.secondary),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.memory, 'Capacité', '256 GB', colorScheme, textTheme),
                    _buildDetailRow(Icons.camera_alt_outlined, 'Caméra', '48 Mpx', colorScheme, textTheme),
                    _buildDetailRow(Icons.battery_full_outlined, 'Autonomie', '24 heures', colorScheme, textTheme),
                    _buildDetailRow(Icons.palette_outlined, 'Couleur', 'Noir Cosmos', colorScheme, textTheme),
                    
                    // EMPLACEMENT DU COMPTEUR DE QUANTITÉ (Après 'Couleur' et à la place du badge 'Nouveauté')
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quantité',
                            style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          _buildQuantityCounter(colorScheme, textTheme), 
                        ],
                      ),
                    ),
                    const Divider(height: 10), // Ajout d'une petite séparation

                  ],
                ),
              ),
            ),
          ],
        ),
        // Bouton Ajouter au panier en bas
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Affichage du prix total (simple)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Prix total', style: textTheme.labelLarge), // CHANGÉ 'Prix unitaire' en 'Prix total'
                  Text(
                    '${totalPrice.toStringAsFixed(2)}€',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              
              // Bouton d'action
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: FilledButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      // Simuler l'ajout au panier
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          // Utilisation de _quantity dans le message
                          content: Text('$_quantity x ${_localProduct.name} ajouté(s) au panier !'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    label: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Ajouter au panier'),
                    ),
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