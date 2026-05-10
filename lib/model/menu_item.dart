import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String status;
  final String category;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.status,
    required this.category,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    imageUrl,
    status,
    category,
  ];
}
