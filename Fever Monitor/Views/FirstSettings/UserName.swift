//
//  UserName.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2021/12/25.
//

import SwiftUI

struct UserName: View {
    @Binding var userName: String
    @Binding var error: Bool
    
    var body: some View {
        Background {
            VStack {
                Text("register-your-name")
                    .multilineTextAlignment(.center)
                    .font(Font.largeTitle.weight(.bold))
                    .padding(.top, 10)
                
                Spacer()
                
                ZStack {
                    TextField("your-name", text: $userName, onCommit:  {
                        UIApplication.shared.endEditing()
                    })
                        .font(.title2)
                        .padding()
                }
                .background(Color(.lightGray).opacity(0.5))
                .cornerRadius(10)
                .padding()
                
                Spacer()
            }
        }
        .background(Color(.systemBackground))
        .onTapGesture(count: 1, perform: {
            UIApplication.shared.endEditing()
        })
        .alert(isPresented: $error) {
            Alert(title: Text("e_title"), message: Text("e_filed-to-save-user-name"), dismissButton: .cancel(Text("OK"), action: {
                error = false
            }))
        }
    }
}
