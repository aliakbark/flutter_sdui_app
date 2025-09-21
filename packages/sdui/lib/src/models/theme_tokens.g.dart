// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_tokens.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeTokens _$ThemeTokensFromJson(Map<String, dynamic> json) => ThemeTokens(
  colorPrimary: json['color.primary'] as String?,
  colorBg: json['color.bg'] as String?,
  colorText: json['color.text'] as String?,
  radiusMd: (json['radius.md'] as num?)?.toDouble(),
  spaceSm: (json['space.sm'] as num?)?.toDouble(),
  spaceMd: (json['space.md'] as num?)?.toDouble(),
  fontFamily: json['font.family'] as String?,
);

Map<String, dynamic> _$ThemeTokensToJson(ThemeTokens instance) =>
    <String, dynamic>{
      'color.primary': instance.colorPrimary,
      'color.bg': instance.colorBg,
      'color.text': instance.colorText,
      'radius.md': instance.radiusMd,
      'space.sm': instance.spaceSm,
      'space.md': instance.spaceMd,
      'font.family': instance.fontFamily,
    };
