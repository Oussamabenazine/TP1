import 'package:flutter/material.dart';

// =========================================================================
// 1. MODÈLES DE DONNÉES
// =========================================================================

class Product {
  final String name;
  final double price;
  final String image; 
  final bool isNew;
  final double rating;
  final String description;

  const Product(
    this.name, 
    this.price, 
    this.image, 
    {
      this.isNew = false, 
      this.rating = 0.0,
      this.description = 'Ceci est une description détaillée du produit. Il offre les meilleures caractéristiques et technologies du moment. Veuillez noter que cette description est générique.',
    }
  );
}

// Article dans le panier
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  double get subtotal => product.price * quantity;
}


// =========================================================================
// 2. WIDGET CARTE PRODUIT AVEC DÉTAILS EXTENSIBLES (ProductCardExpandable)
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

  Map<String, String> get _iphone15Specs => {
    'Écran': '6.1 pouces Super Retina XDR',
    'Processeur': 'A16 Bionic',
    'Mémoire': '128 GB',
    'Batterie': 'Jusqu\'à 20h de vidéo',
  };

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
                        // MISE À JOUR : Ajoute l'article et rétracte la carte si elle est étendue.
                        onPressed: () {
                          // 1. Ajout au panier (appelle la méthode dans _ProductListPageM3State)
                          widget.onAddToCart(_quantity); 
                          
                          // 2. Si la carte est étendue, la rétracter pour masquer le compteur/prix
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
                  
                  // Spécifications
                  Text('Spécifications', style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (product.name == 'iPhone 15')
                    ..._iphone15Specs.entries.map((entry) {
                      return _buildDetailRow(entry.key, entry.value, colorScheme, textTheme);
                    })
                  else 
                    _buildDetailRow('Détails', 'Non spécifié', colorScheme, textTheme),

                  
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
// 3. WIDGET DE LA PAGE DE LISTE (ProductListPageM3)
// =========================================================================

class ProductListPageM3 extends StatefulWidget {
  const ProductListPageM3({super.key});

  @override
  State<ProductListPageM3> createState() => _ProductListPageM3State();
}

class _ProductListPageM3State extends State<ProductListPageM3> {
  final List<Product> products = const [
    Product('iPhone 15', 999.00, 'images/iphone-15.jpg', isNew: true, rating: 4.5, description: "Découvrez le iPhone 15, un produit haute performance conçu pour répondre à tous vos besoins. Design élégant et fonctionnalités avancées pour une expérience exceptionnelle."),
    Product('Samsung Galaxy', 799.00, 'images/samsung.jpg', isNew: true, rating: 4.2),
    Product('Google Pixel', 699.00, 'images/google.jpg', isNew: true, rating: 4.7),
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
      
      // La modification de _cart déclenche l'actualisation du badge de l'AppBar.
      
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

  void _showCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CartDialog(
          cartItems: _cart,
          cartTotal: _cartTotal,
          onQuantityChanged: _updateCartItemQuantity, 
          onRemoveItem: _removeCartItem,
        );
      },
    );
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
                onPressed: () => _showCartDialog(context),
                tooltip: 'Voir le panier',
              ),
              // Le badge s'actualise car _cart est modifié par _addToCart (qui appelle setState)
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
                      // Afficher le nombre total d'articles (pas d'entrées uniques)
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

// =========================================================================
// 4. WIDGET DU DIALOGUE DU PANIER (CartDialog)
// =========================================================================

class CartDialog extends StatelessWidget {
  final List<CartItem> cartItems;
  final double cartTotal;
  final Function(CartItem item, int newQuantity) onQuantityChanged;
  final Function(CartItem item) onRemoveItem;

  const CartDialog({
    super.key,
    required this.cartItems,
    required this.cartTotal,
    required this.onQuantityChanged,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Votre Panier (${cartItems.length})', style: textTheme.titleLarge),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      content: SizedBox(
        width: double.maxFinite,
        // Limiter la hauteur du contenu pour éviter le débordement sur les petits écrans
        height: cartItems.isEmpty ? 150 : 300, 
        child: cartItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 50, color: colorScheme.outline),
                    const SizedBox(height: 10),
                    Text("Votre panier est vide.", style: textTheme.bodyLarge),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(item.product.image, width: 50, height: 50, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 12),
                        
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.product.name, style: textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text('${item.product.price.toStringAsFixed(2)}€ x ${item.quantity}', style: textTheme.bodyMedium!.copyWith(color: colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: colorScheme.error),
                          onPressed: () => onRemoveItem(item),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      actions: [
        // Total et bouton Commander
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total :', style: textTheme.titleLarge),
                  Text(
                    '${cartTotal.toStringAsFixed(2)}€',
                    style: textTheme.headlineSmall!.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: cartItems.isNotEmpty
                      ? () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Commande en cours...')),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.payment),
                  label: const Text('Passer à la commande'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}