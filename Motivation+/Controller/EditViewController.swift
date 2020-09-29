//
//  EditViewController.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/18.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SDWebImage

class EditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    var uid = String()
    let db = Firestore.firestore()
    var user = Auth.auth().currentUser
    let storage = Storage.storage()
    var ProfileImageData: Data = Data()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        imageView.layer.cornerRadius = 20
        imageView.isUserInteractionEnabled = true
        editButton.layer.cornerRadius = 5
        
        uid = user!.uid
        
        editButton.addTarget(self, action: #selector(self.pushButton_Animation(_:)), for: .touchDown)
        editButton.addTarget(self, action: #selector(self.separateButton_Animation(_:)), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        db.collection("users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataArray = document.data()
                if dataArray!["name"] == nil {
                    print("name is nil")
                }else{
                    print("name is not nil")
                    self.textField.text = dataArray!["name"] as? String
                }
              } else {
                print("Document does not exist in cache")
              }
        }
        
        downloadPicture()
    }
    
    @IBAction func editAction(_ sender: Any) {
        if textField.text == "" || textField.text == nil {
            showAlert(title: "入力して下さい")
        }else{
            
            db.collection("users").document(uid).updateData([
                "name": textField.text!
            ])
            pushData()
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        self.dismiss(animated: true)
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
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let cansel = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cansel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func pushData() {
        let storageRef = storage.reference(forURL: "gs://motivationplus-e098a.appspot.com/")
        let imageRef = storageRef.child("\(uid).jpg")
        var imageData = Data()
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        if imageView.image != nil {
            imageData = (imageView.image?.jpegData(compressionQuality: 0.01))!
        }
        
        imageRef.putData(imageData, metadata: meta) {(metaData, error) in
            self.dismiss(animated: true, completion: nil)
            if error != nil {
                print(error!)
                return
            }
        }
    }
    
    func downloadPicture() {
        print("download start")
        let storageRef = storage.reference(forURL: "gs://motivationplus-e098a.appspot.com/")
        let imageRef = storageRef.child("\(uid).jpg")
        imageRef.downloadURL { (url, error) in
            if url != nil {
                let imageUrl:URL = url!
                print("set start")
                print("\(String(describing: url))")
                self.imageView.sd_setImage(with: imageUrl)
                print("set finish")
            }else{
                self.imageView.image = UIImage(named:"IMG_0509" )
            }
        }
        print("download finish")
    }
    
    
    @objc func pushButton_Animation(_ sender: UIButton){
        UIView.animate(withDuration: 0.1, animations:{ () -> Void in
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }
        
        
    @objc func separateButton_Animation(_ sender: UIButton){
        UIView.animate(withDuration: 0.2, animations:{ () -> Void in
             sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
             sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
}
