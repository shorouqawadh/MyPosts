//
//  PostsView.swift
//  ImportantTask
//
//  Created by Shorouq Alyami on 09/02/1444 AH.
//

import SwiftUI
import Combine

struct PostsView: View {
    
    // MARK: properties
    @Environment(\.presentationMode) var presentationMode
    @StateObject  var postViewModel = PostsViewModel()
    @StateObject  var loginViewModel = LoginViewModel()
    @Binding var isLoading: Bool
    @State var isPresented: Bool = false
    @State var isSignout: Bool = false
    
    var body: some View {
        ZStack{
            Color.white
            List{
                ForEach(postViewModel.posts, id: \.id){ post in
                    VStack {
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
                }
            }
            .listStyle(PlainListStyle())
            
        }
        .navigationTitle("Posts")
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            Button {
                loginViewModel.signout()
                isSignout.toggle()
            } label: {
                Image(systemName: "power")
                    .foregroundColor(.red)
            }
            
            // MARK: Alert
            .alert("Signout", isPresented: $isSignout) {
                Button("OK", role: .destructive) {
                    self.isPresented = true
                }
            }
        })
        
        // Showing Main screen
        .fullScreenCover(isPresented: $isPresented) {
            MainView()
        }
        
        .onAppear {
            loginViewModel.isAuthenticated = true
            postViewModel.getPosts()
            isLoading = false
            print("\(loginViewModel.isAuthenticated)🙏🏽")
            print("\(postViewModel.posts)🙏🏽")
        }
    }
}



