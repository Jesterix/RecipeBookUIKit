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

    static func empty() -> Ingredient {
        return Ingredient(title: "")
    }
}

