//
//  Welcome_ViewController.swift
//  AppRaovat
//
//  Created by Ngọc Thiện on 19/08/2022.
//

import UIKit

class Welcome_ViewController: UIViewController {

    @IBOutlet weak var img_Logo: UIImageView!
    @IBOutlet weak var img_Background: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set animation for Background
        img_Background.frame.size.width = self.view.frame.size.width * 3
        img_Background.frame.size.height = self.view.frame.size.height * 3
        img_Background.frame.origin = CGPoint(x: 0, y: 0)
        img_Background.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            self.img_Background.alpha = 0.7
            self.img_Background.frame.size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        }, completion: nil)
        
        //Set animation for Logo
        img_Logo.frame.origin.x = 0 - img_Logo.frame.size.width
        UIView.animate(withDuration: 2, animations: {
            self.img_Logo.frame.origin = CGPoint(
                x: self.view.frame.size.width/2 - self.img_Logo.frame.size.width/2,
                y: self.view.frame.size.height/4 - self.img_Logo.frame.size.height/4
            )
        }, completion: nil)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
