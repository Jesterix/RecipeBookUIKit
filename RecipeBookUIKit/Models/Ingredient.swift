//
//  Ingredient.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 20.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation
import MeasureLibrary

struct Ingredient {
    var id: String = UUID().uuidString
    var title: String
    var measurement: Measure? = nil
    var description: String {
        var full = title
        guard let measure = measurement else {
            return full
        }
        full += " \(measure.value) \(measure.symbol)"
        return full
    }

    static func empty() -> Ingredient {
        return Ingredient(title: "")
    }
}

