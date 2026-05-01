// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Product {
  String get barcode => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  NutritionData? get nutritionData => throw _privateConstructorUsedError;
  List<String>? get ingredientsTags => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call({
    String barcode,
    String? name,
    String? imageUrl,
    String? brand,
    NutritionData? nutritionData,
    List<String>? ingredientsTags,
  });

  $NutritionDataCopyWith<$Res>? get nutritionData;
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? barcode = null,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? brand = freezed,
    Object? nutritionData = freezed,
    Object? ingredientsTags = freezed,
  }) {
    return _then(
      _value.copyWith(
            barcode: null == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            brand: freezed == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as String?,
            nutritionData: freezed == nutritionData
                ? _value.nutritionData
                : nutritionData // ignore: cast_nullable_to_non_nullable
                      as NutritionData?,
            ingredientsTags: freezed == ingredientsTags
                ? _value.ingredientsTags
                : ingredientsTags // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionDataCopyWith<$Res>? get nutritionData {
    if (_value.nutritionData == null) {
      return null;
    }

    return $NutritionDataCopyWith<$Res>(_value.nutritionData!, (value) {
      return _then(_value.copyWith(nutritionData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
    _$ProductImpl value,
    $Res Function(_$ProductImpl) then,
  ) = __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String barcode,
    String? name,
    String? imageUrl,
    String? brand,
    NutritionData? nutritionData,
    List<String>? ingredientsTags,
  });

  @override
  $NutritionDataCopyWith<$Res>? get nutritionData;
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
    _$ProductImpl _value,
    $Res Function(_$ProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? barcode = null,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? brand = freezed,
    Object? nutritionData = freezed,
    Object? ingredientsTags = freezed,
  }) {
    return _then(
      _$ProductImpl(
        barcode: null == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        brand: freezed == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as String?,
        nutritionData: freezed == nutritionData
            ? _value.nutritionData
            : nutritionData // ignore: cast_nullable_to_non_nullable
                  as NutritionData?,
        ingredientsTags: freezed == ingredientsTags
            ? _value._ingredientsTags
            : ingredientsTags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc

class _$ProductImpl implements _Product {
  const _$ProductImpl({
    required this.barcode,
    this.name,
    this.imageUrl,
    this.brand,
    this.nutritionData,
    final List<String>? ingredientsTags,
  }) : _ingredientsTags = ingredientsTags;

  @override
  final String barcode;
  @override
  final String? name;
  @override
  final String? imageUrl;
  @override
  final String? brand;
  @override
  final NutritionData? nutritionData;
  final List<String>? _ingredientsTags;
  @override
  List<String>? get ingredientsTags {
    final value = _ingredientsTags;
    if (value == null) return null;
    if (_ingredientsTags is EqualUnmodifiableListView) return _ingredientsTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Product(barcode: $barcode, name: $name, imageUrl: $imageUrl, brand: $brand, nutritionData: $nutritionData, ingredientsTags: $ingredientsTags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.nutritionData, nutritionData) ||
                other.nutritionData == nutritionData) &&
            const DeepCollectionEquality().equals(
              other._ingredientsTags,
              _ingredientsTags,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    barcode,
    name,
    imageUrl,
    brand,
    nutritionData,
    const DeepCollectionEquality().hash(_ingredientsTags),
  );

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);
}

abstract class _Product implements Product {
  const factory _Product({
    required final String barcode,
    final String? name,
    final String? imageUrl,
    final String? brand,
    final NutritionData? nutritionData,
    final List<String>? ingredientsTags,
  }) = _$ProductImpl;

  @override
  String get barcode;
  @override
  String? get name;
  @override
  String? get imageUrl;
  @override
  String? get brand;
  @override
  NutritionData? get nutritionData;
  @override
  List<String>? get ingredientsTags;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
