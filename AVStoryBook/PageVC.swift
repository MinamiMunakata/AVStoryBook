//
//  PageVC.swift
//  AVStoryBook
//
//  Created by minami on 2018-11-01.
//  Copyright © 2018 宗像三奈美. All rights reserved.
//

import UIKit
import CoreData

class PageVC: UIPageViewController {
  
  private let appDelegate = UIApplication.shared.delegate
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  private var pages = [Page]()
  private var pageCollection = [StoryVC]()
  
  /**
   Access Levels
   When you make an app
   private - private to the class
   internal - default
   fileprivate - same file
   
   When you make a library
   public - same module, nosubclass
   open anywhere, can subclass
   */
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = self
    
    let request: NSFetchRequest<Page> = Page.fetchRequest()
    do {
      pages = try context.fetch(request)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    if pages.count == 0 {
      let storyVC = storyboard?.instantiateViewController(withIdentifier: "StoryVC") as! StoryVC
      storyVC.view.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
      storyVC.delegate = self
      pageCollection.append(storyVC)
    } else {
      setup()
    }
    setViewControllers([pageCollection[0]], direction: .forward, animated: true, completion: nil)
  }
  
  fileprivate func setup() {
    if pages.count > 0 {
      for i in 0..<pages.count {
        let storyVC = storyboard?.instantiateViewController(withIdentifier: "StoryVC") as! StoryVC
        storyVC.view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        storyVC.delegate = self
        storyVC.page = pages[i]
        pageCollection.append(storyVC)
      }
    }
  }
  
//  fileprivate func setupVCs() {
//    let storyVC1 = storyboard?.instantiateViewController(withIdentifier: "StoryVC") as! StoryVC
//    storyVC1.view.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
//    pageCollection.append(storyVC1)
//
//    let storyVC2 = storyboard?.instantiateViewController(withIdentifier: "StoryVC") as! StoryVC
//    storyVC2.view.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
//    pageCollection.append(storyVC2)
//
//    let storyVC3 = storyboard?.instantiateViewController(withIdentifier: "StoryVC") as! StoryVC
//    storyVC3.view.backgroundColor = #colorLiteral(red: 0.972122848, green: 0.009034310468, blue: 0.9934000373, alpha: 1)
//    pageCollection.append(storyVC3)
//
//    let storyVC4 = storyboard?.instantiateViewController(withIdentifier: "StoryVC") as! StoryVC
//    storyVC4.view.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
//    pageCollection.append(storyVC4)
//
//    let storyVC5 = storyboard?.instantiateViewController(withIdentifier: "StoryVC") as! StoryVC
//    storyVC5.view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
//    pageCollection.append(storyVC5)
//
//    setViewControllers([storyVC1], direction: .forward, animated: true, completion: nil)
//  }
  
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

extension PageVC: AddStoryVCDelegate {
  func addStoryVC() {
    let storyVC = storyboard?.instantiateViewController(withIdentifier: "StoryVC") as! StoryVC
    storyVC.view.backgroundColor = #colorLiteral(red: 0.972122848, green: 0.009034310468, blue: 0.9934000373, alpha: 1)
    storyVC.delegate = self
    pageCollection.append(storyVC)
  }
}
