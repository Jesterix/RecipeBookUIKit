import Foundation

///This enum help to initiate measures from user input
public enum DimensionType: Equatable {
//    MARK: - Mass enum
    public enum Mass: String, CaseIterable, Comparable {
        public static func < (lhs: DimensionType.Mass, rhs: DimensionType.Mass) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        case kilograms, grams, decigrams, centigrams, milligrams, micrograms, nanograms, picograms, ounces, pounds, stones, metricTons, shortTons, carats, ouncesTroy, slugs
        
        var symbol: String {
            switch self {
            case .kilograms:
                return String.shortFormatted(from: UnitMass.kilograms)
            case .grams:
                return String.shortFormatted(from: UnitMass.grams)
            case .decigrams:
                return String.shortFormatted(from: UnitMass.decigrams)
            case .centigrams:
                return String.shortFormatted(from: UnitMass.centigrams)
            case .milligrams:
                return String.shortFormatted(from: UnitMass.milligrams)
            case .micrograms:
                return String.shortFormatted(from: UnitMass.micrograms)
            case .nanograms:
                return String.shortFormatted(from: UnitMass.nanograms)
            case .picograms:
                return String.shortFormatted(from: UnitMass.picograms)
            case .ounces:
                return String.shortFormatted(from: UnitMass.ounces)
            case .pounds:
                return String.shortFormatted(from: UnitMass.pounds)
            case .stones:
                return String.shortFormatted(from: UnitMass.stones)
            case .metricTons:
                return String.shortFormatted(from: UnitMass.metricTons)
            case .shortTons:
                return String.shortFormatted(from: UnitMass.shortTons)
            case .carats:
                return String.shortFormatted(from: UnitMass.carats)
            case .ouncesTroy:
                return String.shortFormatted(from: UnitMass.ouncesTroy)
            case .slugs:
                return String.shortFormatted(from: UnitMass.slugs)
            }
        }

        var measurement: Measurement<UnitMass> {
            switch self {
                case .kilograms:
                    return 0.2.kilograms
                case .grams:
                    return 0.0.grams
                case .decigrams:
                    return 0.7.decigrams
                case .centigrams:
                    return 0.8.centigrams
                case .milligrams:
                    return 0.1.milligrams
                case .micrograms:
                    return 0.9.micrograms
                case .nanograms:
                    return 1.0.nanograms
                case .picograms:
                    return 1.1.picograms
                case .ounces:
                    return 0.3.ounces
                case .pounds:
                    return 0.4.pounds
                case .stones:
                    return 1.2.stones
                case .metricTons:
                    return 1.3.metricTons
                case .shortTons:
                    return 1.4.shortTons
                case .carats:
                    return 0.6.carats
                case .ouncesTroy:
                    return 0.5.ouncesTroy
                case .slugs:
                    return 1.5.slugs
            }
        }

