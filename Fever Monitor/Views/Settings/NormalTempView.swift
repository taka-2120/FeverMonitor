//
//  UpdateNormalTemp.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2020/08/19.
//

import SwiftUI

struct NormalTempView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var tempBox = TempBoxModel()
    @State var error = false
    @State var selectedUser = 0
    @Binding var users: [Users]
    
    var body: some View {
        VStack {
            Background {
                VStack {
                    HStack {
                        Menu {
                            Picker("", selection: $selectedUser) {
                                ForEach(0 ..< users.count) { index in
                                    Text(users[index].name).tag(index)
                                }
                            }
                        }
                        label: {
                            HStack {
                                Image(systemName: "chevron.up.chevron.down")
                                    .foregroundColor(Color(.secondaryLabel))
                                    .padding(.trailing, 5)
                                Text(users[selectedUser].name)
                                    .foregroundColor(Color(.label))
                                    .frame(width: 100, alignment: .leading)
                            }
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 0) {
                            Text("current")
                            Text(": \(users[selectedUser].normalTemp, specifier: "%.1f") \(degree)C")
                        }
                        .font(.title3)
                    }
                    .padding()
                    
                    Spacer()
                    
                    HStack(spacing: 5) {
                        Text("3")
                        
                        TextField("", text: $tempBox.upperDp_NT, onCommit:  {
                            UIApplication.shared.endEditing()
                        })
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 50)
                        .background(Color("SubBackground"))
                        .cornerRadius(10)
                        .keyboardType(.numberPad)
                        
                        Text(".")
                        
                        TextField("", text: $tempBox.underDp, onCommit:  {
                            UIApplication.shared.endEditing()
                        })
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 50)
                        .background(Color("SubBackground"))
                        .cornerRadius(10)
                        .keyboardType(.numberPad)
                        
                        Text(" " + degree + "C")
                    }
                    .frame(maxWidth: 280, maxHeight: 60)
                    .font(.system(size: 64))
                    .padding(.bottom, 100)
                    
                    
                    Spacer()
                    
                    //Update
                    Button(action: {
                        UIApplication.shared.endEditing()
                        
                        if tempBox.upperDp_NT != "" && tempBox.underDp != "" {
                            let temp_str = "3\(tempBox.upperDp_NT).\(tempBox.underDp)"
                            let temp = Double(temp_str)!
                            
                            if isSafeTemp(temp: temp) {
                                users[selectedUser].normalTemp = temp
                                users[selectedUser].tempList = updateNormalTemp(users: users, currentIndex: selectedUser, normalTemp: temp)
                                storeUserData(users: users)
                                
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                error = true
                            }
                        } else {
                            error = true
                        }
                    }, label: {
                        Text("update")
                            .foregroundColor(Color("AccentColor"))
                            .fontWeight(.bold)
                            .font(.title3)
                            .frame(maxWidth: 250, maxHeight: 50)
                    })
                    .background(Color("SubBackground"))
                    .cornerRadius(15)
                    .padding()
                }
                .padding()
            }
            .onTapGesture(count: 1, perform: {
                UIApplication.shared.endEditing()
            })
            .alert(isPresented: $error) {
                Alert(title: Text("e_title"), message: Text("e_enter-norm-temp-correctly"), dismissButton: .cancel(Text("OK"), action: {
                    error = false
                }))
            }
        }
        .navigationTitle(String.init(localized: "norm-temp"))
    }
}
