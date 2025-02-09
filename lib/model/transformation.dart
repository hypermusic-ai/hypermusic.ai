import 'package:collection/collection.dart';

class Transformation {
  final String name;
  List<int> args;

  Transformation({required this.name, this.args = const []});

  @override
  int get hashCode => Object.hash(
        name,
        const ListEquality().hash(args),
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Transformation) return false;
    bool eq = ListEquality().equals(args, other.args);
    
    return name == other.name && ListEquality().equals(args, other.args);
  }

  Transformation copyWith({String? name, List<int>? args}) {
    return Transformation(
      name: name ?? this.name,
      args: args ?? this.args,
    );
  }

  int run(int x) {
    return switch (name) {
      'Add' => x + (args.isNotEmpty ? args[0] : 0),
      'Mul' => x * (args.isNotEmpty ? args[0] : 1),
      'Nop' => x,
      _ => throw Exception('Unknown transformation: $name')
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'argsCount': args.length,
      'description': _getDescription(),
    };
  }

  String _getDescription() {
    return switch (name) {
      'Add' => 'Adds a constant to the input index',
      'Mul' => 'Multiplies the input index by a constant',
      'Nop' => 'No operation',
      _ => 'Unknown transformation'
    };
  }
}
