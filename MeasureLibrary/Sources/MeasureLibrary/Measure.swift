import Foundation

///This enum help to initiate measures from user input
enum DimensionType: Equatable {
//    MARK: - Mass enum
    enum Mass: String, CaseIterable, Comparable {
        static func < (lhs: DimensionType.Mass, rhs: DimensionType.Mass) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
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
            switch symbol {
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
//    MARK: - Volume enum
    enum Volume: String, CaseIterable, Comparable {
        static func < (lhs: DimensionType.Volume, rhs: DimensionType.Volume) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
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
            switch symbol {
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

    var typeDescription: String {
        switch self {
        case .mass:
            return "mass"
        case .volume:
            return "volume"
        case .custom:
            return "custom"
        }
    }
    
    var baseSymbol: String {
        switch self {
        case .mass:
            return "kg"
        case .volume:
            return "L"
        case .custom:
            return ""
        }
    }

    static var allMassCases: [String] {
        var result: [String] = []
        for type in DimensionType.Mass.allCases {
            result.append(type.rawValue)
            result.append(type.symbol)
        }
        return result
    }
    
    static var allMass: [String] {
        return DimensionType.Mass.allCases
            .sorted { $0.measurement.value < $1.measurement.value }
            .map { $0.rawValue }
    }
    
    static var allMassSymbols: [String] {
        return DimensionType.Mass.allCases
            .sorted { $0.measurement.value < $1.measurement.value }
            .map { $0.symbol }
    }

    static var allVolumeCases: [String] {
        var result: [String] = []
        for type in DimensionType.Volume.allCases {
            result.append(type.rawValue)
            result.append(type.symbol)
        }
        return result
    }
    
    static var allVolume: [String] {
        return DimensionType.Volume.allCases
            .sorted { $0.measurement.value < $1.measurement.value }
            .map { $0.rawValue }
    }
    
    static var allVolumeSymbols: [String] {
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

struct Measure {
    var value: Double
    var coefficient: Double = 1
    var symbol: String {
        didSet {
            setBaseUnitSymbol()
        }
    }
    var baseUnitSymbol: String = ""
    
    var isStandart: Bool {
        return symbol.isUnitMass || symbol.isUnitVolume
    }
    
    init(value: Double, symbol: String) {
        self.value = value
        self.symbol = symbol
        setBaseUnitSymbol()
    }
    
    init?(customProvider: CustomMeasureProvider, value: Double, symbol: String) {
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
            baseUnitSymbol = UnitMass.kilograms.symbol
        } else if symbol.isUnitVolume {
            baseUnitSymbol = UnitVolume.liters.symbol
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
    var measurement: Measurement<Dimension>? {
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

extension String {
    var isUnitMass: Bool {
        return DimensionType.allMassCases.contains(self)
    }
    
    var isUnitVolume: Bool {
        return DimensionType.allVolumeCases.contains(self)
    }
}
