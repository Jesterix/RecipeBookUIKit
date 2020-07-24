//
//  DataBaseManager.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 22.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation
import RealmSwift

class DataBaseManager {
    private var realm: Realm = try! Realm()

    private lazy var recipes: Results<RealmRecipe> = { self.realm.objects(RealmRecipe.self)
    }()

    func createBaseData() {
        do {
            if recipes.count == 0 {
                try realm.write() {
                    realm.delete(recipes)
                    for recipe in defaultRecipes {
                        let newRecipe = RealmRecipe(from: recipe)
                        realm.add(newRecipe)
                    }
                }
                recipes = realm.objects(RealmRecipe.self)
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    func add(recipe: Recipe) {
        do {
            try realm.write() {
                let newRecipe = RealmRecipe(from: recipe)
                realm.add(newRecipe)
            }
            recipes = realm.objects(RealmRecipe.self)
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    func remove(recipe: Recipe) {
        do {
            try realm.write() {
                if let recipeToDelete = realm.objects(RealmRecipe.self)
                    .first(where: { $0.title == recipe.title}) {
                    realm.delete(recipeToDelete)
                }
            }
            recipes = realm.objects(RealmRecipe.self)
        } catch (let error) {
            print(error.localizedDescription)
        }
    }

    func getRecipesData() -> [Recipe] {
        return recipes.map { $0.converted() }
    }
}
