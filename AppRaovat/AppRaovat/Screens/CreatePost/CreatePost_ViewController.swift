//
//  CreatePost_ViewController.swift
//  AppRaovat
//
//  Created by Ngọc Thiện on 06/09/2022.
//

import UIKit

extension CreatePost_ViewController: Category_Delegate {
    func categoryPicker(idCategory: String, nameCategory: String) {
        self.navigationController?.popViewController(animated: true)
        lbl_category.text = nameCategory
        idCategory_Update = idCategory
    }
}

extension CreatePost_ViewController: City_Delegate {
    func cityPicker(idCity: String, nameCity: String) {
        self.navigationController?.popViewController(animated: true)
        lbl_city.text = nameCity
        idCity_Update = idCity
    }
}

class CreatePost_ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var img_product: UIImageView!
    @IBOutlet weak var lbl_category: UILabel!
    @IBOutlet weak var lbl_city: UILabel!
    @IBOutlet weak var tf_productName: UITextField!
    @IBOutlet weak var tf_productPrice: UITextField!
    @IBOutlet weak var tf_contact: UITextField!
    
    var idCategory_Update: String?
    var idCity_Update: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func img_tapped(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            img_product.image = image
            self.dismiss(animated: true, completion: nil)
        } else {}
            
    }
    
    @IBAction func category_tapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let category_createPost_VC = sb.instantiateViewController(withIdentifier: "CATEGORY_CREATE_POST") as! Category_CreatePost_ViewController
        category_createPost_VC.delegate = self
        self.navigationController?.pushViewController(category_createPost_VC, animated: true)
    }
    
    @IBAction func city_tapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let city_createPost_VC = sb.instantiateViewController(withIdentifier: "CITY_CREATE_POST") as! City_CreatePost_ViewController
        city_createPost_VC.delegate = self
        self.navigationController?.pushViewController(city_createPost_VC, animated: true)
    }
    
    
    @IBAction func createPost_butt_tapped(_ sender: Any) {
        if img_product.image == nil || tf_productName.text == nil || tf_productPrice.text == nil || tf_contact.text == nil {
            let alertView = UIAlertController(title: "Warning", message: "Missing parameters", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertView, animated: true)
        } else {
            //Upload Product Image
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
            data.append((img_product.image?.pngData())!)
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            //Upload Post data
            session.uploadTask(with: urlRequest, from: data, completionHandler: { [self] responseData, response, error in
                if error == nil {
                    let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .fragmentsAllowed)
                    if let json = jsonData as? [String: Any] {
                        if json["result"] as! Int == 1 {
                            let urlFile = json["urlFile"] as? [String: Any]
                            DispatchQueue.main.async {
                                url = URL(string: Config.ServerURL + "/post/add")
                                var request = URLRequest(url: url!)
                                request.httpMethod = "POST"
                                
                                let fileName = urlFile!["filename"] as! String
                                var userData = "Post_Image=" + fileName
                                userData += "&Post_Category=" + self.idCategory_Update!
                                userData +=  "&Post_City=" +  self.idCity_Update!
                                userData += "&Post_ProductName=" + self.tf_productName.text!
                                userData += "&Post_Price=" + self.tf_productPrice.text!
                                userData += "&Post_Contact=" + self.tf_contact.text!
                                
        
                                let postData = userData.data(using: .utf8)
                                request.httpBody = postData
                                
                                let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                                    guard error == nil else { print("error"); return}
                                    guard let data = data else {return}
                                    
                                    do {
                                        guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return}
                                        
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
                            print("Create Post failed !")
                        }
                    }
                }
            })
            .resume()
        }
        }
        
    
    

}


