//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Rachel Chen on 3/21/19.
//  Copyright © 2019 rachelchen0418. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse
//UIImagePickerControllerDelegate gives you picture

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onSubmitButton(_ sender: Any) {
        
        // create schema table in database
        let post = PFObject(className: "Posts")
        
        post["caption"] = commentField.text!
        post["author"] = PFUser.current()!
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!) // ! to unwrap
        
        post["image"] = file
        
        post.saveInBackground { (success, error) in
            if success{
                self.dismiss(animated: true, completion: nil)
            } else{
                print("error!")
            }
            
        }
    }
    @IBAction func onCameraButton(_ sender: Any) {
        // needs AB fundation or other library to custom the picture
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        // need the code below or else it will crash
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        // resize image using AlamofireImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
}
