class Condition 
{
  final String name;
  final String description;

  bool Function(List<dynamic>) checkFunction;

  Condition({
    required this.name,
    required this.description,
    required this.checkFunction
  });

    Condition copyWith({String? name, String? description, bool Function(List<dynamic>)? checkFunction}) {
    return Condition(
      name: name ?? this.name,
      description: description ?? this.description,
      checkFunction: checkFunction ?? this.checkFunction
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }

  bool check(List<dynamic> args)
  {
    return checkFunction(args);
  }
}
