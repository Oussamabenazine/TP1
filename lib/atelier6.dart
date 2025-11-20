import 'package:flutter/material.dart';

// =========================================================================
// 1. MODÈLES DE DONNÉES (Assurez-vous qu'ils correspondent à atelier2.dart)
// =========================================================================

class Product {
  final String name;
  final double price;
  final String image; 
  final bool isNew;
  final double rating;
  final String description;
  // ✅ AJOUT : Le champ specs
  final Map<String, String> specs; 

  const Product(
    this.name, 
    this.price, 
    this.image, 
    {
      this.isNew = false, 
      this.rating = 0.0,
      this.description = 'Ceci est une description détaillée du produit. Il offre les meilleures caractéristiques et technologies du moment. Veuillez noter que cette description est générique.',
      // ✅ INITIALISATION : specs est optionnel par défaut, ou vide si non spécifié.
      this.specs = const {}, 
    }
  );
}

// Modèle d'Article dans le panier
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  double get subtotal => product.price * quantity;
}


// =========================================================================
// 2. WIDGET DE LA PAGE DU PANIER (CartPage - StatefulWidget)
// =========================================================================

class CartPage extends StatefulWidget {
  // Les callbacks sont les clés pour l'interaction avec le parent
  final List<CartItem> cartItems;
  final double cartTotal;
  final Function(CartItem item, int newQuantity) onQuantityChanged;
  final Function(CartItem item) onRemoveItem;
  
  // Constantes pour simuler les frais/réductions
  final double deliveryCost = 5.00; 
  final double discount = 10.00; 

  const CartPage({
    super.key,
    required this.cartItems,
    required this.cartTotal,
    required this.onQuantityChanged,
    required this.onRemoveItem,
  });

  // Calcule le total final après frais et réductions
  double get finalTotal => cartTotal + deliveryCost - discount;
  
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _cardNumberController.dispose();
    super.dispose();
  }

  // Widget helper pour les lignes de récapitulatif (omission pour la clarté)
  Widget _buildSummaryRow(String label, double amount, ColorScheme colorScheme, TextTheme textTheme, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: isTotal
                ? textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)
                : textTheme.titleMedium!.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          Text(
            '${amount.toStringAsFixed(2)}€',
            style: isTotal
                ? textTheme.headlineSmall!.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold)
                : textTheme.titleMedium!.copyWith(
                    fontWeight: amount < 0 ? FontWeight.bold : FontWeight.normal,
                    color: amount < 0 ? colorScheme.error : colorScheme.onSurface,
                  ),
          ),
        ],
      ),
    );
  }

  // Méthode pour construire les champs de saisie (omission pour la clarté)
  Widget _buildPaymentDetailsFields(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 16),
        Text('Détails de Paiement', style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        // Champ Email
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'entrez votre email',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            isDense: true,
          ),
        ),
        const SizedBox(height: 12),
        // Champ Numéro de Carte
        TextFormField(
          controller: _cardNumberController,
          keyboardType: TextInputType.number,
          maxLength: 16,
          decoration: InputDecoration(
            labelText: 'Numéro de Carte Bancaire',
            hintText: 'XXXX XXXX XXXX XXXX',
            prefixIcon: const Icon(Icons.credit_card_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            counterText: "", // Cache le compteur de longueur
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            isDense: true,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final List<CartItem> items = widget.cartItems;
    final double total = widget.cartTotal;

    return Scaffold(
      appBar: AppBar(
        title: Text('Votre Panier (${items.length})'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      
      // UTILISATION CORRECTE DE ListView.builder
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: colorScheme.outline),
                  const SizedBox(height: 20),
                  Text("Votre panier est vide.", style: textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Text("Ajoutez des produits pour continuer.", style: textTheme.bodyLarge),
                ],
              ),
            )
          : ListView.builder( 
              // Ajoute de l'espace en bas pour que la liste ne soit pas cachée par le bottomNavigationBar
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 200), 
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  // Ajout d'une clé unique pour aider Flutter à gérer les mises à jour
                  key: ValueKey(item.product.name),
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(item.product.image, width: 60, height: 60, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 12),
                          
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.name, style: textTheme.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                                Text(
                                  '${item.product.price.toStringAsFixed(2)}€ / Unité', 
                                  style: textTheme.bodyMedium!.copyWith(color: colorScheme.onSurfaceVariant)
                                ),
                              ],
                            ),
                          ),
                          
                          // Contrôle de la Quantité
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                // 🔴 APPEL CORRECT : Décrémente la quantité
                                onPressed: () => widget.onQuantityChanged(item, item.quantity - 1),
                              ),
                              // Ce widget Text se reconstruit correctement
                              Text('${item.quantity}', style: textTheme.titleMedium),
                              IconButton(
                                icon: const Icon(Icons.add),
                                // 🟢 APPEL CORRECT : Incrémente la quantité
                                onPressed: () => widget.onQuantityChanged(item, item.quantity + 1),
                              ),
                            ],
                          ),
                          
                          // Bouton Supprimer
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: colorScheme.error),
                            // 🗑️ APPEL CORRECT : Supprime l'article
                            onPressed: () => widget.onRemoveItem(item),
                            tooltip: 'Retirer l\'article',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      
      // Barre de navigation inférieure contenant le récapitulatif ET les champs de saisie
      bottomNavigationBar: items.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
              ),
              child: SafeArea(
                child: SingleChildScrollView( 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 1. Récapitulatif des coûts
                      _buildSummaryRow('Sous-total', total, colorScheme, textTheme),
                      _buildSummaryRow('Livraison', widget.deliveryCost, colorScheme, textTheme),
                      _buildSummaryRow('Code Promo', -widget.discount, colorScheme, textTheme),
                      
                      const Divider(height: 20),

                      // 2. Total Final
                      _buildSummaryRow('Total', widget.finalTotal, colorScheme, textTheme, isTotal: true),
                      
                      // 3. Champs de saisie
                      _buildPaymentDetailsFields(colorScheme, textTheme), 
                      
                      // 4. Bouton Commander
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            // Validation simple des champs
                            if (_emailController.text.isEmpty || _cardNumberController.text.length != 16) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Veuillez remplir l\'email et le numéro de carte (16 chiffres).')),
                              );
                              return;
                            }
                            
                            // Traitement de la commande
                            Navigator.of(context).pop(); 
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Commande passée pour ${_emailController.text} !'),
                              ),
                            );
                          },
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
              ),
            ),
    );
  }
}