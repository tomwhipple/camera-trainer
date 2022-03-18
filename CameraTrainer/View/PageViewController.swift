//
//  PageViewController.swift
//  Landmarks
//
//  Created by Tom Whipple on 2/23/22.
//

import SwiftUI
import UIKit
import Foundation
import Combine

struct PageViewController: UIViewControllerRepresentable {
    var currentPageIndex: Int = 0

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        guard currentPageIndex < context.coordinator.manager.uncategorized.count else {
            return
        }
        
        let currentVC = UIHostingController(rootView: LabelingView(index: currentPageIndex, event: context.coordinator.manager.uncategorized[currentPageIndex]))
        
        pageViewController.setViewControllers([currentVC], direction: .forward, animated: true)
        
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        @ObservedObject var manager: DataManager
        
        init(_ pageViewController: PageViewController) {
            parent = pageViewController
            manager = DataManager.shared
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            return nil
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            
            guard let vc = viewController as? UIHostingController<LabelingView> else {
                return nil
            }
            
            let nextIndex = vc.rootView.index + 1
            guard nextIndex < DataManager.shared.uncategorized.count else {
                return nil
            }
            
            return UIHostingController(rootView: LabelingView(index: nextIndex, event: DataManager.shared.uncategorized[nextIndex]))
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first as? UIHostingController<LabelingView> {
                parent.currentPageIndex = visibleViewController.rootView.index
            }
        }
    }
}
