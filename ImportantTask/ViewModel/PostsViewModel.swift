//
//  PostViewModel.swift
//  ImportantTask
//
//  Created by Shorouq Alyami on 09/02/1444 AH.
//

import Foundation

class PostsViewModel: ObservableObject {
    
    @Published var posts: [PostViewModel] = []
    
    func getPosts() {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "jsonwebtoken") else {
            return
        }
        
        NetworkLayer().getPosts(token: token) { (result) in
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
