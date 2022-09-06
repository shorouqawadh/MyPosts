//
//  PostViewModel.swift
//  ImportantTask
//
//  Created by Shorouq Alyami on 09/02/1444 AH.
//

import Foundation
import Combine

class PostsViewModel: ObservableObject {
    //
    @Published var posts: [PostViewModel] = []
    var cacelables = Set<AnyCancellable>()
    
    // MARK: - Feach posts
    func getPosts() {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "jsonwebtoken") else {
            return
        }

        getPosts(token: token) { (result) in
            switch result {
                case .success(let posts):
                print(result)
                    DispatchQueue.main.async {
                        self.posts = posts.map(PostViewModel.init)
                    }
                case .failure(let error):
                print("FEATCHING FAILD")
                    print(error.localizedDescription)
            }
        }
    }
}


extension PostsViewModel{
    
    //
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
    
    
    
    //
    
     
 //    func getPosts2(token: String){
 //
 //        let defaults = UserDefaults.standard
 //        guard let token = defaults.string(forKey: "jsonwebtoken") else {
 //            return
 //        }
 //
 //        // MARK: API URL
 //        guard let url = URL(string: "https://furry-organic-ambulance.glitch.me/posts") else {return}
 //        var request = URLRequest(url: url)
 //        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
 //
 //        // MARK: Publisher
 //        URLSession.shared.dataTaskPublisher(for: request)
 //
 //        // MARK: Subscribe publisher on background thread
 //            .subscribe(on: DispatchQueue.global(qos: .background))
 //
 //        // MARK: Recieve on main thread
 //            .receive(on: DispatchQueue.main)
 //
 //        // MARK: Check data validation
 //            .tryMap { (data, response) -> Data in
 //                guard let response = response as? HTTPURLResponse,
 //                      response.statusCode >= 200 && response.statusCode < 300 else {
 //                    print("NO RESPONSE!")
 //                    throw URLError(.badServerResponse)
 //                }
 //                return data
 //            }
 //
 //        // MARK: Decode data
 //            .decode(type: [PostModel].self, decoder: JSONDecoder())
 //
 //        // MARK: Put data in the app (.sink)
 //            .sink { (completion) in
 //                print("\(completion) 😀")
 //            } receiveValue: { [weak self] (returnPosts) in
 //                self?.posts2 = returnPosts
 //            }
 //
 //        // MARK: Cancel subscribtion (if needed)
 //            .store(in: &cacelables)
 //
 //
 //
 //
 //    }
    
}


struct PostViewModel {
    
    let post: Post
    
    let id = UUID()
    
    var day: String {
        return post.day
    }
    
    var body: String {
        return post.body
    }
}



enum NetworkErrors: Error {
    case incorrectURL
    case noData
    case decodingFaild
}
