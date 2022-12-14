//
//  notesPopup.swift
//  Garage
//
//  Created by Amjad on 29/02/1440 AH.
//  Copyright © 1440 Amjad Ali. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

struct DataNotes {
    static var comment = String()
    static var images = [String]()
    static var Object = [String]()
}


class notesPopup: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate,NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var Image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var notesComt: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var statusbtn: UIButton!
    
    let dateFormatter : DateFormatter = DateFormatter()
    
    var flag = 0
    var image: UIImage!
    var images = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesComt.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        notesComt.text = Constants.comment
        notesComt.textColor = UIColor.lightGray
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE dd LLL yyyy"
        let nameOfMonth = dateFormatter.string(from: now)
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        let todaytime = timeFormatter.string(from:time)
        dateLabel.text = nameOfMonth
        timelbl.text = todaytime
        DataNotes.comment.removeAll()
        DataNotes.images.removeAll()
    }
    var fourUniqueDigits: String {
        var result = ""
        repeat {
            // create a string with up to 7 leading zeros with a random number 0...9999999
            result = String(format:"%07d", arc4random_uniform(10000000) )
            // generate another random number if the set of characters count is less than four
        } while Set<Character>(result).count < 7
        return result    // ran 8 times
    }
   
    
    
    func textViewDidBeginEditing(_ notesComt: UITextView) {
        if notesComt.textColor == UIColor.lightGray {
            notesComt.text = nil
            notesComt.textColor = UIColor.black
        }
    }
    
    
    func textViewDidEndEditing(_ notesComt: UITextView) {
        if notesComt.text.isEmpty {
            notesComt.text = "Write Note"
            notesComt.textColor = UIColor.lightGray
        }
    }
    
    
    
    @IBAction func PhotoaddBtn(_ sender: Any) {
        
        openCamera()
        
    }
    
    
    @IBAction func SaveButton(_ sender: Any) {
        
        
        print(DataNotes.Object)
        
        if notesComt.text == "Write Note" {
            notesComt.text = ""
            DataNotes.comment = notesComt.text
            DataNotes.images = images
        }
        DataNotes.comment = notesComt.text
        DataNotes.images = images
        
        // SaveDataApi()
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func statusbtn(_ sender: Any) {
        if statusbtn.titleLabel?.text == "Checked" {
            statusbtn.setTitle("Unchecked", for: .normal)
        }
        else if statusbtn.titleLabel?.text == "Unchecked" {
            statusbtn.setTitle("Checked", for: .normal)
        }
    }
    
    
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self// as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if flag == 0 {
                self.Image1.image = pickedImage
                flag = 1
            }
            else if flag == 1 {
                self.image2.image = pickedImage
                flag = 2
            }
            else if flag == 2 {
                self.image3.image = pickedImage
                flag = 0
            }
            image = pickedImage
            upload()
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func upload() {
    
        Alamofire.upload(multipartFormData:
            
            {
                (multipartFormData) in
                multipartFormData.append(self.image.jpegData(compressionQuality: 0.1)!, withName: "image", fileName: "\(self.fourUniqueDigits).jpg", mimeType: "image/jpeg")
                
        }, to: "\(CallEngine.baseURL)\(CallEngine.notesImguploadapi)",headers:nil)
        { (result) in
            
            switch result {
                
            case .success(let upload,_,_ ):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON
                    
                    { response in
                       self.startAnimating(message: Constants.wait, messageFont: UIFont(name:"SFProDisplay-Bold", size: 18.0), type: .ballPulse, color: UIColor.DefaultApp)
                        if let dict = response.result.value as? NSObject {
                            DispatchQueue.main.async {
                                
                                let Status = dict.value(forKey: "Status") as! Int
                                let message = dict.value(forKey: "Description") as! String
                                if Status == 1 {
                                  print(dict)
                                    if let imagekey = dict.value(forKey: "Image") as? String
                                    {
                                        print(imagekey)
                                        self.images.append(imagekey)
                                    }
                                    self.stopAnimating()
                                } else if Status == 0 {
                                    ToastView.show(message: message, controller: self)
                                    self.stopAnimating()
                                }
                                
                            }//)
                        }
                }
            case .failure( _):
                self.stopAnimating()
                break
                
            }
            
        }
        
        
    }
    
    
    
}
