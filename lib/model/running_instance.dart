class RunningInstance {
  final int? startPoint;
  final int? howManyValues;
  final int? transformationStartIndex;
  final int? transformationSkipCount;

  const RunningInstance({
    this.startPoint = 0,
    this.howManyValues,
    this.transformationStartIndex,
    this.transformationSkipCount,
  });

  Map<String, dynamic> toJson(RunningInstance instance) {
    return {
      'startPoint': instance.startPoint,
      'howManyValues': instance.howManyValues,
      'transformationStartIndex': instance.transformationStartIndex,
      'transformationSkipCount': instance.transformationSkipCount,
    };
  }

  RunningInstance copyWith({int? startPoint, int? howManyValues, int? transformationStartIndex, int? transformationSkipCount}) {
    return RunningInstance(
      startPoint: startPoint ?? this.startPoint,
      howManyValues: howManyValues ?? this.howManyValues,
      transformationStartIndex: transformationStartIndex ?? this.transformationStartIndex,
      transformationSkipCount: transformationSkipCount ?? this.transformationSkipCount,
    );
  }
}
