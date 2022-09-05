//
//  LoginView.swift
//  ImportantTask
//
//  Created by Shorouq Alyami on 09/02/1444 AH.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var postViewModel = PostsViewModel()
    @State var showWelcomeView = false

    var body: some View {
        NavigationView{
            VStack{
                TextField("Username", text: $loginViewModel.username)
                    .padding()
                    .frame( height: UIScreen.main.bounds.height * 0.07)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                
                SecureField("Password", text: $loginViewModel.password)
                    .padding()
                    .frame( height: UIScreen.main.bounds.height * 0.07)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                Button {
                    loginViewModel.login()
                } label: {
                    Text("Login")
                        .frame( width: UIScreen.main.bounds.width * 0.9,
                                height:  UIScreen.main.bounds.height * 0.07)
                        .background(Color(UIColor.systemBlue))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.top)
                }
                Spacer()
                if loginViewModel.isAuthenticated && postViewModel.posts.count > 0 {
                    List{
                        ForEach(postViewModel.posts, id: \.id){ post in
                        VStack(alignment: .leading) {
                            Text("\(post.day)")
                                .font(.title3)
                                .bold()
                            Text("\(post.body)")
                                .fontWeight(.light)
                                .foregroundColor(.gray)
                        }
                        .frame(height: UIScreen.main.bounds.height * 0.1)
                        .cornerRadius(12)
                        .padding()
                            
                        }
                    } .listStyle(SidebarListStyle()) .listRowBackground(Color.red)
                } else {
                    Text("Login to see your posts!")
                }
                
                Button("See my posts") {
                    postViewModel.getPosts()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
            }
            .padding()
            .padding(.top)
            .navigationTitle("Login")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}



