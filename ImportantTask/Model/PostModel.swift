//
//  PosttModel.swift
//  ImportantTask
//
//  Created by Shorouq Alyami on 09/02/1444 AH.
//

import Foundation

struct Post: Decodable {
    let day: String
    let body: String
}

struct PostModel:Identifiable, Codable {
    var id: Int
    let day: String
    let body: String
}
