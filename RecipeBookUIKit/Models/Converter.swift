//
//  Converter.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 12.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation

class Converter {
    static func convert(measure: Measure, to type: DimensionType) -> String? {
        guard let measurement = measure.measurement else {
            return "measure == nil"
        }
        
        print("compare: 1) ", measurement.unit, " with: 2) ", type.type)
        
        var result = 0.0
        switch type {
        case .mass(let mass):
            let massMeasure = mass.measurement
            let converted = measurement.converted(to: massMeasure.unit)
            print("converted mass ", converted)
            result = converted.value

        case .volume(let volume):
            let volumeMeasure = volume.measurement
            let converted = measurement.converted(to: volumeMeasure.unit)
            print("converted volume ", converted)
            result = converted.value

        default:
            print("dimension type: ", type.baseSymbol)
            return ""
        }
        return String(result)
    }

    static func convertToBaseUnit(_ measure: Measure) -> String? {
        guard let measurement = measure.measurement else {
            return ""
        }
        print("measure to convert: ", measurement)
        
        if measure.symbol.isUnitMass {
            let converted = measurement.converted(to: UnitMass.kilograms)
            print("converted sym to mass", converted.value)
            return String(converted.value)
        } else if measure.symbol.isUnitVolume {
            let converted = measurement.converted(to: UnitVolume.liters)
            print("converted sym to volume", converted.value)
            return String(converted.value)
        } else if measure.baseUnitSymbol.isUnitMass {
            let converted = measurement.converted(to: UnitMass.kilograms)
            print("converted base to mass", converted.value)
            return String(converted.value)
        } else if measure.baseUnitSymbol.isUnitVolume {
            let converted = measurement.converted(to: UnitVolume.liters)
            print("converted base to volume", converted.value)
            return String(converted.value)
        } else {
            print("no base unit")
            return "no base unit"
        }
    }
    
    static func convertBaseToUnit(_ measure: Measure, to stringDescription: String) -> String? {
        guard let measurement = measure.measurement else {
            return ""
        }
        let destinationMeasure = Measure.init(
            customProvider: DataStorage.shared,
            value: 0,
            symbol: stringDescription) ?? Measure.init(value: 0, symbol: stringDescription)
        guard let destinationMeasurement = destinationMeasure.measurement else {
            return ""
        }
    
        let converted = measurement.converted(to: destinationMeasurement.unit)
        
        return String(converted.value)
    }
}
