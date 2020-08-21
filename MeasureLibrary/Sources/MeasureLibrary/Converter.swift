import Foundation

class Converter {
    static func convertToBaseUnit(_ measure: Measure) -> String? {
        guard let measurement = measure.measurement else {
            return ""
        }
        
        if measure.symbol.isUnitMass {
            let converted = measurement.converted(to: UnitMass.kilograms)
            return String(converted.value)
        } else if measure.symbol.isUnitVolume {
            let converted = measurement.converted(to: UnitVolume.liters)
            return String(converted.value)
        } else if measure.baseUnitSymbol.isUnitMass {
            let converted = measurement.converted(to: UnitMass.kilograms)
            return String(converted.value)
        } else if measure.baseUnitSymbol.isUnitVolume {
            let converted = measurement.converted(to: UnitVolume.liters)
            return String(converted.value)
        } else {
            return "no base unit"
        }
    }
    
    static func convertBaseToUnit(_ measure: Measure, to stringDescription: String, with customProvider: CustomMeasureProvider) -> String? {
        guard let measurement = measure.measurement else {
            return ""
        }
        let destinationMeasure = Measure.init(
            customProvider: customProvider,
            value: 0,
            symbol: stringDescription) ?? Measure.init(value: 0, symbol: stringDescription)
        guard let destinationMeasurement = destinationMeasure.measurement else {
            return ""
        }
    
        let converted = measurement.converted(to: destinationMeasurement.unit)
        
        return String(converted.value)
    }
}
