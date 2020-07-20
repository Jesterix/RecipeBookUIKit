//
//  Ingredient.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 20.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation

struct Ingredient {
    var title: String
    var value: Double = 0
    var measurement: Measurement<Unit>? = nil

    static func empty() -> Ingredient {
        return Ingredient(title: "")
    }
}
