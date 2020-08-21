//
//  RecipeDataHandler.swift
//  RecipeBookUIKit
//
//  Created by Georgy Khaydenko on 22.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation

class RecipeDataHandler {
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
