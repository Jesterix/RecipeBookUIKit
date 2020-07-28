//
//  MeasureViewController.swift
//  RecipeBookUIKit
//
//  Created by Georgy Khaydenko on 28.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class MeasureViewController: UIViewController {
    private var measureView: MeasureView!

    override func loadView() {
        self.measureView = MeasureView()
        self.view = measureView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(push))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func push(){
        self.dismiss(animated: true, completion: nil)
    }
}
