import 'package:flutter/material.dart';
// Importe les modèles de données (Product et CartItem) et la page du panier (CartPage)
import 'atelier6.dart'; 

// =========================================================================
// 1. WIDGET CARTE PRODUIT AVEC DÉTAILS EXTENSIBLES (ProductCardExpandable)
// =========================================================================

class ProductCardExpandable extends StatefulWidget {
  final Product product;
  // La fonction onAddToCart reçoit la quantité sélectionnée
  final Function(int quantity) onAddToCart;

  const ProductCardExpandable({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<ProductCardExpandable> createState() => _ProductCardExpandableState();
}

class _ProductCardExpandableState extends State<ProductCardExpandable> {
  bool _isExpanded = false;
  int _quantity = 1; // État local de la quantité

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (!_isExpanded) {
        // Réinitialiser la quantité quand la carte se rétracte
        _quantity = 1; 
      }
    });
  }
  
  // NOUVELLE MÉTHODE : Permet de modifier la quantité
  /*void _updateQuantity(int delta) {
    setState(() {
      // Limiter la quantité entre 1 et 10
      _quantity = (_quantity + delta).clamp(1, 10); 
    });
  }*/
  
  Widget _buildDetailRow(String label, String value, ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_getSpecIcon(label), color: colorScheme.onSurfaceVariant, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: textTheme.bodyLarge),
          ),
          Text(value, style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  
  IconData _getSpecIcon(String label) {
    switch (label) {
      case 'Écran': return Icons.aspect_ratio_rounded;
      case 'Processeur': return Icons.memory_rounded;
      case 'Mémoire': return Icons.sd_card_outlined;
      case 'Batterie': return Icons.battery_full_outlined;
      default: return Icons.settings_suggest_outlined;
    }
  }

  // MISE À JOUR : Fonction pour centraliser et rendre les spécifications dynamiques
  Map<String, String> _getProductSpecs(String productName) {
    switch (productName) {
      case 'iPhone 15':
        return {
          'Écran': '6.1 pouces Super Retina XDR',
          'Processeur': 'A16 Bionic',
          'Mémoire': '128 GB',
          'Batterie': 'Jusqu\'à 20h de vidéo',
        };
      case 'Samsung Galaxy':
        return {
          'Écran': '6.8 pouces Dynamic AMOLED 2X',
          'Processeur': 'Snapdragon 8 Gen 2 for Galaxy',
          'Mémoire': '256 GB',
          'Batterie': '5000 mAh',
        };
      case 'Google Pixel':
        return {
          'Écran': '6.2 pouces Actua Display',
          'Processeur': 'Google Tensor G3',
          'Mémoire': '128 GB',
          'Batterie': 'Autonomie de plus de 24h',
        };
      default:
        return {}; // Retourne une map vide si non spécifié
    }
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final product = widget.product;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // 1. Contenu principal de la carte
          InkWell(
            onTap: _toggleExpansion, 
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image
                  Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(product.image, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: colorScheme.surfaceContainerHighest,
                                // ignore: deprecated_member_use
                                child: Center(child: Icon(Icons.image_not_supported, color: colorScheme.onSurfaceVariant.withOpacity(0.6))),
                              );
                            },
                          ),
                        ),
                      ),
                      if (product.isNew)
                        Positioned(
                          top: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                            child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  
                  // Titre et Prix
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber.shade600, size: 16),
                            const SizedBox(width: 4),
                            Text(product.rating.toString(), style: textTheme.titleMedium),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('${product.price.toStringAsFixed(2)}€', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary)),
                      ],
                    ),
                  ),
                  
                  // ICÔNE PANIER et Flèche d'Expansion
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.shopping_cart_outlined, color: colorScheme.secondary, size: 24),
                        // Ajout au panier 
                        onPressed: () {
                          widget.onAddToCart(_quantity); 
                          
                          // Si la carte est étendue, la rétracter 
                          if (_isExpanded) {
                            _toggleExpansion();
                          }
                        }, 
                        tooltip: 'Ajouter au panier (${_quantity}x)',
                      ),
                      Icon(
                        _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // 2. Contenu étendu
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1, indent: 0, endIndent: 0),
                  const SizedBox(height: 16),

                  // Description
                  Text('Description', style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(product.description, style: textTheme.bodyLarge),
                  const SizedBox(height: 20),
                  
                  // Spécifications (MISE À JOUR DE LA LOGIQUE)
                  Text('Spécifications', style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  // Afficher les spécifications dynamiquement
                  ..._getProductSpecs(product.name).entries.map((entry) {
                    return _buildDetailRow(entry.key, entry.value, colorScheme, textTheme);
                  }),
                  // Gérer le cas où aucune spécification n'est trouvée
                  if (_getProductSpecs(product.name).isEmpty)
                    _buildDetailRow('Détails', 'Non spécifié', colorScheme, textTheme),

                  const SizedBox(height: 20),
/*
                  // NOUVEAU : Contrôles de Quantité
                  Text('Quantité', style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Bouton de décrémentation
                      FloatingActionButton.small(
                        heroTag: 'decrement-${product.name}', // HERO TAG NÉCESSAIRE pour éviter l'erreur
                        onPressed: _quantity > 1 ? () => _updateQuantity(-1) : null,
                        tooltip: 'Diminuer la quantité',
                        child: const Icon(Icons.remove),
                      ),
                      const SizedBox(width: 20),
                      // Affichage de la quantité
                      Text(
                        _quantity.toString(),
                        style: textTheme.headlineMedium!.copyWith(color: colorScheme.primary),
                      ),
                      const SizedBox(width: 20),
                      // Bouton d'incrémentation
                      FloatingActionButton.small(
                        heroTag: 'increment-${product.name}', // HERO TAG NÉCESSAIRE pour éviter l'erreur
                        onPressed: _quantity < 10 ? () => _updateQuantity(1) : null,
                        tooltip: 'Augmenter la quantité',
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// 2. WIDGET DE LA PAGE DE LISTE (ProductListPageM3) - AUCUN CHANGEMENT ICI
// =========================================================================

class ProductListPageM3 extends StatefulWidget {
  const ProductListPageM3({super.key});

  @override
  State<ProductListPageM3> createState() => _ProductListPageM3State();
}

class _ProductListPageM3State extends State<ProductListPageM3> {
  // Product et CartItem sont importés de atelier6.dart
  final List<Product> products = const [
    Product('iPhone 15', 999.00, 'images/iphone-15.jpg', isNew: true, rating: 4.5, description: "Découvrez le iPhone 15, un produit haute performance conçu pour répondre à tous vos besoins. Design élégant et fonctionnalités avancées pour une expérience exceptionnelle."),
    Product('Samsung Galaxy', 799.00, 'images/samsung.jpg', isNew: true, rating: 4.2, description: "Le Samsung Galaxy S23 offre une expérience Android de pointe. Son design premium et son système de triple caméra en font un choix incontournable pour les amateurs de technologie."),
    Product('Google Pixel', 699.00, 'images/google.jpg', isNew: true, rating: 4.7, description: "Le Google Pixel 8 est le roi de la photographie computationnelle. Intégrant le puissant chip Tensor G3, il offre une intelligence artificielle et une pureté logicielle inégalées."),
  ];
  
  // ignore: prefer_final_fields
  List<CartItem> _cart = [];
  
  double get _cartTotal => _cart.fold(0.0, (sum, item) => sum + item.subtotal);

  void _addToCart(BuildContext context, Product product, int quantity) {
    setState(() {
      final index = _cart.indexWhere((item) => item.product.name == product.name);
      
      if (index != -1) {
        _cart[index].quantity += quantity;
      } else {
        _cart.add(CartItem(product: product, quantity: quantity));
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$quantity x ${product.name} ajouté(s) au panier !'),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }
  
  void _removeCartItem(CartItem item) {
    setState(() {
      _cart.removeWhere((i) => i.product.name == item.product.name);
    });
  }

  void _updateCartItemQuantity(CartItem item, int newQuantity) {
    if (newQuantity < 1) {
      _removeCartItem(item);
      return;
    }
    setState(() {
      item.quantity = newQuantity;
    });
  }

  // MISE À JOUR : Navigation vers la page CartPage (atelier6.dart)
  void _navigateToCartPage(BuildContext context) async {
    // Utiliser Navigator.push pour aller à une nouvelle page
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          // CartPage est importé de atelier6.dart
          return CartPage( 
            cartItems: _cart,
            cartTotal: _cartTotal,
            // Passer les fonctions pour permettre la modification du panier depuis la page CartPage
            onQuantityChanged: _updateCartItemQuantity, 
            onRemoveItem: _removeCartItem,
          );
        },
      ),
    );
    // Appeler setState() après le retour (pop) de la page du panier pour mettre à jour le badge.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos Produits'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          // Bouton Panier avec Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => _navigateToCartPage(context), // MISE À JOUR de l'appel
                tooltip: 'Voir le panier',
              ),
              // Le badge s'actualise car _cart est modifié
              if (_cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      _cart.fold(0, (sum, item) => sum + item.quantity).toString(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colorScheme.onError, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          
          // Bouton Profil
          IconButton(
            icon: const Icon(Icons.person_outline), 
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile'); 
            },
            tooltip: 'Gérer le profil',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ProductCardExpandable(
              product: product,
              onAddToCart: (quantity) => _addToCart(context, product, quantity),
            ),
          );
        },
      ),
    );
  }
}