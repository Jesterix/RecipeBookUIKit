//
//  RealmIngredient.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 22.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation
import RealmSwift

class RealmIngredient: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var value: Double = 0.0
    @objc dynamic var symbol: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }

    convenience init(from ingredient: Ingredient) {
        self.init()
        id = ingredient.id
        title = ingredient.title
        guard let measurement = ingredient.measurement else {
            return
        }
        value = measurement.value
        symbol = measurement.symbol
    }

    func converted() -> Ingredient {
        return Ingredient(
            id: id,
            title: title,
            measurement: Measure(value: value, symbol: symbol)
        )
    }
}
