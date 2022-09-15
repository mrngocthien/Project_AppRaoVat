//
//  Register_ViewController.swift
//  AppRaovat
//
//  Created by Ngọc Thiện on 13/08/2022.
//

import UIKit

class Register_ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var username_tf: UITextField!
    @IBOutlet weak var password_tf: UITextField!
    @IBOutlet weak var fullName_tf: UITextField!
    @IBOutlet weak var email_tf: UITextField!
    @IBOutlet weak var address_tf: UITextField!
    @IBOutlet weak var phone_tf: UITextField!
    
    @IBOutlet weak var avatar_img: UIImageView!
    
    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mySpinner.isHidden = true
    }
    
    //Function to show photo gallery where user can choose image
    @IBAction func ChoosePicture_tapped(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    //Function to show image was selected in register page
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            avatar_img.image = image
            self.dismiss(animated: true, completion: nil)
        } else {}
            
    }
    
    @IBAction func loginButton(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let login_VC = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
        self.navigationController?.pushViewController(login_VC, animated: false)
    }
    
    
    //Function to upload data to server
    @IBAction func register_btt(_ sender: Any) {
        
        //Create indicator animation for delay internet
        mySpinner.isHidden = false
        mySpinner.startAnimating()
        
        //Upload avatar
        var url = URL(string: Config.ServerURL + "/uploadFile")
        let boundary = UUID().uuidString
        let session = URLSession.shared
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"hinhdaidien\"; filename=\"avatar.png\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append((avatar_img.image?.pngData())!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        //Upload user data
        session.uploadTask(with: urlRequest, from: data, completionHandler: { [self] responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .fragmentsAllowed)
                if let json = jsonData as? [String: Any] {
                    if json["result"] as! Int == 1 {
                        let urlFile = json["urlFile"] as? [String: Any]
                        DispatchQueue.main.async {
                            url = URL(string: Config.ServerURL + "/register")
                            var request = URLRequest(url: url!)
                            request.httpMethod = "POST"
                            
                            let fileName = urlFile!["filename"] as! String
                            var userData = "username=" + self.username_tf.text!
                            userData +=  "&password=" + self.password_tf.text!
                            userData += "&fullname=" + self.fullName_tf.text!
                            userData += "&avatar=" + fileName
                            userData += "&email=" + self.email_tf.text!
                            userData += "&address=" + self.address_tf.text!
                            userData += "&phoneNumber=" + self.phone_tf.text!
    
                            let postData = userData.data(using: .utf8)
                            request.httpBody = postData
                            
                            let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                                guard error == nil else { print("error"); return}
                                guard let data = data else {return}
                                
                                do {
                                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return}
                                    
                                    DispatchQueue.main.async {
                                        self.mySpinner.isHidden = true
                                    }
                                    
                                    if json["result"] as! Int == 1 {
                                        DispatchQueue.main.async {
                                            let alertView = UIAlertController(title: "Congratulation", message: (json["message"] as! String), preferredStyle: .alert)
                                            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                            self.present(alertView, animated: true)
                                        }
                                        //print(json)
                                    } else {
                                        DispatchQueue.main.async {
                                            let alertView = UIAlertController(title: "Warning", message: (json["message"] as! String), preferredStyle: .alert)
                                            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                            self.present(alertView, animated: true)
                                        }
                                    }
                                } catch let error {print(error.localizedDescription)}
                            })
                            taskUserRegister.resume()
                            
                        }
                        
                    } else {
                        print("Upload failed !")
                    }
                }
            }
        })
        .resume()
        
    }
    
}
