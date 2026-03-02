// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class property {
  String name;
  String value;

  property(
    this.name,
    this.value,
  );

  property copyWith({
    String? name,
    String? value,
  }) {
    return property(
      name ?? this.name,
      value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'value': value,
    };
  }

  factory property.fromMap(Map<String, dynamic> map) {
    return property(
      map['name'] as String,
      map['value'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory property.fromJson(String source) => property.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'property(name: $name, value: $value)';

  @override
  bool operator ==(covariant property other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.value == value;
  }

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}