        init?(symbol: String) {
            if symbol.isSymbol(of: UnitMass.kilograms) {
                self = .kilograms
            } else if symbol.isSymbol(of: UnitMass.grams) {
                self = .grams
            } else if symbol.isSymbol(of: UnitMass.decigrams) {
                self = .decigrams
            } else if symbol.isSymbol(of: UnitMass.centigrams) {
                self = .centigrams
            } else if symbol.isSymbol(of: UnitMass.milligrams) {
                self = .milligrams
            } else if symbol.isSymbol(of: UnitMass.micrograms) {
                self = .micrograms
            } else if symbol.isSymbol(of: UnitMass.nanograms) {
                self = .nanograms
            } else if symbol.isSymbol(of: UnitMass.picograms) {
                self = .picograms
            } else if symbol.isSymbol(of: UnitMass.ounces) {
                self = .ounces
            } else if symbol.isSymbol(of: UnitMass.pounds) {
                self = .pounds
            } else if symbol.isSymbol(of: UnitMass.stones) {
                self = .stones
            } else if symbol.isSymbol(of: UnitMass.metricTons) {
                self = .metricTons
            } else if symbol.isSymbol(of: UnitMass.shortTons) {
                self = .shortTons
            } else if symbol.isSymbol(of: UnitMass.carats) {
                self = .carats
            } else if symbol.isSymbol(of: UnitMass.ouncesTroy) {
                self = .ouncesTroy
            } else if symbol.isSymbol(of: UnitMass.slugs) {
                self = .slugs
            } else {
                return nil
            }
        }
    }
//    MARK: - Volume enum
    public enum Volume: String, CaseIterable, Comparable {
        public static func < (lhs: DimensionType.Volume, rhs: DimensionType.Volume) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        case megaliters, kiloliters, liters, deciliters, centiliters, milliliters, cubicKilometers, cubicMeters, cubicDecimeters, cubicCentimeters, cubicMillimeters, cubicInches, cubicFeet, cubicYards, cubicMiles, acreFeet, bushels, teaspoons, tablespoons, fluidOunces, cups, pints, quarts, gallons, imperialTeaspoons, imperialTablespoons, imperialFluidOunces, imperialPints, imperialQuarts, imperialGallons, metricCups

        var symbol: String {
            switch self {
            case .megaliters:
                return String.shortFormatted(from: UnitVolume.megaliters)
            case .kiloliters:
                return String.shortFormatted(from: UnitVolume.kiloliters)
            case .liters:
                return String.shortFormatted(from: UnitVolume.liters)
            case .deciliters:
                return String.shortFormatted(from: UnitVolume.deciliters)
            case .centiliters:
                return String.shortFormatted(from: UnitVolume.centiliters)
            case .milliliters:
                return String.shortFormatted(from: UnitVolume.milliliters)
            case .cubicKilometers:
                return String.shortFormatted(from: UnitVolume.cubicKilometers)
            case .cubicMeters:
                return String.shortFormatted(from: UnitVolume.cubicMeters)
            case .cubicDecimeters:
                return String.shortFormatted(from: UnitVolume.cubicDecimeters)
            case .cubicCentimeters:
                return String.shortFormatted(from: UnitVolume.cubicCentimeters)
            case .cubicMillimeters:
                return String.shortFormatted(from: UnitVolume.cubicMillimeters)
            case .cubicInches:
                return String.shortFormatted(from: UnitVolume.cubicInches)
            case .cubicFeet:
                return String.shortFormatted(from: UnitVolume.cubicFeet)
            case .cubicYards:
                return String.shortFormatted(from: UnitVolume.cubicYards)
            case .cubicMiles:
                return String.shortFormatted(from: UnitVolume.cubicMiles)
            case .acreFeet:
                return String.shortFormatted(from: UnitVolume.acreFeet)
            case .bushels:
                return String.shortFormatted(from: UnitVolume.bushels)
            case .teaspoons:
                return String.shortFormatted(from: UnitVolume.teaspoons)
            case .tablespoons:
                return String.shortFormatted(from: UnitVolume.tablespoons)
            case .fluidOunces:
                return String.shortFormatted(from: UnitVolume.fluidOunces)
            case .cups:
                return String.shortFormatted(from: UnitVolume.cups)
            case .pints:
                return String.shortFormatted(from: UnitVolume.pints)
            case .quarts:
                return String.shortFormatted(from: UnitVolume.quarts)
            case .gallons:
                return String.shortFormatted(from: UnitVolume.gallons)
            case .imperialTeaspoons:
                return String.shortFormatted(from: UnitVolume.imperialTeaspoons)
            case .imperialTablespoons:
                return String.shortFormatted(from: UnitVolume.imperialTablespoons)
            case .imperialFluidOunces:
                return String.shortFormatted(from: UnitVolume.imperialFluidOunces)
            case .imperialPints:
                return String.shortFormatted(from: UnitVolume.imperialPints)
            case .imperialQuarts:
                return String.shortFormatted(from: UnitVolume.imperialQuarts)
            case .imperialGallons:
                return String.shortFormatted(from: UnitVolume.imperialGallons)
            case .metricCups:
                return String.shortFormatted(from: UnitVolume.metricCups)
            }
        }

