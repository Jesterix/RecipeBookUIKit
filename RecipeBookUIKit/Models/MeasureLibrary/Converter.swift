//
//  Converter.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 12.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation

class Converter {
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
    
    static func convertPortions(in recipe: inout Recipe, with coefficient: Double) {
        let multiplier = coefficient / (recipe.numberOfPortions ?? 1)
        recipe.numberOfPortions = coefficient
        
        recipe.ingredients = recipe.ingredients.map { ing in
            var mutableIng = ing
            guard let ingValue = ing.measurement?.value else {
                return ing
            }
            mutableIng.measurement?.value = ingValue * multiplier
            return mutableIng
        }
    }
}
