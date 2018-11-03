//
//  ViewController.swift
//  AVStoryBook
//
//  Created by minami on 2018-11-01.
//  Copyright © 2018 宗像三奈美. All rights reserved.
//

import UIKit
import CoreServices
import MobileCoreServices

class StoryVC: UIViewController {
  @IBOutlet weak var storyImageView: UIImageView!
  
  @IBOutlet weak var cameraButton: UIBarButtonItem! //{
//    didSet {
//      cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
//    }
//  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // ActionSheet ->
  }
  
  fileprivate func openCamera(_ picker: UIImagePickerController) {
    // 2. setup variables (configuration)
    picker.sourceType = .camera
    picker.mediaTypes = [kUTTypeImage as String]
    picker.allowsEditing = true
    // 3. to get the photo taken, we need to set the delegate of the picker to self
    picker.delegate = self
    // 4. present the picker
    present(picker, animated: true, completion: nil)
  }
  
  fileprivate func openLibrary(_ picker: UIImagePickerController) {
    // 2. setup variables (configuration)
    picker.sourceType = .photoLibrary
    picker.mediaTypes = [kUTTypeImage as String]
    picker.allowsEditing = true
    // 3. to get the photo taken, we need to set the delegate of the picker to self
    picker.delegate = self
    // 4. present the picker
    present(picker, animated: true, completion: nil)
  }
  
  @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
    // 1. create an instance of UIImagePickerController
    let picker = UIImagePickerController()
    
    let alert: UIAlertController = UIAlertController(title: "Choose a photo", message: "from...", preferredStyle: .actionSheet)
    let openCameraAction: UIAlertAction = UIAlertAction(title: "Open Camera", style: .default) { (action) in
      self.openCamera(picker)
    }
    let openLibraryAction: UIAlertAction = UIAlertAction(title: "Open Library", style: .default) { (action) in
      self.openLibrary(picker)
    }
    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
      alert.dismiss(animated: true, completion: nil)
    }
    
    alert.addAction(openCameraAction)
    alert.addAction(openLibraryAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
    
  }
  
  
}

extension StoryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // 1. get the photo
    if let photo = (info[.editedImage] ?? info[.originalImage]) as? UIImage {
      // 2. display in UIImageView
      storyImageView.image = photo
    }
    // 3. dismiss the picker
    picker.dismiss(animated: true, completion: nil)
  }
}
