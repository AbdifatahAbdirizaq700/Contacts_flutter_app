class Contact {
  final int id;
  final String name;
  final String phone;
  final String email; 

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
    };
  }
}
