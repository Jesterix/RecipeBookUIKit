//
//  DataBaseManager.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 22.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation
import RealmSwift
import MeasureLibrary

class DataBaseManager {
    private var realm: Realm = try! Realm()

    private lazy var recipes: Results<RealmRecipe> = { self.realm.objects(RealmRecipe.self)
    }()

    private lazy var ingredients: Results<RealmIngredient> = { self.realm.objects(RealmIngredient.self)
    }()
    
    private lazy var customMeasures: Results<RealmCustomMeasurement> = { self.realm.objects(RealmCustomMeasurement.self)
    }()

    func createBaseData() {
        do {
            if recipes.count == 0 {
                try realm.write() {
                    realm.delete(recipes)
                    for recipe in Settings.defaultRecipes {
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
    
    func getCustomMeasures() -> [CustomMeasure] {
        return customMeasures.map { $0.converted() }
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
    
    func update(measure: CustomMeasure) {
        do {
            try realm.write() {
                let measureToUpdate = RealmCustomMeasurement(from: measure)
                realm.add(measureToUpdate, update: .modified)
            }
            customMeasures = realm.objects(RealmCustomMeasurement.self)
        } catch (let error) {
            print(error.localizedDescription)
        }
    }

    func getUserMeasures() -> [String] {
        var allIngredients: [Ingredient] = []

        ingredients.forEach { ing in
            allIngredients.append(ing.converted())
        }

        let filteredIngredients = allIngredients.filter { ing -> Bool in
            guard let measure = ing.measurement else {
                return false
            }
            return !measure.symbol.isUnitMass || !measure.symbol.isUnitVolume
        }.map { $0.measurement?.symbol ?? "" }

        return filteredIngredients
    }
}