        var measurement: Measurement<UnitVolume> {
            switch self {
            case .megaliters:
                return 2.6.megaliters
            case .kiloliters:
                return 2.5.kiloliters
            case .liters:
                return 0.1.liters
            case .deciliters:
                return 2.4.deciliters
            case .centiliters:
                return 2.3.centiliters
            case .milliliters:
                return 0.0.milliliters
            case .cubicKilometers:
                return 2.2.cubicKilometers
            case .cubicMeters:
                return 2.1.cubicMeters
            case .cubicDecimeters:
                return 2.0.cubicDecimeters
            case .cubicCentimeters:
                return 1.9.cubicCentimeters
            case .cubicMillimeters:
                return 1.8.cubicMillimeters
            case .cubicInches:
                return 2.7.cubicInches
            case .cubicFeet:
                return 2.8.cubicFeet
            case .cubicYards:
                return 2.9.cubicYards
            case .cubicMiles:
                return 3.0.cubicMiles
            case .acreFeet:
                return 1.7.acreFeet
            case .bushels:
                return 1.0.bushels
            case .teaspoons:
                return 0.2.teaspoons
            case .tablespoons:
                return 0.3.tablespoons
            case .fluidOunces:
                return 0.4.fluidOunces
            case .cups:
                return 0.5.cups
            case .pints:
                return 0.7.pints
            case .quarts:
                return 0.8.quarts
            case .gallons:
                return 0.9.gallons
            case .imperialTeaspoons:
                return 1.1.imperialTeaspoons
            case .imperialTablespoons:
                return 1.2.imperialTablespoons
            case .imperialFluidOunces:
                return 1.3.imperialFluidOunces
            case .imperialPints:
                return 1.4.imperialPints
            case .imperialQuarts:
                return 1.5.imperialQuarts
            case .imperialGallons:
                return 1.6.imperialGallons
            case .metricCups:
                return 0.6.metricCups
            }
        }

        init?(symbol: String) {
            if symbol.isSymbol(of: UnitVolume.megaliters) {
                self = .megaliters
            } else if symbol.isSymbol(of: UnitVolume.kiloliters) {
                self = .kiloliters
            } else if symbol.isSymbol(of: UnitVolume.liters) {
                self = .liters
            } else if symbol.isSymbol(of: UnitVolume.deciliters) {
                self = .deciliters
            } else if symbol.isSymbol(of: UnitVolume.centiliters) {
                self = .centiliters
            } else if symbol.isSymbol(of: UnitVolume.milliliters) {
                self = .milliliters
            } else if symbol.isSymbol(of: UnitVolume.cubicKilometers) {
                self = .cubicKilometers
            } else if symbol.isSymbol(of: UnitVolume.cubicMeters) {
                self = .cubicMeters
            } else if symbol.isSymbol(of: UnitVolume.cubicDecimeters) {
                self = .cubicDecimeters
            } else if symbol.isSymbol(of: UnitVolume.cubicCentimeters) {
                self = .cubicCentimeters
            } else if symbol.isSymbol(of: UnitVolume.cubicMillimeters) {
                self = .cubicMillimeters
            } else if symbol.isSymbol(of: UnitVolume.cubicInches) {
                self = .cubicInches
            } else if symbol.isSymbol(of: UnitVolume.cubicFeet) {
                self = .cubicFeet
            } else if symbol.isSymbol(of: UnitVolume.cubicYards) {
                self = .cubicYards
            } else if symbol.isSymbol(of: UnitVolume.cubicMiles) {
                self = .cubicMiles
            } else if symbol.isSymbol(of: UnitVolume.acreFeet) {
                self = .acreFeet
            } else if symbol.isSymbol(of: UnitVolume.bushels) {
                self = .bushels
            } else if symbol.isSymbol(of: UnitVolume.teaspoons) {
                self = .teaspoons
            } else if symbol.isSymbol(of: UnitVolume.tablespoons) {
                self = .tablespoons
            } else if symbol.isSymbol(of: UnitVolume.fluidOunces) {
                self = .fluidOunces
            } else if symbol.isSymbol(of: UnitVolume.cups) {
                self = .cups
            } else if symbol.isSymbol(of: UnitVolume.pints) {
                self = .pints
            } else if symbol.isSymbol(of: UnitVolume.quarts) {
                self = .quarts
            } else if symbol.isSymbol(of: UnitVolume.gallons) {
                self = .gallons
            } else if symbol.isSymbol(of: UnitVolume.imperialTeaspoons) {
                self = .imperialTeaspoons
            } else if symbol.isSymbol(of: UnitVolume.imperialTablespoons) {
                self = .imperialTablespoons
            } else if symbol.isSymbol(of: UnitVolume.imperialFluidOunces) {
                self = .imperialFluidOunces
            } else if symbol.isSymbol(of: UnitVolume.imperialPints) {
                self = .imperialPints
            } else if symbol.isSymbol(of: UnitVolume.imperialQuarts) {
                self = .imperialQuarts
            } else if symbol.isSymbol(of: UnitVolume.imperialGallons) {
                self = .imperialGallons
            } else if symbol.isSymbol(of: UnitVolume.metricCups) {
                self = .metricCups
            } else {
                return nil
            }
        }
    }
//    MARK: - Dimension enum cases

