import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../bloc/menu_bloc/menu_bloc.dart';
import '../bloc/menu_bloc/menu_state.dart';
import '../bloc/cart_bloc/cart_bloc.dart';
import '../bloc/cart_bloc/cart_state.dart';
import '../bloc/cart_bloc/cart_event.dart';
import '../bloc/order_history_bloc/order_history_bloc.dart';
import '../bloc/order_history_bloc/order_history_state.dart';

class MenuScreen extends StatefulWidget {
  final int tableNumber;

  const MenuScreen({super.key, required this.tableNumber});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // We need a GlobalKey to find exactly where the Cart Icon is on the screen
  final GlobalKey _cartKey = GlobalKey();

  // Selected categories state for the pill buttons
  Set<String> _selectedCategories = {};

  // Search query state
  String _searchQuery = '';

  // --- THE FLYING ANIMATION LOGIC ---
  void _animateToCart(
    BuildContext context,
    Offset startPosition,
    String imageUrl,
  ) {
    // 1. Find the exact screen coordinates of the Cart Icon
    final cartRenderBox =
        _cartKey.currentContext?.findRenderObject() as RenderBox?;
    if (cartRenderBox == null) return;
    final cartPosition = cartRenderBox.localToGlobal(Offset.zero);

    // 2. Create an OverlayEntry (a widget that floats above EVERYTHING)
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        // TweenAnimationBuilder smoothly animates a value from 0.0 to 1.0 over 600ms
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutBack, // Gives it that snappy "pop" feel
          onEnd: () {
            overlayEntry
                .remove(); // Destroy the flying image when animation finishes
          },
          builder: (context, double value, child) {
            // Calculate the X position moving directly to the cart
            final currentX =
                startPosition.dx + (cartPosition.dx - startPosition.dx) * value;

            // Calculate the Y position, but subtract a Sine wave to make it fly in an ARC!
            final currentY =
                startPosition.dy +
                (cartPosition.dy - startPosition.dy) * value -
                (math.sin(value * math.pi) * 80);

            // Shrink the image as it flies away
            final currentSize = 80.0 * (1 - (value * 0.6));

            return Positioned(
              left: currentX,
              top: currentY,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: currentSize,
                  height: currentSize,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SizedBox(),
                ),
              ),
            );
          },
        );
      },
    );

    // 3. Inject the floating image onto the screen
    Overlay.of(context).insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // Reverted to solid theme color
      // 1. TOP APP BAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.menu, color: Theme.of(context).colorScheme.primary),
        title: Text(
          'The Culinary Editorial',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
            builder: (context, state) {
              if (state.orders.isNotEmpty) {
                return IconButton(
                  icon: Icon(
                    Icons.history,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    context.push('/status');
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int totalItems = state.items.fold(
                0,
                (sum, item) => sum + item.quantity,
              );

              return Badge(
                isLabelVisible: totalItems > 0,
                label: Text(
                  '$totalItems',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.red,
                child: IconButton(
                  key: _cartKey,
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    context.push('/cart');
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      // 3. THE MAIN CONTENT
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading || state is MenuInitial) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          } else if (state is MenuError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is MenuLoaded) {
            // 1. Extract all unique categories
            final allCategories = state.items
                .expand((item) => item.category.split('/'))
                .map((c) => c.trim())
                .toSet()
                .toList()
              ..sort();

            // 2. Filter items based on selected categories (AND logic) AND search query
            final items = state.items.where((item) {
              // Category filter
              bool matchesCategory = true;
              if (_selectedCategories.isNotEmpty) {
                final itemCats = item.category.split('/').map((c) => c.trim().toLowerCase()).toSet();
                matchesCategory = _selectedCategories.every((selected) => itemCats.contains(selected.toLowerCase()));
              }

              // Search filter
              bool matchesSearch = true;
              if (_searchQuery.isNotEmpty) {
                matchesSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                                item.description.toLowerCase().contains(_searchQuery.toLowerCase());
              }

              return matchesCategory && matchesSearch;
            }).toList();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomScrollView(
                slivers: [
                  // The Header, Search, and Category Pills
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WELCOME CUSTOMER',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Curating your next\nmasterpiece meal.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Search Bar
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest, // Using unclicked sort color
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.grey[500],
                                  size: 20,
                                ),
                                hintText: 'Search the editorial menu...',
                                hintStyle: GoogleFonts.beVietnamPro(
                                  color: Colors.grey[500],
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Category Pills
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: allCategories.map((category) {
                                final isSelected = _selectedCategories.contains(category);
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: _buildCategoryPill(category, isSelected, context),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // The Grid of Food
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65, // Taller cards
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = items[index];
                      // We need a unique key for each image so the animation knows where to start!
                      final GlobalKey imageKey = GlobalKey();

                      return GestureDetector(
                        onTap: () {
                          context.push('/details', extra: item);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image
                              Container(
                                key: imageKey, // Attached the key!
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    imageUrl: item.imageUrl,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                item.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Order Button
                              SizedBox(
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // 1. Get the starting coordinates of the image
                                    final RenderBox renderBox =
                                        imageKey.currentContext!
                                                .findRenderObject()
                                            as RenderBox;
                                    final startPosition = renderBox
                                        .localToGlobal(Offset.zero);

                                    // 2. Trigger the flying animation!
                                    _animateToCart(
                                      context,
                                      startPosition,
                                      item.imageUrl,
                                    );

                                    // 3. Add to BLoC
                                    context.read<CartBloc>().add(
                                      AddToCart(menuItem: item, quantity: 1),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.surface, // Dark text on amber
                                    splashFactory: NoSplash
                                        .splashFactory, // This removes the blue flash!
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    'ORDER',
                                    style: GoogleFonts.beVietnamPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: items.length),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ), // Space for the bottom cart
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  // Helper function to draw the category pills
  Widget _buildCategoryPill(
    String text,
    bool isSelected,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedCategories.remove(text);
          } else {
            _selectedCategories.add(text);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest, // Using unclicked sort color
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: GoogleFonts.beVietnamPro(
            color: isSelected
                ? Theme.of(context).colorScheme.surface
                : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
