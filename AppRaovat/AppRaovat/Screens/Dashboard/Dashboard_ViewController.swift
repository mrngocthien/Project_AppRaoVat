//
//  Dashboard_ViewController.swift
//  AppRaovat
//
//  Created by Ngọc Thiện on 19/08/2022.
//

import UIKit

class Dashboard_ViewController: UIViewController {

    @IBOutlet weak var img_Avatar: UIImageView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img_Avatar.layer.cornerRadius = img_Avatar.frame.size.width/2
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Check log in
        if let UserToken = defaults.string(forKey: "UserToken") {
            
            //Verify token
            let url = URL(string: Config.ServerURL + "/verifyToken")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            
         
            let userData = "Token=" + UserToken
            
            let postData = userData.data(using: .utf8)
            request.httpBody = postData
            
            let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil else { print("error"); return}
                guard let data = data else {return}
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return}                    
                    if json["result"] as! Int == 1 {
                        let user = json["User"] as? [String: Any]
                        let imgString = user!["avatar"] as? String
                        let urlAvatar = Config.ServerURL + "/upload/" + imgString!
                        DispatchQueue.main.async { [self] in
                            do {
                                let imgData = try! Data(contentsOf: URL(string: urlAvatar)!)
                                self.img_Avatar.image = UIImage(data: imgData)
                            }
                            self.lbl_UserName.text = user!["username"] as? String
                            self.lbl_Email.text = user!["email"] as? String
                        }
                        DispatchQueue.main.async {
                            let alertView = UIAlertController(title: "Congratulation", message: (json["message"] as! String), preferredStyle: .alert)
                            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alertView, animated: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                               
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let login_VC = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
                            self.navigationController?.pushViewController(login_VC, animated: false)
                        }
                    }
                } catch let error {print(error.localizedDescription)}
            })
            taskUserRegister.resume()
        
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let login_VC = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
            self.navigationController?.pushViewController(login_VC, animated: false)
        }
        
    }

    @IBAction func butt_LogOut_tapped(_ sender: Any) {
        if let UserToken = defaults.string(forKey: "UserToken") {
            //Send Username & Password to server
            let url = URL(string: Config.ServerURL + "/logout")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            let userData = "Token=" + UserToken

            let postData = userData.data(using: .utf8)
            request.httpBody = postData
            
            let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil else { print("error"); return}
                guard let data = data else {return}
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return}
                    
                    if json["result"] as! Int == 1 {
                        self.defaults.removeObject(forKey: "UserToken")
                        DispatchQueue.main.async {
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let login_VC = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
                            self.navigationController?.pushViewController(login_VC, animated: false)
                        }
                } else {
                        DispatchQueue.main.async {
                            let alertView = UIAlertController(title: "Warning", message: (json["message"] as! String), preferredStyle: .alert)
                            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alertView, animated: true, completion: nil)
                        }
                    }
                } catch let error {print(error.localizedDescription)}
            })
            taskUserRegister.resume()
        } else {
            
        }
        
    }
    
}
