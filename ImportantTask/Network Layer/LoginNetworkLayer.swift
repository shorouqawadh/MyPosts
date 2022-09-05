//
//  LoginNetworkLayer.swift
//  ImportantTask
//
//  Created by Shorouq Alyami on 09/02/1444 AH.
//

import Foundation



struct LoginResponse: Codable {
    let token: String?
    let message: String?
    let success: Bool?
}

class NetworkLayer {
        
    func getPosts(token: String, completion: @escaping (Result<[Post], NetworkErrors>) -> Void) {
        
        guard let url = URL(string: "https://furry-organic-ambulance.glitch.me/posts") else {
            completion(.failure(.incorrectURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(.noData))
                return
            }
            
            guard let posts = try? JSONDecoder().decode([Post].self, from: data) else {
                completion(.failure(.decodingFaild))
                return
            }
            
            completion(.success(posts))
            
            
            
        }.resume()
        
        
    }
    
    
    func login(username: String, password: String, completion: @escaping (Result<String, AuthenticationErrors>) -> Void) {
        
        guard let url = URL(string: "https://strong-spangled-apartment.glitch.me/login") else {
            completion(.failure(.custom(errorMessage: "URL is not correct")))
            return
        }
        
        let body = User(username: username, password: password)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(.custom(errorMessage: "No data")))
                return
            }
            
            try! JSONDecoder().decode(LoginResponse.self, from: data)
            
            guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                completion(.failure(.invalidUser))
                return
            }
            
            guard let token = loginResponse.token else {
                completion(.failure(.invalidUser))
                return
            }
            
            completion(.success(token))
            
        }.resume()
        
    }
    
}


enum AuthenticationErrors: Error {
    case invalidUser
    case custom(errorMessage: String)
}

enum NetworkErrors: Error {
    case incorrectURL
    case noData
    case decodingFaild
}
