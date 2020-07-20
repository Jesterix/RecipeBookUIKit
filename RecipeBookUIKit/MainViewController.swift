//
//  MainViewController.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 20.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    private var mainView: MainView!

    override func loadView() {
        self.mainView = MainView()
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Recipes"

        hideKeyboardOnTap()
    }
}

