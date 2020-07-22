//
//  RealmRecipe.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 22.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation
import RealmSwift

class RealmRecipe: Object {
    @objc dynamic var title: String = ""
    let ingredients = List<RealmIngredient>()
    @objc dynamic var text: String = ""

    convenience init(from recipe: Recipe) {
        self.init()
        title = recipe.title
        ingredients.append(objectsIn: recipe.ingredients.map { RealmIngredient(from: $0) })
        text = recipe.text
    }

    func converted() -> Recipe {
        return Recipe(
            title: self.title,
            ingredients: self.ingredients.map { $0.converted() },
            text: self.text
        )
    }
}
