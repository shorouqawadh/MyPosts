//
//  LoginViewModel.swift
//  ImportantTask
//
//  Created by Shorouq Alyami on 09/02/1444 AH.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    var username: String = ""
    var password: String = ""
    @Published var isAuthenticated: Bool = false
    
    func login() {
        
        let defaults = UserDefaults.standard
        
        login(username: username, password: password) { result in
            switch result {
                case .success(let token):
                print(token)
                    defaults.setValue(token, forKey: "jsonwebtoken")
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                    }
                case .failure(let error):
                print("Username or Password is incorrect")
                    print(error.localizedDescription)
            }
        }
    }
    
    func signout() {
           
           let defaults = UserDefaults.standard
           defaults.removeObject(forKey: "jsonwebtoken")
           DispatchQueue.main.async {
               self.isAuthenticated = false
           }
           
       }
    
}



extension LoginViewModel{
    
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

struct LoginResponse: Codable {
    let token: String?
    let message: String?
    let success: Bool?
}


