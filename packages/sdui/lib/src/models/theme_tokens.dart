import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_tokens.g.dart';

@JsonSerializable()
class ThemeTokens extends Equatable {
  @JsonKey(name: 'color.primary')
  final String? colorPrimary;

  @JsonKey(name: 'color.bg')
  final String? colorBg;

  @JsonKey(name: 'color.text')
  final String? colorText;

  @JsonKey(name: 'radius.md')
  final double? radiusMd;

  @JsonKey(name: 'space.sm')
  final double? spaceSm;

  @JsonKey(name: 'space.md')
  final double? spaceMd;

  @JsonKey(name: 'font.family')
  final String? fontFamily;

  const ThemeTokens({
    this.colorPrimary,
    this.colorBg,
    this.colorText,
    this.radiusMd,
    this.spaceSm,
    this.spaceMd,
    this.fontFamily,
  });

  factory ThemeTokens.fromJson(Map<String, dynamic> json) =>
      _$ThemeTokensFromJson(json);

  Map<String, dynamic> toJson() => _$ThemeTokensToJson(this);

  // Helper methods to get colors with fallbacks
  Color getPrimaryColor() => _parseColor(colorPrimary) ?? Colors.blue;

  Color getBgColor() => _parseColor(colorBg) ?? Colors.white;

  Color getTextColor() => _parseColor(colorText) ?? Colors.black87;

  double getRadiusMd() => radiusMd ?? 8.0;

  double getSpaceSm() => spaceSm ?? 8.0;

  double getSpaceMd() => spaceMd ?? 16.0;

  String getFontFamily() => fontFamily ?? 'Roboto';

  static Color? _parseColor(String? colorString) {
    if (colorString == null) return null;

    try {
      // Remove # if present
      String hexColor = colorString.replaceAll('#', '');

      // Add alpha if not present
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }

      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
    colorPrimary,
    colorBg,
    colorText,
    radiusMd,
    spaceSm,
    spaceMd,
    fontFamily,
  ];
}
