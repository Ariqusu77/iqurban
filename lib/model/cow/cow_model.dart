class CowModel {
  final String name;
  final int age; // Age in years
  final double weight; // Weight in kilograms
  final int price;
  final String faceImageUrl; // URL to the cow's face image
  final String bodyImageUrl; // URL to the cow's body image
  final String feetImageUrl; // URL to the cow's feet image

  CowModel({
    required this.name,
    required this.age,
    required this.weight,
    required this.price,
    required this.faceImageUrl,
    required this.bodyImageUrl,
    required this.feetImageUrl,
  });

  // Factory constructor for creating an instance from a map (e.g., Firestore document)
  factory CowModel.fromMap(Map<String, dynamic> map) {
    return CowModel(
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      price: map['price'] ?? 0,
      weight: (map['weight'] ?? 0).toDouble(),
      faceImageUrl: map['faceImageUrl'] ?? '',
      bodyImageUrl: map['bodyImageUrl'] ?? '',
      feetImageUrl: map['feetImageUrl'] ?? '',
    );
  }

  // Convert the instance to a map (e.g., for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'price': price,
      'weight': weight,
      'faceImageUrl': faceImageUrl,
      'bodyImageUrl': bodyImageUrl,
      'feetImageUrl': feetImageUrl,
    };
  }
}
