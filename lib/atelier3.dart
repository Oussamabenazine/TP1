/*import 'package:flutter/material.dart';
// Importez le modèle Product depuis atelier2.dart
import 'atelier2.dart'; 

class ProductDetailPage extends StatefulWidget {
  final Product product;
  
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // ValueNotifier pour gérer la quantité (utilisé à l'étape 3/4)
  final ValueNotifier<int> _quantity = ValueNotifier<int>(1);
 
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          
          // Étape 1: SliverAppBar avec l'image étirable (Mise à jour pour Asset)
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.product.name, 
                style: TextStyle(color: colorScheme.onSurface),
              ),
              background: Hero(
                tag: widget.product.name, // Animation entre la liste et la page de détails
                child: Image.asset(
                  widget.product.image, // Utilise le chemin d'asset local
                  fit: BoxFit.cover,
                  // Gestion d'erreur au cas où l'asset n'est pas trouvé
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.broken_image, size: 80, color: Colors.grey));
                  },
                ),
              ),
            ),
          ),
          
          // Étape 2: Contenu détaillé dans une SliverList
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom et Prix
                      Text(
                        widget.product.name,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.product.price}€',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const Divider(height: 32),

                      // Description
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Découvrez ce produit haute performance conçu pour répondre à tous vos besoins. Design élégant et fonctionnalités avancées.',
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                      
                      const Divider(height: 32),

                      // TODO Étape 3: Sélecteur de quantité (Ajout ici pour compléter la structure)
                      Text(
                        'Quantité',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      ValueListenableBuilder<int>(
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
                                  onPressed: quantity > 1 ? () {
                                    _quantity.value--;
                                  } : null,
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
                      ),
                    
                      const SizedBox(height: 100), // Espace pour le bouton fixe en bas
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      
      // TODO Étape 4: Bouton fixe en bas
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _quantity,
        builder: (context, quantity, child) {
          final totalPrice = (widget.product.price * quantity).toStringAsFixed(2);
          
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total', style: Theme.of(context).textTheme.labelLarge),
                    Text(
                      '$totalPrice€',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      // Action d'ajout au panier
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$quantity x ${widget.product.name} ajouté au panier pour $totalPrice€'),
                          duration: const Duration(seconds: 2),
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
          );
        }
      ),
    );
  }
}*/