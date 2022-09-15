//
//  Login_ViewController.swift
//  AppRaovat
//
//  Created by Ngọc Thiện on 23/08/2022.
//

import UIKit

class Login_ViewController: UIViewController {

    @IBOutlet weak var username_tf: UITextField!
    @IBOutlet weak var password_tf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func login_btt_tapped(_ sender: Any) {
        
        //Send Username & Password to server
        let url = URL(string: Config.ServerURL + "/login")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        var userData = "username=" + self.username_tf.text!
        userData +=  "&password=" + self.password_tf.text!

        let postData = userData.data(using: .utf8)
        request.httpBody = postData
        
        let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else { print("error"); return}
            guard let data = data else {return}
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return}
                
                if json["result"] as! Int == 1 {
                    let defaults = UserDefaults.standard
                    defaults.set(json["Token"], forKey: "UserToken")
                    DispatchQueue.main.async {
                        let alertView = UIAlertController(title: "Congratulation", message: (json["message"] as! String), preferredStyle: .alert)
                        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(ACTION:UIAlertAction!) in
                            
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let dashboard_VC = sb.instantiateViewController(withIdentifier: "DASHBOARD") as! Dashboard_ViewController
                            self.navigationController?.pushViewController(dashboard_VC, animated: false)
                            
                        }))
                        self.present(alertView, animated: true, completion: nil)
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
    }
    @IBAction func register_btt_tapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let register_VC = sb.instantiateViewController(withIdentifier: "REGISTER") as! Register_ViewController
        self.navigationController?.pushViewController(register_VC, animated: true)
    }
    
}
