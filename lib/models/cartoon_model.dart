class CartoonModel {
  final String name;
  final String cover;
  final String pdf;
//<editor-fold desc="Data Methods" defaultstate="collapsed">
  CartoonModel({
    this.name,
    this.cover,
    this.pdf,
  });

  CartoonModel copyWith({
    String name,
    String cover,
    String pdf,
  }) {
    if ((name == null || identical(name, this.name)) &&
        (cover == null || identical(cover, this.cover)) &&
        (pdf == null || identical(pdf, this.pdf))) {
      return this;
    }

    return new CartoonModel(
      name: name ?? this.name,
      cover: cover ?? this.cover,
      pdf: pdf ?? this.pdf,
    );
  }

  @override
  String toString() {
    return 'CartoonModel{name: $name, cover: $cover, pdf: $pdf}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartoonModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          cover == other.cover &&
          pdf == other.pdf);

  @override
  int get hashCode => name.hashCode ^ cover.hashCode ^ pdf.hashCode;

  factory CartoonModel.fromMap(Map<String, dynamic> map) {
    return new CartoonModel(
      name: map['name'] as String,
      cover: map['cover'] as String,
      pdf: map['pdf'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'name': this.name,
      'cover': this.cover,
      'pdf': this.pdf,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
