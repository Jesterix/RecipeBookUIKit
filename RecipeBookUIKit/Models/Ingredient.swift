//
//  Ingredient.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 20.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation

struct Ingredient {
    var id: String = UUID().uuidString
    var title: String
    var measurement: Measurement<Unit>? = nil

    static func empty() -> Ingredient {
        return Ingredient(title: "")
    }
}

var defaultRecipes = [
    Recipe(
        title: "first",
        ingredients: [
            Ingredient(
                title: "Water",
                measurement: Measurement(
                    value: 3,
                    unit: UnitMass.grams)),
            Ingredient(
                title: "Flour",
                measurement: Measurement(
                    value: 5.34,
                    unit: Unit(symbol: "шт")))],
        text: "Put one vial of water.."),
    Recipe(
        title: "second",
        text: "recipeText here"),
    Recipe(title: "third")]
