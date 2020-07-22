//
//  RealmRecipe.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 22.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import RealmSwift

class RealmRecipe: Object {
    dynamic var title: String = ""
    dynamic var ingredients: [RealmIngredient] = []
    dynamic var text: String = ""
}
