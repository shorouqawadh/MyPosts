//
//  MainView.swift
//  ImportantTask
//
//  Created by Shorouq Alyami on 10/02/1444 AH.
//

import SwiftUI

struct MainView: View {
    
  @State var isPresented: Bool = false
  var body: some View {
      NavigationView {
          ZStack{
              Color(UIColor.systemBlue)
                  .ignoresSafeArea()
              VStack {
                  Image("logo")
                      .resizable()
                      .scaledToFit()
                  Spacer()
                  Button {
                      isPresented.toggle()
                  } label: {
                      Text("LOGIN").bold()
                          .frame( maxWidth: .infinity,maxHeight: UIScreen.main.bounds.height * 0.06)
                          .background(.white)
                          .cornerRadius(12)
                          .padding()
                  }
              }
              .fullScreenCover(isPresented: $isPresented, content: {
                  LoginView()
              })
              .padding()
          }
      }
  }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
