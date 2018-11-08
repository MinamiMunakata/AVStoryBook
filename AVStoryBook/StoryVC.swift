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
import AVFoundation
import CoreData

protocol AddStoryVCDelegate: class {
  func addStoryVC()
}

class StoryVC: UIViewController {
  @IBOutlet weak var addButton: UIBarButtonItem!
  @IBOutlet weak var storyImageView: UIImageView!
  
  @IBOutlet weak var recordButton: UIBarButtonItem!
  @IBOutlet weak var cameraButton: UIBarButtonItem! //{
//    didSet {
//      cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
//    }
//  }
  
  
  var audioRecorder: AVAudioRecorder?
  var audioPlayer: AVAudioPlayer?
  weak var delegate: AddStoryVCDelegate?
  
  var page: Page? {
    didSet {
      if let image = page?.image {
        self.storyImageView.image = UIImage(data: Data(referencing: image))
      }
      if let audio = page?.audio {
        try? audioPlayer = AVAudioPlayer(data: audio as Data)
      }
    }
  }
  
  lazy var filePathURL: URL = {
    // 1. file path + file name (uniqueRandomStringProcess_story.caf) caf = core audio file
    let fileManager = FileManager.default
    // home directory (only the user who download it can access
    let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let fileName = String(format: "%@_%@", ProcessInfo().globallyUniqueString, "story.caf")
    // full path url: dir/dir/filename
    let soundFileURL = dirPaths[0].appendingPathComponent(fileName)
    
    return soundFileURL
  }()
  
  private func save(withAudio audio: Data?, image: Data?) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Page", in: managedContext)!
    let newPage = NSManagedObject(entity: entity, insertInto: managedContext)
    newPage.setValue(audio as NSData?, forKeyPath: "audio")
    newPage.setValue(image as NSData?, forKeyPath: "image")
    
    do {
      try managedContext.save()
      page = newPage as? Page
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // 2. configure record settings
    let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                          AVEncoderBitRateKey: 16,
                          AVNumberOfChannelsKey: 2,
                          AVSampleRateKey: 44100.0] as [String: Any]
    // 3. create a recorder object, prepareToRecord
    do {
      try audioRecorder = AVAudioRecorder(url: filePathURL, settings: recordSettings as [String: AnyObject])
      audioRecorder?.prepareToRecord()
      audioRecorder?.delegate = self
    } catch let error as NSError {
      print("audioRecorder error: \(error.localizedDescription)")
    }
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // 4. create an AudioSession and set the Category
    let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(.playAndRecord, mode: .default, policy: .default, options: .defaultToSpeaker)
      try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    } catch let error as NSError {
      print("audioSession error: \(error.localizedDescription)")
    }
    
  }
  @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
    delegate?.addStoryVC()
  }
  
  @IBAction func recordButtonTapped(_ sender: UIBarButtonItem) {
    //
    if audioPlayer?.isPlaying == true {
      audioPlayer?.stop()
    }
    if audioRecorder?.isRecording == false {
      storyImageView.isUserInteractionEnabled = false
      audioRecorder?.record()
      recordButton.title = "🎙"
    } else {
      audioRecorder?.stop()
      recordButton.title = "🔴"
      storyImageView.isUserInteractionEnabled = true
    }
  }
  
  @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
    if audioRecorder?.isRecording == false {
      print("image is tapped!")
      do {
        if let page = page {
          try audioPlayer = AVAudioPlayer(data: page.audio! as Data)
        } else {
          try audioPlayer = AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
        }
        recordButton.isEnabled = false
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        audioPlayer?.delegate = self
        recordButton.isEnabled = true // delegate
      } catch let error as NSError {
        print("audioPlayer error: \(error.localizedDescription)")
      }
    } else {
      audioPlayer?.stop()
    }
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

extension StoryVC: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    recordButton.isEnabled = true
  }
  
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    print("audioRecorder Did Finish Recording")
    var audioTrack: Data?
    do {
      audioTrack = try Data(contentsOf: recorder.url)
    } catch let error as NSError {
      print("audioTrack error: \(error.localizedDescription)")
    }
    save(withAudio: audioTrack, image: storyImageView.image?.pngData())
  }
  
  func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
    print("audioRecorder Encode Error Did Occur")
    
    
  }
  
  func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    print("audioPlayer Decode Error Did Occur")
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
