// HorizontalCardScrollViewErrors+Extension.swift
// ScrollCardsView , 
// Created by Doston Rustamov 17/07/22.
// Copyright 2022 Doston Rustamov . All rights reserved.

import Foundation

extension HorizontalCardScrollView.Errors:LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidNumberOfCells:
            return "specify number of cells"
        case .emptyDelegate:
            return "specify cardsDelegate of HorizontalCardScrollView"
        }
    }
}
