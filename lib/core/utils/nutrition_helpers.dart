double? calculateNetCarbs(double? carbs, double? fiber) {
  if (carbs == null) return null;
  final f = fiber ?? 0.0;
  return (carbs - f).clamp(0.0, double.infinity);
}
