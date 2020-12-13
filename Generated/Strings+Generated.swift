// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// この位置にMy駐輪場を追加しますか？
  internal static let addMyBicycleParkingToThisPosition = L10n.tr("Localize", "Add My Bicycle Parking to this position?")
  /// 自動二輪駐輪場
  internal static let bikePark = L10n.tr("Localize", "BikePark")
  /// バイク屋
  internal static let bikeShop = L10n.tr("Localize", "BikeShop")
  /// バイク駐輪場・バイクショップの取得に失敗しました。
  internal static let canTGetBikeSpot = L10n.tr("Localize", "Can't get bike Spot")
  /// キャンセル
  internal static let cancel = L10n.tr("Localize", "Cancel")
  /// 準備中
  internal static let closing = L10n.tr("Localize", "Closing")
  /// 地図
  internal static let mapTab = L10n.tr("Localize", "MapTab")
  /// My駐輪場
  internal static let myBikeParkTab = L10n.tr("Localize", "MyBikeParkTab")
  /// バイク駐輪場・バイクショップが一つも見つかりませんでした。
  internal static let notFoundBikeSpot = L10n.tr("Localize", "Not Found bike Spot")
  /// OK
  internal static let ok = L10n.tr("Localize", "OK")
  /// 営業中
  internal static let opening = L10n.tr("Localize", "Opening")
  /// 駐輪場名を入力してください。
  internal static let pleaseInputParkName = L10n.tr("Localize", "Please input park name")
  /// データなし
  internal static let unknown = L10n.tr("Localize", "Unknown")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