    case mass(Mass)
    case volume(Volume)
    case custom

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

    public var typeDescription: String {
        switch self {
        case .mass:
            return "Library.Dimension.Mass"
        case .volume:
            return "Library.Dimension.Volume"
        case .custom:
            return "Library.Dimension.Custom"
        }
    }
    
    public var baseSymbol: String {
        switch self {
        case .mass:
            return String.shortFormatted(from: UnitMass.kilograms)
        case .volume:
            return String.shortFormatted(from: UnitVolume.liters)
        case .custom:
            return ""
        }
    }

    static var allMassCases: [String] {
        return allMass + allMassSymbols
    }
    
    public static var allMass: [String] {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .long
        formatter.locale = Locale.current
        return DimensionType.Mass.allCases
            .sorted { $0.measurement.value < $1.measurement.value }
            .map { formatter.string(from: $0.measurement.unit) }
    }
    
    public static var allMassSymbols: [String] {
        return DimensionType.Mass.allCases
            .sorted { $0.measurement.value < $1.measurement.value }
            .map { $0.symbol }
    }

    static var allVolumeCases: [String] {
        return allVolume + allVolumeSymbols
    }
    
    public static var allVolume: [String] {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .long
        formatter.locale = Locale.current
        return DimensionType.Volume.allCases
            .sorted { $0.measurement.value < $1.measurement.value }
            .map { formatter.string(from: $0.measurement.unit) }
    }
    
    public static var allVolumeSymbols: [String] {
        return DimensionType.Volume.allCases
            .sorted { $0.measurement.value < $1.measurement.value }
            .map { $0.symbol }
    }

    init(with symbol: String) {
        if symbol.isUnitMass {
            self = .mass(DimensionType.Mass.init(symbol: symbol)!)
        } else if symbol.isUnitVolume {
            self = .volume(DimensionType.Volume.init(symbol: symbol)!)
        } else {
            self = .custom
        }
    }
    
    init?(with customProvider: CustomMeasureProvider, symbol: String) {
        guard let customMeasure = (customProvider.customMeasures
            .first { $0.title == symbol }) else {
                return nil
        }
        self.init(with: customMeasure.baseUnitSymbol)
    }
}

//    MARK: - Measure struct

