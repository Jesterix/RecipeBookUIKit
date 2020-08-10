//
//  Measure.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 09.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation

var measureTypes = [UnitMass.self, UnitVolume.self]

enum DimensionType {
    enum Mass: String, CaseIterable {
        case kilograms, grams, decigrams, centigrams, milligrams, micrograms, nanograms, picograms, ounces, pounds, stones, metricTons, shortTons, carats, ouncesTroy, slugs

        var symbol: String {
            switch self {
            case .kilograms:
                return UnitMass.kilograms.symbol
            case .grams:
                return UnitMass.grams.symbol
            case .decigrams:
                return UnitMass.decigrams.symbol
            case .centigrams:
                return UnitMass.centigrams.symbol
            case .milligrams:
                return UnitMass.milligrams.symbol
            case .micrograms:
                return UnitMass.micrograms.symbol
            case .nanograms:
                return UnitMass.nanograms.symbol
            case .picograms:
                return UnitMass.picograms.symbol
            case .ounces:
                return UnitMass.ounces.symbol
            case .pounds:
                return UnitMass.pounds.symbol
            case .stones:
                return UnitMass.stones.symbol
            case .metricTons:
                return UnitMass.metricTons.symbol
            case .shortTons:
                return UnitMass.shortTons.symbol
            case .carats:
                return UnitMass.carats.symbol
            case .ouncesTroy:
                return UnitMass.ouncesTroy.symbol
            case .slugs:
                return UnitMass.slugs.symbol
            }
        }

        init?(symbol: String) {
            switch symbol.lowercased() {
            case DimensionType.Mass.kilograms.rawValue, UnitMass.kilograms.symbol:
                self = .kilograms
            case DimensionType.Mass.grams.rawValue, UnitMass.grams.symbol:
                self = .grams
            case DimensionType.Mass.decigrams.rawValue, UnitMass.decigrams.symbol:
                self = .decigrams
            case DimensionType.Mass.centigrams.rawValue, UnitMass.centigrams.symbol:
                self = .centigrams
            case DimensionType.Mass.milligrams.rawValue, UnitMass.milligrams.symbol:
                self = .milligrams
            case DimensionType.Mass.micrograms.rawValue, UnitMass.micrograms.symbol:
                self = .micrograms
            case DimensionType.Mass.nanograms.rawValue, UnitMass.nanograms.symbol:
                self = .nanograms
            case DimensionType.Mass.picograms.rawValue, UnitMass.picograms.symbol:
                self = .picograms
            case DimensionType.Mass.ounces.rawValue, UnitMass.ounces.symbol:
                self = .ounces
            case DimensionType.Mass.pounds.rawValue, UnitMass.pounds.symbol:
                self = .pounds
            case DimensionType.Mass.stones.rawValue, UnitMass.stones.symbol:
                self = .stones
            case DimensionType.Mass.metricTons.rawValue, UnitMass.metricTons.symbol:
                self = .metricTons
            case DimensionType.Mass.shortTons.rawValue, UnitMass.shortTons.symbol:
                self = .shortTons
            case DimensionType.Mass.carats.rawValue, UnitMass.carats.symbol:
                self = .carats
            case DimensionType.Mass.ouncesTroy.rawValue, UnitMass.ouncesTroy.symbol:
                self = .ouncesTroy
            case DimensionType.Mass.slugs.rawValue, UnitMass.slugs.symbol:
                self = .slugs
            default:
                return nil
            }
        }
    }
    enum Volume: String, CaseIterable {
        case megaliters, kiloliters, liters, deciliters, centiliters, milliliters, cubicKilometers, cubicMeters, cubicDecimeters, cubicCentimeters, cubicMillimeters, cubicInches, cubicFeet, cubicYards, cubicMiles, acreFeet, bushels, teaspoons, tablespoons, fluidOunces, cups, pints, quarts, gallons, imperialTeaspoons, imperialTablespoons, imperialFluidOunces, imperialPints, imperialQuarts, imperialGallons, metricCups

