//
//  SimultaneouslyScrollViewHandler.swift
//  Semester Tracker SwiftUI
//
//  Created by Anesa Fazlagić on 4. 4. 2023..
//

import Foundation
import UIKit

class SimultaneouslyScrollViewHandler: NSObject, ObservableObject {
    @Published private var scrollViews: [UIScrollView] = []
    private var scrollingScrollView: UIScrollView?
  
    func register(scrollView: UIScrollView) {
        guard !scrollViews.contains(scrollView) else {
            return
        }

        scrollView.delegate = self
        scrollViews.append(scrollView)
    
        // Scroll the new `ScrollView` to the current position of
        // the others.
        // Using the first `ScrollView` should be enough as all
        // should be synchronized at this point already.
        guard let currentContentOffset = scrollViews
                                             .first?
                                             .contentOffset else {
            return
        }
        scrollView.setContentOffset(
            currentContentOffset,
            animated: false
        )
    }
}

extension SimultaneouslyScrollViewHandler: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollingScrollView = scrollView
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollingScrollView == scrollView else {
            return
        }

        scrollViews
            .filter { $0 != scrollingScrollView }
            .forEach {
                $0.setContentOffset(
                    scrollView.contentOffset,
                    animated: false
                )
            }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollingScrollView = nil
    }
}
