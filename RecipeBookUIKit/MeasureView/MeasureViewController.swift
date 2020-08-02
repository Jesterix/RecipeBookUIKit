//
//  MeasureViewController.swift
//  RecipeBookUIKit
//
//  Created by Georgy Khaydenko on 28.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit
import Foundation

final class MeasureViewController: UIViewController {
    private var measureView: MeasureView!
    var measurement: Measurement<Unit>?

    override func loadView() {
        self.measureView = MeasureView()
        self.view = measureView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        measureView.addButton.addTarget(
            self,
            action: #selector(tapAdd),
            for: .touchUpInside)

        measureView.convertButton.addTarget(
            self,
            action: #selector(tapConvert),
            for: .touchUpInside)

        measureView.cancelButton.addTarget(
            self,
            action: #selector(tapAdd),
            for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(push))
        self.view.addGestureRecognizer(tap)
    }

    @objc func tapAdd() {
        measureView.addButton.isPrimary.toggle()
        measureView.cancelButton.isHidden = measureView.addButton.isPrimary
        measureView.convertButton.isEnabled = measureView.addButton.isPrimary
    }

    @objc func tapConvert() {
        measureView.convertButton.isPrimary.toggle()
        measureView.addButton.isEnabled = measureView.convertButton.isPrimary
    }
    
    @objc func push(){
        //        self.dismiss(animated: true, completion: nil)
        print("dismiss measure")
    }
}
