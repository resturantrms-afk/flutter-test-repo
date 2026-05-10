import 'package:restaurnt_rms/model/menu_item.dart';

abstract class MenuRepository {
  Future<List<MenuItem>> getMenuItems();
}

class MockMenuRepository implements MenuRepository {
  Future<List<MenuItem>> getMenuItems() async {
    await Future.delayed(Duration(seconds: 2));

    return [
      MenuItem(
        id: 1,
        name: 'Burger',
        description:
            'a Burger with tomato and onion plus meat and quarter pound of cow meat ',
        price: 10,
        imageUrl:
            'https://hips.hearstapps.com/hmg-prod/images/chicken-burgers-lead-667b185b5c64f.jpg?',
        status: 'available',
        category: 'lunch/Fast Food/Burger',
      ),
      MenuItem(
        id: 2,
        name: 'Margherita Pizza',
        description:
            'Classic wood-fired pizza with fresh mozzarella, tomatoes, and basil',
        price: 12,
        imageUrl:
            'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=500',
        status: 'available',
        category: 'dinner/Fast Food/Pizza',
      ),
      MenuItem(
        id: 3,
        name: 'Spaghetti Carbonara',
        description:
            'Traditional Italian pasta with creamy egg sauce, pancetta, and parmesan',
        price: 15,
        imageUrl:
            'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=500',
        status: 'available',
        category: 'dinner/Italian/Pasta',
      ),
      MenuItem(
        id: 4,
        name: 'Caesar Salad',
        description:
            'Crisp romaine lettuce, grilled chicken breast, croutons, and Caesar dressing',
        price: 8,
        imageUrl:
            'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=500',
        status: 'available',
        category: 'lunch/Healthy/Salad',
      ),
      MenuItem(
        id: 5,
        name: 'Spicy Tuna Roll',
        description:
            'Fresh tuna mixed with spicy mayo, wrapped in seaweed and rice',
        price: 14,
        imageUrl:
            'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=500',
        status: 'available',
        category: 'dinner/Japanese/Sushi',
      ),
      MenuItem(
        id: 6,
        name: 'Beef Tacos',
        description:
            'Three soft shell tacos filled with seasoned ground beef, cheese, and fresh salsa',
        price: 9,
        imageUrl:
            'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=500',
        status: 'available',
        category: 'lunch/Mexican/Tacos',
      ),
      MenuItem(
        id: 7,
        name: 'Ribeye Steak',
        description:
            '12oz grilled ribeye cooked to order, served with garlic herb butter',
        price: 25,
        imageUrl:
            'https://images.unsplash.com/photo-1600891964092-4316c288032e?w=500',
        status: 'available',
        category: 'dinner/Steakhouse/Meat',
      ),
      MenuItem(
        id: 9,
        name: 'Pork Ramen',
        description:
            'Rich tonkotsu broth with noodles, sliced pork belly, soft boiled egg, and scallions',
        price: 13,
        imageUrl:
            'https://images.unsplash.com/photo-1557872943-16a5ac26437e?w=500',
        status: 'available',
        category: 'lunch/Japanese/Soup',
      ),

      MenuItem(
        id: 12,
        name: 'Chicken Tikka Masala',
        description:
            'Roasted marinated chicken chunks in a spiced curry sauce, served with garlic naan',
        price: 14,
        imageUrl:
            'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=500',
        status: 'available',
        category: 'dinner/Indian/Curry',
      ),
      MenuItem(
        id: 13,
        name: 'Veggie Wrap',
        description:
            'Grilled zucchini, bell peppers, spinach, and creamy hummus in a spinach tortilla',
        price: 9,
        imageUrl:
            'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=500',
        status: 'available',
        category: 'lunch/Healthy/Wrap',
      ),
      MenuItem(
        id: 16,
        name: 'Chocolate Lava Cake',
        description:
            'Warm chocolate cake with a rich molten center, dusted with powdered sugar',
        price: 7,
        imageUrl:
            'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=500',
        status: 'available',
        category: 'dessert/Sweet/Cake',
      ),
    ];
  }
}