        var symbol: String {
            switch self {
            case .megaliters:
                return UnitVolume.megaliters.symbol
            case .kiloliters:
                return UnitVolume.kiloliters.symbol
            case .liters:
                return UnitVolume.liters.symbol
            case .deciliters:
                return UnitVolume.deciliters.symbol
            case .centiliters:
                return UnitVolume.centiliters.symbol
            case .milliliters:
                return UnitVolume.milliliters.symbol
            case .cubicKilometers:
                return UnitVolume.cubicKilometers.symbol
            case .cubicMeters:
                return UnitVolume.cubicMeters.symbol
            case .cubicDecimeters:
                return UnitVolume.cubicDecimeters.symbol
            case .cubicCentimeters:
                return UnitVolume.cubicCentimeters.symbol
            case .cubicMillimeters:
                return UnitVolume.cubicMillimeters.symbol
            case .cubicInches:
                return UnitVolume.cubicInches.symbol
            case .cubicFeet:
                return UnitVolume.cubicFeet.symbol
            case .cubicYards:
                return UnitVolume.cubicYards.symbol
            case .cubicMiles:
                return UnitVolume.cubicMiles.symbol
            case .acreFeet:
                return UnitVolume.acreFeet.symbol
            case .bushels:
                return UnitVolume.bushels.symbol
            case .teaspoons:
                return UnitVolume.teaspoons.symbol
            case .tablespoons:
                return UnitVolume.tablespoons.symbol
            case .fluidOunces:
                return UnitVolume.fluidOunces.symbol
            case .cups:
                return UnitVolume.cups.symbol
            case .pints:
                return UnitVolume.pints.symbol
            case .quarts:
                return UnitVolume.quarts.symbol
            case .gallons:
                return UnitVolume.gallons.symbol
            case .imperialTeaspoons:
                return UnitVolume.imperialTeaspoons.symbol
            case .imperialTablespoons:
                return UnitVolume.imperialTablespoons.symbol
            case .imperialFluidOunces:
                return UnitVolume.imperialFluidOunces.symbol
            case .imperialPints:
                return UnitVolume.imperialPints.symbol
            case .imperialQuarts:
                return UnitVolume.imperialQuarts.symbol
            case .imperialGallons:
                return UnitVolume.imperialGallons.symbol
            case .metricCups:
                return UnitVolume.metricCups.symbol
            }
        }

        init?(symbol: String) {
            switch symbol.lowercased() {
            case DimensionType.Volume.megaliters.rawValue, UnitVolume.megaliters.symbol:
                self = .megaliters
            case DimensionType.Volume.kiloliters.rawValue, UnitVolume.kiloliters.symbol:
                self = .kiloliters
            case DimensionType.Volume.liters.rawValue, UnitVolume.liters.symbol:
                self = .liters
            case DimensionType.Volume.deciliters.rawValue, UnitVolume.deciliters.symbol:
                self = .deciliters
            case DimensionType.Volume.centiliters.rawValue, UnitVolume.centiliters.symbol:
                self = .centiliters
            case DimensionType.Volume.milliliters.rawValue, UnitVolume.milliliters.symbol:
                self = .milliliters
            case DimensionType.Volume.cubicKilometers.rawValue, UnitVolume.cubicKilometers.symbol:
                self = .cubicKilometers
            case DimensionType.Volume.cubicMeters.rawValue, UnitVolume.cubicMeters.symbol:
                self = .cubicMeters
            case DimensionType.Volume.cubicDecimeters.rawValue, UnitVolume.cubicDecimeters.symbol:
                self = .cubicDecimeters
            case DimensionType.Volume.cubicCentimeters.rawValue, UnitVolume.cubicCentimeters.symbol:
                self = .cubicCentimeters
            case DimensionType.Volume.cubicMillimeters.rawValue, UnitVolume.cubicMillimeters.symbol:
                self = .cubicMillimeters
            case DimensionType.Volume.cubicInches.rawValue, UnitVolume.cubicInches.symbol:
                self = .cubicInches
            case DimensionType.Volume.cubicFeet.rawValue, UnitVolume.cubicFeet.symbol:
                self = .cubicFeet
            case DimensionType.Volume.cubicYards.rawValue, UnitVolume.cubicYards.symbol:
                self = .cubicYards
            case DimensionType.Volume.cubicMiles.rawValue, UnitVolume.cubicMiles.symbol:
                self = .cubicMiles
            case DimensionType.Volume.acreFeet.rawValue, UnitVolume.acreFeet.symbol:
                self = .acreFeet
            case DimensionType.Volume.bushels.rawValue, UnitVolume.bushels.symbol:
                self = .bushels
            case DimensionType.Volume.teaspoons.rawValue, UnitVolume.teaspoons.symbol:
                self = .teaspoons
            case DimensionType.Volume.tablespoons.rawValue, UnitVolume.tablespoons.symbol:
                self = .tablespoons
            case DimensionType.Volume.fluidOunces.rawValue, UnitVolume.fluidOunces.symbol:
                self = .fluidOunces
            case DimensionType.Volume.cups.rawValue, UnitVolume.cups.symbol:
                self = .cups
            case DimensionType.Volume.pints.rawValue, UnitVolume.pints.symbol:
                self = .pints
            case DimensionType.Volume.quarts.rawValue, UnitVolume.quarts.symbol:
                self = .quarts
            case DimensionType.Volume.gallons.rawValue, UnitVolume.gallons.symbol:
                self = .gallons
            case DimensionType.Volume.imperialTeaspoons.rawValue, UnitVolume.imperialTeaspoons.symbol:
                self = .imperialTeaspoons
            case DimensionType.Volume.imperialTablespoons.rawValue, UnitVolume.imperialTablespoons.symbol:
                self = .imperialTablespoons
            case DimensionType.Volume.imperialFluidOunces.rawValue, UnitVolume.imperialFluidOunces.symbol:
                self = .imperialFluidOunces
            case DimensionType.Volume.imperialPints.rawValue, UnitVolume.imperialPints.symbol:
                self = .imperialPints
            case DimensionType.Volume.imperialQuarts.rawValue, UnitVolume.imperialQuarts.symbol:
                self = .imperialQuarts
            case DimensionType.Volume.imperialGallons.rawValue, UnitVolume.imperialGallons.symbol:
                self = .imperialGallons
            case DimensionType.Volume.metricCups.rawValue, UnitVolume.metricCups.symbol:
                self = .metricCups
            default:
                return nil
            }
        }
    }

