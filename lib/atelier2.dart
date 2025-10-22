import 'package:flutter/material.dart';
// Importez la page de détails
import 'atelier3.dart'; 
// import 'atelier1.dart'; // Not needed; removed to fix unused import warning

// Modèle de données Product
class Product {
  final String name;
  final double price;
  final String image;
  final bool isNew;
  final double rating;

  const Product(
    this.name, this.price, this.image, {this.isNew = false, this.rating = 0.0,}
  );
}

class ProductListPageM3 extends StatelessWidget {
  const ProductListPageM3({super.key});

  final List<Product> products = const [
    Product('iPhone 15', 999, 'https://picsum.photos/200/300', isNew: true, rating: 4.5,),
    Product('Samsung Galaxy', 799, 'https://picsum.photos/201/300', isNew: false, rating: 4.2,),
    Product('Google Pixel', 699, 'https://picsum.photos/202/300', isNew: true, rating: 4.7,),
  ];

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
          // Bouton vers le profil (navigation principale)
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
          
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            // NOUVEAU: Rend la carte cliquable pour naviguer
            child: InkWell( 
              onTap: () {
                // Navigation vers la page de détails en passant le produit
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: product),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image avec badge "Nouveau" (Identique)
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(product.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (product.isNew)
                          Positioned(
                            top: 4,
                            left: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'NEW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),

                    // Informations du produit (Identique)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
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

                    // Bouton d'action (Remplacé par l'action du Card)
                    FilledButton.icon(
                        onPressed: () {
                          // Action d'achat rapide
                          debugPrint('Ajouter ${product.name} au panier');
                        },
                        icon: Icon(
                          Icons.add_shopping_cart,
                          color: colorScheme.onPrimary,
                        ),
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