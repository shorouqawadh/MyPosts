//
//  LoginView.swift
//  ImportantTask
//
//  Created by Shorouq Alyami on 09/02/1444 AH.
//

import SwiftUI
import Combine

struct LoginView: View {
    
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var postViewModel = PostsViewModel()
    @State var isLoading = false
    
    var body: some View {
        NavigationView{
          ZStack {
            VStack{
              Form{
                    Section(header: Text("ENTER YOUR INFORMATION"),
                            footer: Text(loginViewModel.errorText).foregroundColor(.red)){
                     TextField("Username", text: $loginViewModel.username)
                     SecureField("Password", text: $loginViewModel.password)
                }
              }
             Button {
                 loginViewModel.isLoading = true
                    loginViewModel.login()
             } label: {
                    RoundedRectangle(cornerRadius: 12)
                    .frame( width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.07)
                    .overlay( Text("Login").foregroundColor(.white))
             }
             .disabled(loginViewModel.isValid)
             NavigationLink("", destination:  PostsView(isLoading: $isLoading), isActive: $loginViewModel.isAuthenticated)
               }
              
              // MARK: Login alert
            .alert(Text("Login Faild"), isPresented: $loginViewModel.isAlert, actions: {
                Button("OK", role: .cancel) {
                    loginViewModel.isAlert  = false
                }

            }, message: {
                Text("Username or password is incorrect")
            })

              .navigationTitle("Login")
              if loginViewModel.isLoading{
                  LoadingView()
            }
          }
        }
        .onAppear {
            print("\(loginViewModel.isAuthenticated)🙏🏽")
        }
        
      
       
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}




struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor.systemBlue)))
            .scaleEffect(2)
            .frame(width: 100, height: 100)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}
