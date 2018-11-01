//
//  PageVC.swift
//  AVStoryBook
//
//  Created by minami on 2018-11-01.
//  Copyright © 2018 宗像三奈美. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {
  
  private var pageCollection = [StoryVC]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = self
    
    setup()
  }
  
  fileprivate func setup() {
    let storyVC1 = storyboard?.instantiateViewController(withIdentifier: "StoryVC") as! StoryVC
    storyVC1.view.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
    pageCollection.append(storyVC1)
    
    let storyVC2 = storyboard?.instantiateViewController(withIdentifier: "StoryVC") as! StoryVC
    storyVC2.view.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    pageCollection.append(storyVC2)
    
    let storyVC3 = storyboard?.instantiateViewController(withIdentifier: "StoryVC") as! StoryVC
    storyVC3.view.backgroundColor = #colorLiteral(red: 0.972122848, green: 0.009034310468, blue: 0.9934000373, alpha: 1)
    pageCollection.append(storyVC3)
    
    let storyVC4 = storyboard?.instantiateViewController(withIdentifier: "StoryVC") as! StoryVC
    storyVC4.view.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    pageCollection.append(storyVC4)
    
    let storyVC5 = storyboard?.instantiateViewController(withIdentifier: "StoryVC") as! StoryVC
    storyVC5.view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    pageCollection.append(storyVC5)
    
    setViewControllers([storyVC1], direction: .forward, animated: true, completion: nil)
  }
  
}

extension PageVC: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    // return the VC that should be placed before my "current" VC.
    guard let index = pageCollection.firstIndex(of: viewController as! StoryVC) else { return nil }
    let beforeIndex = index - 1
    if beforeIndex < 0 {
      return nil
    }
    return pageCollection[beforeIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    // return the VC that should be placed after my "current" VC.
    guard let index = pageCollection.firstIndex(of: viewController as! StoryVC) else { return nil }
    let afterIndex = index + 1
    if afterIndex >= pageCollection.count {
      return nil
    }
    return pageCollection[afterIndex]
  }
  
  
}
