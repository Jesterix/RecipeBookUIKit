//
//  Event.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 03.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import Foundation

/// Single event handler
public typealias EventHandler = () -> ()

public class Event<T> {
    
    public typealias EventHandler = (T) -> ()
    
    private var eventHandlers = [EventHandler]()
    
    public func addHandler(handler: @escaping EventHandler) {
        eventHandlers.append(handler)
    }
    
    public func raise(data: T) {
        for handler in eventHandlers {
            handler(data)
        }
    }
    
    public func clear() {
        eventHandlers.removeAll()
    }
}
