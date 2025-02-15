import 'package:collection/collection.dart';

//utils
import '../utils/list_comparison.dart';


class Transformation {
  final String name;
  final String description;
  final int argsCount;
  final int Function(int, List<int>) function;

  Transformation({
    required this.name, 
    required this.function,
    this.description = '',
    this.argsCount = 0,
  });

  @override
  int get hashCode => Object.hash(name, description, argsCount, function);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Transformation) return false;    

    return  name == other.name && 
            function == other.function &&
            argsCount == other.argsCount;
  }

  Transformation copyWith({String? name, int Function(int, List<int>)? function, int? argsCount}) {
    return Transformation(
      name: name ?? this.name,
      argsCount: argsCount ?? this.argsCount,
      function: function ?? this.function,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'argsCount': argsCount,
      'function' : function
    };
  }

  int run(int x, List<int> args) {
    assert(args.length == argsCount);
    return function(x, args);
  }
}

class TransformationDef
{
  final Transformation transformation;
  List<int> args; 

  TransformationDef({required this.transformation, required this.args});

  TransformationDef copyWith({Transformation? transformation, List<int>? args}) {
    return TransformationDef(
      transformation: transformation ?? this.transformation.copyWith(),
      args: args ?? this.args.toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TransformationDef) return false;

    return transformation == other.transformation &&
        areListsEqual(args, other.args);
  }

  @override
  int get hashCode => Object.hash(
        transformation,
        const ListEquality().hash(args),
      );

}