    case mass(Mass)
    case volume(Volume)
    case undefined

    var type: Dimension.Type {
        switch self {
        case .mass:
            return UnitMass.self
        case .volume:
            return UnitVolume.self
        default:
            return Dimension.self
        }
    }

//    var symbol: String {
//        switch self {
//        case .mass(let unit):
//            return unit.symbol
//        case .volume(let unit):
//            return unit.symbol
//        case .undefined:
//            return ""
//        }
//    }

    static var allMassCases: [String] {
        var result: [String] = []
        for type in DimensionType.Mass.allCases {
            result.append(type.rawValue)
            result.append(type.symbol)
        }
        return result
    }

    static var allVolumeCases: [String] {
        var result: [String] = []
        for type in DimensionType.Volume.allCases {
            result.append(type.rawValue)
            result.append(type.symbol)
        }
        return result
    }
}

struct Measure {
    var value: Double
    var type: DimensionType
    var coefficient: Double = 1
    var baseUnit: Unit {
        switch type {
        case .mass:
            return UnitMass.kilograms
        case .volume:
            return UnitVolume.liters
        case .undefined:
            return Unit(symbol: symbol)
        }
    }
    
    private var _symbol: String = ""
    var symbol: String {
        get {
            switch type {
            case .mass(let unit):
                return unit.symbol
            case .volume(let unit):
                return unit.symbol
            case .undefined:
                return _symbol
            }
        }
        set {
            _symbol = newValue
        }
    }

    init(value: Double, symbol: String) {
        self.value = value
        if DimensionType.allMassCases.contains(symbol) {
            self.type = .mass(DimensionType.Mass.init(symbol: symbol)!)
        } else if DimensionType.allVolumeCases.contains(symbol) {
            self.type = .volume(DimensionType.Volume.init(symbol: symbol)!)
        } else {
            self.type = .undefined
            self._symbol = symbol
        }
    }
}



