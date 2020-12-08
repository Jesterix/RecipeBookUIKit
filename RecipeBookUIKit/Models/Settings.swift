//
//  Settings.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 11.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import MeasureLibrary

class Settings {
    static var defaultRecipes = [
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

    static var defaultDimensions: [DimensionType] = [.mass(DimensionType.Mass.grams), .volume(DimensionType.Volume.liters), .custom]
    
    static var basicIngredients: [BasicIngredient] = [
        BasicIngredient(
            title: "Water",
            titleLocalized: "Water".localized(),
            density: 1),
        BasicIngredient(
            title: "Wheat flour",
            titleLocalized: "Wheat flour".localized(),
            density: 0.59),
        BasicIngredient(
            title: "Butter",
            titleLocalized: "Butter".localized(),
            density: 0.865),
        BasicIngredient(
            title: "Olive oil",
            titleLocalized: "Olive oil".localized(),
            density: 0.915),
        BasicIngredient(
            title: "Granulated sugar",
            titleLocalized: "Granulated sugar".localized(),
            density: 0.85),
        BasicIngredient(
            title: "Fine salt",
            titleLocalized: "Fine salt".localized(),
            density: 1.2),
        BasicIngredient(
            title: "Milk",
            titleLocalized: "Milk".localized(),
            density: 1.04),
    ]
}

struct BasicIngredient {
    var title: String
    var titleLocalized: String
    var density: Double
}
