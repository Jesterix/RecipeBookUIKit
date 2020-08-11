//
//  Settings.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 11.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

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

    static var defaultDimensions: [DimensionType] = [.mass(DimensionType.Mass.grams), .volume(DimensionType.Volume.liters), .undefined]
}