//import struct Foundation.Date
//import struct Foundation.TimeInterval
//import class Foundation.DateFormatter
//import struct Foundation.Calendar
//
//// Foundation.Date expects Swift.Int in Codable protocols
//// but we need Swift.String
//
//public struct Date: CustomStringConvertible {
//    let value: Foundation.Date
//
//    public init() {
//        value = Foundation.Date()
//    }
//
//    public init(_ date: Foundation.Date) {
//        value = date
//    }
//}
//
//extension Date {
//    static var distantFuture: Date {
//        return .init(Foundation.Date.distantFuture)
//    }
//
//    static var distantPast: Date {
//        return .init(Foundation.Date.distantPast)
//    }
//
//    var timeIntervalSince1970: Double {
//        return value.timeIntervalSince1970
//    }
//
//    init(timeIntervalSince1970 timeInterval: Double) {
//        self.value = .init(timeIntervalSince1970: timeInterval)
//    }
//
//    public func timeIntervalSince(_ date: Date) -> TimeInterval {
//        return value.timeIntervalSince(date.value)
//    }
//
//    public func addingTimeInterval(_ timeInterval: TimeInterval) -> Date {
//        return Date(value.addingTimeInterval(timeInterval))
//    }
//
//    public var description: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM.dd.yyyy HH:mm:ss"
//        return dateFormatter.string(from: value)
//    }
//}
//
//extension Date: Codable {
//    static var invalidFormat: Swift.Error {
//        return DecodingError.dataCorrupted(.init(
//            codingPath: [],
//            debugDescription: "invalid date"))
//    }
//
//    public init(from decoder: Decoder) throws {
//        let dateString = try String(from: decoder)
//        guard let date = Date(string: dateString) else {
//            throw Date.invalidFormat
//        }
//        self = date
//    }
//
//    init?(string: String) {
//        switch string.allSatisfy({ $0.isNumber }) {
//        case true:
//            guard let timestamp = Double(string) else {
//                return nil
//            }
//            value = .init(timeIntervalSince1970: timestamp)
//        default:
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            guard let date = dateFormatter.date(from: string) else {
//                return nil
//            }
//            value = date
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        let timestamp = value.timeIntervalSince1970
//        try String(Int(timestamp)).encode(to: encoder)
//    }
//}
//
//extension Date: Comparable {
//    public static func < (lhs: Date, rhs: Date) -> Bool {
//        return lhs.value < rhs.value
//    }
//
//    public static func == (lhs: Date, rhs: Date) -> Bool {
//        return lhs.value == rhs.value
//    }
//
//    public func isEqual(
//        to date: Date,
//        toGranularity component: Calendar.Component) -> Bool
//    {
//        value.isEqual(to: date.value, toGranularity: component)
//    }
//
//    public func isInRange(
//        _ range: ClosedRange<Date>,
//        toGranularity component: Calendar.Component) -> Bool
//    {
//        value.isInRange(
//            range.lowerBound.value...range.upperBound.value,
//            toGranularity: component)
//    }
//}
//
//extension Foundation.Date {
//    public func isEqual(
//        to date: Foundation.Date,
//        toGranularity component: Calendar.Component) -> Bool
//    {
//        Calendar.current.isDate(self, equalTo: date, toGranularity: component)
//    }
//
//    public func isInRange(
//        _ range: ClosedRange<Foundation.Date>,
//        toGranularity component: Calendar.Component) -> Bool
//    {
//        return (self > range.lowerBound && self < range.upperBound)
//            || isEqual(to: range.lowerBound, toGranularity: component)
//            || isEqual(to: range.upperBound, toGranularity: component)
//    }
//}




////import struct Foundation.Decimal
//import Foundation
//
//// Foundation.Decimal expects Swift.Double in Codable protocols
//// but we need Swift.String
//
//public struct Decimal {
//    public let value: Foundation.Decimal
//}
//
//extension Decimal {
//    public static var zero: Decimal = .init(value: .zero)
//}
//
//extension Decimal: Codable {
//    public init(from decoder: Decoder) throws {
//        self.init(string: try String(from: decoder))!
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        try String(describing: self).encode(to: encoder)
//    }
//}
//
//extension Decimal: CustomStringConvertible {
//    public var description: String { .init(describing: value) }
//}
//
//extension Decimal: ExpressibleByStringLiteral {
//    public init(stringLiteral value: String) {
//        self.value = Foundation.Decimal(string: value)!
//    }
//}
//
//extension Decimal: ExpressibleByFloatLiteral {
//    public init(floatLiteral value: Double) {
//        self.value = Foundation.Decimal(floatLiteral: value)
//    }
//}
//
//extension Decimal {
//    public init?(string: String) {
//        guard let value = Foundation.Decimal(string: string) else {
//            return nil
//        }
//        self.value = value
//    }
//}
//
//extension Decimal: AdditiveArithmetic {
//    public static func - (lhs: Decimal, rhs: Decimal) -> Decimal {
//        return Decimal(value: lhs.value - rhs.value)
//    }
//
//    public static func + (_ lhs: Decimal, _ rhs: Decimal) -> Decimal {
//        return Decimal(value: lhs.value + rhs.value)
//    }
//
//    public static func * (_ lhs: Decimal, _ rhs: Decimal) -> Decimal {
//        return Decimal(value: lhs.value * rhs.value)
//    }
//
//    public static func / (_ lhs: Decimal, _ rhs: Decimal) -> Decimal {
//        return Decimal(value: lhs.value / rhs.value)
//    }
//
//    public static func += (lhs: inout Decimal, rhs: Decimal) {
//       lhs = lhs + rhs
//    }
//
//    public static func -= (lhs: inout Decimal, rhs: Decimal) {
//       lhs = lhs - rhs
//    }
//
//}
//
//extension Decimal: Comparable {
//    public static func < (lhs: Decimal, rhs: Decimal) -> Bool {
//        return lhs.value < rhs.value
//    }
//}
//
//extension Decimal: Equatable {
//    public static func == (lhs: Decimal, rhs: Decimal) -> Bool {
//        return lhs.value == rhs.value
//    }
//}
//
//extension Decimal {
//    public static func random(in range: ClosedRange<Double>) -> Decimal {
//        return .init(value: .init(Double.random(in: range)))
//    }
//
//    public static func random(in range: Range<Double>) -> Decimal {
//        return .init(value: .init(Double.random(in: range)))
//    }
//}
//
//extension Decimal {
//    public func rounded(
//        decimals scale: Int,
//        mode: NSDecimalNumber.RoundingMode) -> Decimal
//    {
//        var result = Foundation.Decimal()
//        var value = self.value
//        NSDecimalRound(&result, &value, scale, mode)
//        return Decimal(value: result)
//    }
//}
