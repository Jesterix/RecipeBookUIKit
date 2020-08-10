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
    var measurement: Measure? = nil

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
                measurement: Measure(value: 3, symbol: "g")),
            Ingredient(
                title: "Flour",
                measurement: Measure(value: 5.34, symbol: "шт"))],
        text: "Put one vial of water.."),
    Recipe(
        title: "second",
        text: "recipeText here"),
    Recipe(title: "third")]