public struct Measure {
    public var value: Double
    public var coefficient: Double = 1
    public var symbol: String {
        didSet {
            setBaseUnitSymbol()
        }
    }
    public var shortSymbol: String {
        if symbol.isUnitMass {
            guard let dimension = DimensionType.Mass.init(symbol: symbol) else {
                return symbol
            }
            return dimension.symbol
        } else if symbol.isUnitVolume {
            guard let dimension = DimensionType.Volume.init(symbol: symbol) else {
                return symbol
            }
            return dimension.symbol
        } else {
            return symbol
        }
    }
    public var baseUnitSymbol: String = ""
    
    public var isStandart: Bool {
        return symbol.isUnitMass || symbol.isUnitVolume
    }
    
    public init(value: Double, symbol: String) {
        self.value = value
        self.symbol = symbol
        setBaseUnitSymbol()
    }
    
    public init?(customProvider: CustomMeasureProvider, value: Double, symbol: String) {
        guard let customMeasure = (customProvider.customMeasures
            .first { $0.title == symbol }) else {
                return nil
        }
        self.value = value
        self.symbol = symbol
        self.baseUnitSymbol = customMeasure.baseUnitSymbol
        self.coefficient = customMeasure.coefficient
    }
    
    private mutating func setBaseUnitSymbol() {
        if symbol.isUnitMass {
            baseUnitSymbol = String.shortFormatted(from: UnitMass.kilograms)
        } else if symbol.isUnitVolume {
            baseUnitSymbol = String.shortFormatted(from: UnitVolume.liters)
        }
    }
}

extension Measure {
    ///do not include value comparing for converter needs
    public static func != (lhs: Measure, rhs: Measure) -> Bool {
//        return lhs.type != rhs.type || lhs.coefficient != rhs.coefficient || lhs._symbol != rhs._symbol
        return lhs.coefficient != rhs.coefficient || lhs.symbol != rhs.symbol || lhs.baseUnitSymbol != rhs.baseUnitSymbol
    }
}

extension Measure {
    public var measurement: Measurement<Dimension>? {
        if symbol.isUnitMass {
            
            guard let dimension = DimensionType.Mass.init(symbol: symbol) else {
                return nil
            }
            let measure = Measurement(value: value, unit: dimension.measurement.unit) as Measurement<Dimension>
            return measure
            
        } else if symbol.isUnitVolume {
            
            guard let dimension = DimensionType.Volume.init(symbol: symbol) else {
                return nil
            }
            let measure = Measurement(value: value, unit: dimension.measurement.unit) as Measurement<Dimension>
            return measure
            
        } else if baseUnitSymbol.isUnitMass {
            
            let unit = UnitMass(
                symbol: symbol,
                converter: UnitConverterLinear(coefficient: coefficient)) as Dimension
            let measure = Measurement(value: value, unit: unit)
            return measure
        
        } else if baseUnitSymbol.isUnitVolume {
            
            let unit = UnitVolume(
                symbol: symbol,
                converter: UnitConverterLinear(coefficient: coefficient)) as Dimension
            let measure = Measurement(value: value, unit: unit)
            return measure
            
        } else {
            return nil
        }
    }
}

public extension String {
    var isUnitMass: Bool {
        return DimensionType.allMassCases.contains(self)
    }
    
    var isUnitVolume: Bool {
        return DimensionType.allVolumeCases.contains(self)
    }
}

//MeasurementFormatter extension for string
public extension String {
    static func longFormatted(
        from unit: Unit,
        locale: Locale = Locale.current
    ) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .long
        formatter.locale = locale
        return formatter.string(from: unit)
    }
    
    static func shortFormatted(
        from unit: Unit,
        locale: Locale = Locale.current
    ) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.locale = locale
        return formatter.string(from: unit)
    }
    
    func isSymbol(of unit: Unit) -> Bool {
        return self == String.longFormatted(from: unit)
            || self == String.longFormatted(from: unit, locale: Locale(identifier: "en_US"))
            || self == String.shortFormatted(from: unit)
            || self == String.shortFormatted(from: unit, locale: Locale(identifier: "en_US"))
    }
}
