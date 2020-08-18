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
            result = converted.value

        case .volume(let volume):
            let volumeMeasure = volume.measurement
            let converted = measurement.converted(to: volumeMeasure.unit)
            result = converted.value

        default:
            return "type == custom"
        }
        return String(result)
    }

    static func convertToBaseUnit(_ measure: Measure) -> String? {
        guard let measurement = measure.measurement, let baseUnit = measure.baseUnit as? Dimension else {
            return ""
        }

        let converted = measurement.converted(to: baseUnit)
        return String(converted.value)
    }
}
