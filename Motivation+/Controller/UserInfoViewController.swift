//
//  UserInfoViewController.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/11.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
        imageView.layer.cornerRadius = 20
        imageView.isUserInteractionEnabled = true
        editButton.layer.cornerRadius = 5
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    
    
    @IBAction func editAction(_ sender: Any) {
        print("編集されました")
    }
    
    @IBAction func pictureAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = .photoLibrary
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            self.present(cameraPicker, animated: true, completion: nil)
        }else{
            print("error")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        self.dismiss(animated: true)
    }
    
}
