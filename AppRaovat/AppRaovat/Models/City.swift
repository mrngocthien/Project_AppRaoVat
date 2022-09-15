//
//  City.swift
//  AppRaovat
//
//  Created by Ngọc Thiện on 07/09/2022.
//

import Foundation
struct CityPostRoute:Decodable {
    var result:Int
    var list:[City]
}

struct City:Decodable {
    var _id: String
    var name: String
    
    init(id: String, name: String) {
        self._id = id
        self.name = name
    }
}
