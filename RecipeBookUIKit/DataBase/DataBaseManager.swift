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
    
    func getRecipes() -> [Recipe] {
        return recipes.map { $0.converted() }
    }
    
    func remove(recipe: Recipe) {
        do {
            try realm.write() {
                if let recipeToDelete =
                    realm.object(
                        ofType: RealmRecipe.self,
                        forPrimaryKey: recipe.id) {
                    realm.delete(recipeToDelete)
                }
            }
            recipes = realm.objects(RealmRecipe.self)
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    func update(recipe: Recipe) {
        do {
            try realm.write() {
                let recipeToUpdate = RealmRecipe(from: recipe)
                realm.add(recipeToUpdate, update: .modified)
            }
            recipes = realm.objects(RealmRecipe.self)
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
}
