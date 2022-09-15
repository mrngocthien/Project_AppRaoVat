//
//  City_CreatePost_ViewController.swift
//  AppRaovat
//
//  Created by Ngọc Thiện on 07/09/2022.
//

import UIKit

protocol City_Delegate {
    func cityPicker(idCity: String, nameCity: String)
}

class City_CreatePost_ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var myTable_City: UITableView!
    
    var arr_City: [City] = []
    var delegate: City_Delegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable_City.dataSource = self
        myTable_City.delegate = self

        //Load Cate list from server
        let url = URL(string: Config.ServerURL + "/city")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else { print("error"); return}
            guard let data = data else {return}
            
            let jsonDecoder = JSONDecoder()
            let listCate = try? jsonDecoder.decode(CityPostRoute.self, from: data)
            self.arr_City = listCate!.list
            
            DispatchQueue.main.async {
                self.myTable_City.reloadData()
            }
        })
        taskUserRegister.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_City.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cityCell = myTable_City.dequeueReusableCell(withIdentifier: "CITY_CELL")
        cityCell?.textLabel?.text = arr_City[indexPath.row].name
        return cityCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.cityPicker(idCity: arr_City[indexPath.row]._id, nameCity: arr_City[indexPath.row].name)
    }
}
