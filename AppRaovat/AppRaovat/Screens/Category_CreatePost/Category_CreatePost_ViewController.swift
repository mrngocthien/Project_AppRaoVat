//
//  Category_CreatePost_ViewController.swift
//  AppRaovat
//
//  Created by Ngọc Thiện on 07/09/2022.
//

import UIKit

protocol Category_Delegate {
    func categoryPicker(idCategory: String, nameCategory: String)
}

class Category_CreatePost_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var delegate: Category_Delegate?
    
    @IBOutlet weak var myTable_Cate: UITableView!
    
    var arr_Cate:[Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable_Cate.dataSource = self
        myTable_Cate.delegate = self

        //Load Cate list from server
        let url = URL(string: Config.ServerURL + "/category")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else { print("error"); return}
            guard let data = data else {return}
            
            let jsonDecoder = JSONDecoder()
            let listCate = try? jsonDecoder.decode(CategoryPostRoute.self, from: data)
            self.arr_Cate = listCate!.CateList
            
            DispatchQueue.main.async {
                self.myTable_Cate.reloadData()
            }
        })
        taskUserRegister.resume()
    }
    
    //Set number of table view row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_Cate.count
    }
    
    //Pass data from arr_Cate to table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Pass name of Category
        let cateCell = myTable_Cate.dequeueReusableCell(withIdentifier: "CATE_CELL") as! Cate_CreatePost_TableViewCell
        cateCell.lbl_CateName.text = arr_Cate[indexPath.row].name
        
        //Pass Image of Category
        let queueLoadCateImg = DispatchQueue(label: "queueLoadCateImg")
        queueLoadCateImg.async {
            let urlCateImg = URL(string: Config.ServerURL + "/upload/" + self.arr_Cate[indexPath.row].image)
            do {
                let dataCateImg = try Data(contentsOf: urlCateImg!)
                DispatchQueue.main.async {
                    cateCell.img_Cate.image = UIImage(data: dataCateImg)
                }
            }
            catch {}
        }
        return cateCell
    }
    
    //Set height of Category Image
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height/4
    }
    
    //Capture value of Category user picked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.categoryPicker(idCategory: arr_Cate[indexPath.row]._id, nameCategory: arr_Cate[indexPath.row].name)
    }
    
}
