//
//  LoginViewModel.swift
//  ImportantTask
//
//  Created by Shorouq Alyami on 09/02/1444 AH.
//

import Foundation
import Combine
import SwiftUI

class LoginViewModel: ObservableObject {
    
    // MARK: Properties
    @Published var username: String      = ""
    @Published var password: String      = ""
    @Published var isAuthenticated: Bool = false
    @Published var errorText             = ""
    @Published var isValid               = false
    @Published var isLoading             = false
    @Published var isAlert               = false
    private var cancelable               = Set<AnyCancellable>()
    
    // MARK: - init func
    init(){
        isFormvalidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancelable)
        
        isPasswordPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map{ passStatus in
                switch passStatus{
                case .usernameEmpty:
                    return "username can not be empty!"
                case .passwordEmpty:
                    return "password can not be empty!"
                case .valid:
                    return ""
                }
            }
            .assign(to: \.errorText, on: self)
            .store(in: &cancelable)
        
    }
    
    // MARK: login func
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
                self.isLoading = false
                self.isAlert   = true
                    print(error.localizedDescription)
            }
        }
        
        PostsViewModel().getPosts()
    }
    
    
    // MARK: signout func
    func signout() {
           
           let defaults = UserDefaults.standard
           defaults.removeObject(forKey: "jsonwebtoken")
           DispatchQueue.main.async {
               self.isAuthenticated = false
           }
           
       }
    
}



extension LoginViewModel{
    
    // MARK: validate user
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


// MARK: - inlineError for TextFeilds
extension LoginViewModel{
   
    
    private var isValidUsernamePublisher: AnyPublisher<Bool, Never>{
        $username
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.count >= 3}
            .eraseToAnyPublisher()
    }
    
    private var isUsernameEmptyPublisher: AnyPublisher<Bool, Never>{
        $username
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.isEmpty}
            .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never>{
        $password
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.isEmpty}
            .eraseToAnyPublisher()
    }
    
    
    private var isPasswordPublisher: AnyPublisher<PasswordStatus, Never>{
        Publishers.CombineLatest(isPasswordEmptyPublisher, isUsernameEmptyPublisher)
            .map{
                if $0 {return PasswordStatus.passwordEmpty}
                if $1 {return PasswordStatus.usernameEmpty}
                return PasswordStatus.valid
            }
            .eraseToAnyPublisher()
    }
    
    
    private var isFormvalidPublisher: AnyPublisher<Bool, Never>{
        Publishers.CombineLatest(isPasswordEmptyPublisher, isUsernameEmptyPublisher)
            .map{ $0 && $1 }
            .eraseToAnyPublisher()
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

enum PasswordStatus{
    case usernameEmpty
    case passwordEmpty
    case valid
}
