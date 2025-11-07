import 'package:flutter/material.dart';
// Importe la page de détails pour la navigation
import 'atelier4.dart'; 

// CLASSE PRODUCT : Définie UNIQUEMENT ici (Source unique de vérité)
class Product {
  final String name;
  final double price;
  final String image; // Ce champ contient l'URL du fichier uploadé
  final bool isNew;
  final double rating;
  final bool isFavorite; // Champ pour l'état favori

  const Product(
    this.name, 
    this.price, 
    this.image, 
    {
      this.isNew = false, 
      this.rating = 0.0,
      this.isFavorite = false, // Valeur par défaut à FALSE
    }
  );
  
  // Méthode copyWith pour créer une nouvelle instance avec des valeurs modifiées (pour l'immutabilité)
  Product copyWith({bool? isFavorite}) {
    return Product(
      name,
      price,
      image,
      isNew: isNew,
      rating: rating,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

// CONVERSION EN STATEFULWIDGET
class ProductListPageM3 extends StatefulWidget {
  const ProductListPageM3({super.key});

  @override
  State<ProductListPageM3> createState() => _ProductListPageM3State();
}

class _ProductListPageM3State extends State<ProductListPageM3> {
  // Déplacer la liste ici et la rendre mutable
  List<Product> products = [
    // Tous les produits sont initialement à isFavorite: false
    Product('iPhone 15', 999.00, 'assets/images/iphone-15.jpg', isNew: true, rating: 4.5, isFavorite: false),
    Product('Samsung Galaxy', 799.00, 'assets/images/samsung.jpg', isNew: true, rating: 4.2, isFavorite: false),
    Product('Google Pixel', 699.00, 'assets/images/google.jpg', isNew: true, rating: 4.7, isFavorite: false),
  ];

  // Méthode pour basculer l'état "favori" depuis la carte
  void _toggleFavorite(int index) {
    setState(() {
      final oldProduct = products[index];
      // Créer un nouveau produit avec l'état favori inversé et remplacer l'ancien
      products[index] = oldProduct.copyWith(isFavorite: !oldProduct.isFavorite);
    });
  }
  
  // Méthode pour mettre à jour un produit après le retour de la page de détail
  void _updateProduct(Product updatedProduct) {
    setState(() {
      // Trouver l'index du produit mis à jour
      final index = products.indexWhere((p) => p.name == updatedProduct.name);
      if (index != -1) {
        products[index] = updatedProduct;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos Produits'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
        IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () {
            // CORRECTION : Utiliser pushReplacementNamed pour revenir à la route du profil
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
          
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            child: InkWell( 
              // MISE À JOUR : Attendre le résultat de la page de détail
              onTap: () async {
                final updatedProduct = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: product),
                  ),
                );

                if (updatedProduct != null && updatedProduct is Product) {
                  _updateProduct(updatedProduct);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network( // Image.network est nécessaire pour ces URLs
                              product.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback visuel si l'image ne charge pas
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
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'NEW',
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name, 
                            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber.shade600, size: 16),
                              const SizedBox(width: 4),
                              Text(product.rating.toString()),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${product.price}€',
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Icône de favori avec interaction
                    IconButton(
                      icon: Icon(
                        product.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: product.isFavorite ? colorScheme.error : colorScheme.outline, 
                      ),
                      onPressed: () => _toggleFavorite(index), // APPEL À LA MISE À JOUR D'ÉTAT
                      tooltip: product.isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
                    ),
                    const SizedBox(width: 8), 

                    FilledButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.add_shopping_cart, color: colorScheme.onPrimary),
                        label: const Text("Acheter"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}