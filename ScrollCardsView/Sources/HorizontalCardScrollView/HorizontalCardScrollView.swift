// HorizontalCardScrollView.swift
// ScrollCardsView , 
// Created by Doston Rustamov 17/07/22.
// Copyright 2022 Doston Rustamov . All rights reserved.

import UIKit

public protocol HorizontalCardScrollViewDataSource: AnyObject {
    func horizontalCardScrollView(_ horizontalCardScrollView: HorizontalCardScrollView, numberOfCards: Int) -> Int
}

public protocol HorizontalCardScrollViewDelegate: AnyObject {
    func horizontalCardScrollView(_ horizontalCardScrollView: HorizontalCardScrollView, cellForCardAt index: Int) -> UIView
}


@available(iOS 2.0, *)
@MainActor final public class HorizontalCardScrollView: UIScrollView, UIScrollViewDelegate {
    
    /// Errors that will be thrown if user does not provide
    /// required information, such as number of cells or cellView
    /// to work with `HorizontalCardScrollView`
    enum Errors: Error {
        case invalidNumberOfCells
        case emptyDelegate
    }
    
    
    /// Offset value around two items
    private var offset: CGFloat!
    
    private var numberOfCells: Int!
    
    /// `HorizontalCardScrollViewDataSource` defines dataSource for `HorizontalCardScrollView`
    ///  For more details refer to `HorizontalCardScrollViewDataSource` protocol
    weak var dataSource: HorizontalCardScrollViewDataSource? {
        didSet {
            _ = try? setupSubviews()
        }
    }
    
    
    weak var cardsDelegate: HorizontalCardScrollViewDelegate? {
        didSet {
            _ = try? setupSubviews()
        }
    }
    
    
    /// Initialization with default parametres to work with `HorizontalCardScrollView`
    init(frame: CGRect, offset: CGFloat) {
        let offsetFrame = CGRect(
            x: frame.origin.x + offset,
            y: frame.origin.y,
            width: frame.width - (offset * 2),
            height: frame.height)
        super.init(frame: offsetFrame)
        
        self.delegate = self
        self.offset = offset
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.clipsToBounds = false
    }
    
    required init?(coder: NSCoder) {
        #if DEBUG
        fatalError("init(coder:) has not been implemented")
        #endif
    }
    
    /// Function that will call delegate function to subviews
    private func setupSubviews() throws -> String {
        guard let numberOfCells = dataSource?.horizontalCardScrollView(self, numberOfCards: 0) else {
            throw HorizontalCardScrollView.Errors.invalidNumberOfCells
        }
        self.numberOfCells = numberOfCells
        
        guard let delegate = cardsDelegate else { throw HorizontalCardScrollView.Errors.emptyDelegate }
    
        let viewWidth = self.frame.size.width - 2 * offset
        let viewHeight = self.frame.size.height
        
        var currentOffset: CGFloat = 0
        
        for cellNumber in 0..<numberOfCells {
            let cell: UIView = delegate.horizontalCardScrollView(self, cellForCardAt: cellNumber)
            cell.frame = CGRect(x: currentOffset + offset, y: 0, width: viewWidth, height: viewHeight)
            
            self.addSubview(cell)
            
            currentOffset = cell.frame.origin.x + viewWidth + offset
        }
        
        self.contentSize = CGSize(width: currentOffset, height: self.frame.height)
        
        self.currentOffset = frame.width
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(startAnimation), userInfo: nil, repeats: true)
        
        return "Success"
    }
    
    
    /// Animation properties and functions
    private var currentOffset: CGFloat = 0
    
    @objc
    private func startAnimation() {
        self.setContentOffset(CGPoint(x: currentOffset, y: 0), animated: true)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.setOffset(with: scrollView.contentOffset.x)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.setOffset(with: scrollView.contentOffset.x)
    }
    
    
    func setOffset(with x: CGFloat) {
        currentOffset = x
        currentOffset = currentOffset == (CGFloat(numberOfCells - 1) * self.frame.width) ? 0 : (currentOffset + self.frame.width)
    }
}
