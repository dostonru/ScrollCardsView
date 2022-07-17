// ViewController.swift
// ScrollCardsView , 
// Created by Doston Rustamov 17/07/22.
// Copyright 2022 Doston Rustamov . All rights reserved.

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spacing = 10.0
        
        let horizontalScrollCardsFrame = CGRect(
            x: spacing,
            y: 80,
            width: view.frame.width - 2 * spacing,
            height: 130
        )
        
        let scrollview = HorizontalCardScrollView(frame: horizontalScrollCardsFrame,offset: 5)
        scrollview.dataSource = self
        scrollview.cardsDelegate = self
        view.addSubview(scrollview)
    }
}

extension ViewController: HorizontalCardScrollViewDataSource {
    
    func horizontalCardScrollView(_ horizontalCardScrollView: HorizontalCardScrollView, numberOfCards: Int) -> Int {
        return 4
    }
}

extension ViewController: HorizontalCardScrollViewDelegate {
    
    func horizontalCardScrollView(_ horizontalCardScrollView: HorizontalCardScrollView, cellForCardAt index: Int) -> UIView {
        let card = UIView()
        card.layer.cornerRadius = 10
        card.backgroundColor = .systemBlue
        return card
    }
    
}


