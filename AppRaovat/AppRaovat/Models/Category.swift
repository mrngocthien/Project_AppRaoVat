//
//  Category.swift
//  AppRaovat
//
//  Created by Ngọc Thiện on 07/09/2022.
//

import Foundation

struct CategoryPostRoute:Decodable {
    var result:Int
    var CateList:[Category]
}

struct Category:Decodable {
    var _id: String
    var name: String
    var image: String
    
    init(id: String, name: String, image:String) {
        self._id = id
        self.name = name
        self.image = image
    }
}
