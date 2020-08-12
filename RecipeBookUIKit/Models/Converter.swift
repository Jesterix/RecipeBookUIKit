//
//  Converter.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 12.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation

class Converter {
    static func convert(oldValue: Measure, newValue: Measure) -> String? {
        print("convert from \(oldValue) \nto: \(newValue)")

        guard oldValue.type != .undefined && newValue.type != .undefined else {
            return ""
        }

        guard let old = oldValue.measurement, let new = newValue.measurement else {
            return ""
        }

        let converted = old.converted(to: new.unit)

        print("value ", converted.value)

        return String(converted.value)
    }
}
