//
//  Predicate.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 12.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

struct Predicate<Target> {
    var matches: (Target) -> Bool

    init(matcher: @escaping (Target) -> Bool) {
        matches = matcher
    }
}

//MARK: - overloaded operators

///let uncompletedItems = list.items(matching: \.isCompleted == false)
func ==<T, V: Equatable>(lhs: KeyPath<T, V>, rhs: V) -> Predicate<T> {
    Predicate { $0[keyPath: lhs] == rhs }
}

///let uncompletedItems = list.items(matching: !\.isCompleted)
prefix func !<T>(rhs: KeyPath<T, Bool>) -> Predicate<T> {
    rhs == false
}

///let highPriorityItems = list.items(matching: \.priority > 5)
func ><T, V: Comparable>(lhs: KeyPath<T, V>, rhs: V) -> Predicate<T> {
    Predicate { $0[keyPath: lhs] > rhs }
}

func <<T, V: Comparable>(lhs: KeyPath<T, V>, rhs: V) -> Predicate<T> {
    Predicate { $0[keyPath: lhs] < rhs }
}

///let overdueItems = list.items(
///    matching: !\.isCompleted && \.dueDate < .now
///)
func &&<T>(lhs: Predicate<T>, rhs: Predicate<T>) -> Predicate<T> {
    Predicate { lhs.matches($0) && rhs.matches($0) }
}

///let myTasks = list.items(
///    matching: \.creator == .currentUser || \.assignedTo == .currentUser
///)
func ||<T>(lhs: Predicate<T>, rhs: Predicate<T>) -> Predicate<T> {
    Predicate { lhs.matches($0) || rhs.matches($0) }
}

///let importantItems = list.items(matching: \.tags ~= "important")
func ~=<T, V: Collection>(
    lhs: KeyPath<T, V>, rhs: V.Element
) -> Predicate<T> where V.Element: Equatable {
    Predicate { $0[keyPath: lhs].contains(rhs) }
}


//import RealmSwift
//import Foundation

//extension Predicate where Target == Ingredient {
//    static var isOverdue: Self {
//        Predicate {
//            $0.title == "" && $0.symbol == ""
//        }
//    }

//    let overdueItems = list.items(matching: .isOverdue)

//    static func isOverdue(
//        comparedTo date: Date = .now,
//        inlcudingCompleted includeCompleted: Bool = false
//    ) -> Self {
//        Predicate {
//            if !includeCompleted {
//                guard !$0.isCompleted else {
//                    return false
//                }
//            }
//
//            return $0.dueDate < date
//        }
//    }
//}

//extension Array where Element == Ingredient {
//    func items(matching predicate: Predicate<Ingredient>) -> [Ingredient] {
//        items.filter(predicate.matches)
//    }
//}


///let strings: [String] = ...
///let predicate: Predicate<String> = \.count > 3
///
///strings.filter(predicate.matches)
///strings.drop(while: predicate.matches)
///strings.prefix(while: predicate.matches)
///strings.contains(where: predicate.matches)
