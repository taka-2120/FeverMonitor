//
//  normalTemp.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2020/08/16.
//

import SwiftUI

struct NormalTemp: View {
    @Binding var tempBox: TempBoxModel
    @Binding var error: Bool
    
    var body: some View {
        Background {
            VStack {
                Text("set-your-norm-temp")
                    .multilineTextAlignment(.center)
                    .font(Font.largeTitle.weight(.bold))
                    .padding(.top, 10)
                
                Spacer()
                
                HStack(spacing: 5) {
                    Text("3")
                    
                    TextField("", text: $tempBox.upperDp_NT, onCommit:  {
                        UIApplication.shared.endEditing()
                    })
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 50)
                    .background(Color(.lightGray).opacity(0.5))
                    .cornerRadius(10)
                    .keyboardType(.numberPad)
                    
                    Text(".")
                    
                    TextField("", text: $tempBox.underDp, onCommit:  {
                        UIApplication.shared.endEditing()
                    })
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 50)
                    .background(Color(.lightGray).opacity(0.5))
                    .cornerRadius(10)
                    .keyboardType(.numberPad)
                }
                .frame(maxWidth: 180, maxHeight: 60)
                .font(.system(size: 64))
                
                Spacer()
            }
        }
        .background(Color(.systemBackground))
        .onTapGesture(count: 1, perform: {
            UIApplication.shared.endEditing()
        })
        .alert(isPresented: $error) {
            Alert(title: Text("e_title"), message: Text("e_filed-to-save-norm-temp"), dismissButton: .cancel(Text("OK"), action: {
                error = false
            }))
        }
    }
}
