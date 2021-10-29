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
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    let portions = RealmProperty<Double?>()
    let ingredients = List<RealmIngredient>()
    @objc dynamic var text: String = ""
    let attachmentsInfo = List<RealmAttachmentInfo>()
    
    override class func primaryKey() -> String? {
        return "id"
    }

    convenience init(from recipe: Recipe) {
        self.init()
        id = recipe.id
        title = recipe.title
        portions.value = recipe.numberOfPortions
        ingredients.append(objectsIn: recipe.ingredients.map {
            RealmIngredient(from: $0)
        })
        text = recipe.text
        attachmentsInfo.append(objectsIn: recipe.attachmentsInfo.map {
            RealmAttachmentInfo(from: $0)
        })
    }

    func converted() -> Recipe {
        return Recipe(
            id: id,
            title: title,
            numberOfPortions: portions.value,
            ingredients: ingredients.map { $0.converted() },
            text: text,
            attachmentsInfo: attachmentsInfo.map { $0.converted() }
        )
    }
}
