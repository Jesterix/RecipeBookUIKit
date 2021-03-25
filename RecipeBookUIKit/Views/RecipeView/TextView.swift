//
//  TextView.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 13.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

final class TextView: UITextView {
    
    public var willChangeHeight = false

    //MARK:- Methods
    public init() {
        super.init(frame: .zero, textContainer: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
//        addSubview(hint)
//        addSubview(textView)
//
//        applyStyle()
//        textView.delegate = self
        isScrollEnabled = false
//        textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        textContainer.lineFragmentPadding = 0
//        text = ""
        autocorrectionType = .no

//        let color = #colorLiteral(red: 0.9609501958, green: 0.8888508081, blue: 0.8478230238, alpha: 0.9998855591)
        backgroundColor = .lightlyGray
        layer.cornerRadius = 10
        font = .systemFont(ofSize: 15)
        textColor = .darkBrown
        addStandartToolbar()
    }
}
