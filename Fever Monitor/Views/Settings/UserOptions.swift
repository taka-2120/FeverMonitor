//
//  UserOptions.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2021/09/20.
//

import SwiftUI

struct UserOptions: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var editMode: EditMode = .inactive
    @FocusState private var isEditing_primary: Bool
    @FocusState private var isEditing_other: Bool
    @Binding var users: [Users]
    @State var isDialogShown = false
    
    var body: some View {
        List {
            Section(header: Text("primary")) {
                TextField("user-name", text: $users[0].name)
                    .focused($isEditing_primary)
            }
            
            Section(header: Text("other-users"), footer: Text("other-users-note")) {
                ForEach(1..<users.count, id: \.self) { i in
                    TextField("user-name", text: $users[i].name)
                        .focused($isEditing_other)
                }
                .onDelete() { index in
                    users.remove(atOffsets: index)
                }
                .onMove() { source, dest in
                    users.move(fromOffsets: source, toOffset: dest)
                }
            }
            .environment(\.editMode, $editMode)
        }
        .sheet(isPresented: $isDialogShown) {
            NewUserInformation(users: $users)
        }
        .navigationBarItems(trailing:
                                HStack {
            if users.count < 6 {
                Button(action: {
                    isDialogShown = true
                }, label: {
                    Image(systemName: "plus")
                })
            }
            
            EditButton()
        })
        .navigationTitle("user-settings")
        .onDisappear(perform: save)
    }
    
    func save() {
        if users.contains(where: { $0.name == "" }) {
            //Alert
        } else {
            UIApplication.shared.endEditing()
            
            storeUserData(users: users)
        }
    }
}

struct NewUserInformation: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var tempBox = TempBoxModel()
    @Binding var users: [Users]
    @State var name = ""
    @State var normalTemp = ""
    @State var error = true
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("user-name", text: $name, onCommit: {
                    UIApplication.shared.endEditing()
                })
                .padding()
                .background(Color("SubBackground"))
                .cornerRadius(10)
                .padding()
                
                Divider()
                    .padding(.horizontal)
                
                Text("norm-temp")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                HStack(spacing: 5) {
                    Text("3")
                    
                    TextField("", text: $tempBox.upperDp_NT, onCommit: {
                        UIApplication.shared.endEditing()
                    })
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 50)
                    .background(Color("SubBackground"))
                    .cornerRadius(10)
                    .keyboardType(.numberPad)
                    
                    Text(".")
                    
                    TextField("", text: $tempBox.underDp, onCommit: {
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
                
                //Add Button
                Button(action: {
                    UIApplication.shared.endEditing()
                    
                    if tempBox.upperDp_NT != "" && tempBox.underDp != "" {
                        let temp_str = "3\(tempBox.upperDp_NT).\(tempBox.underDp)"
                        let temp = Double(temp_str)!
                        
                        if isSafeTemp(temp: temp) {
                            users.append(Users(name: name, normalTemp: temp, tempList: [], chartList: [], allDate: []))
                            
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            error = true
                        }
                    } else {
                        error = true
                    }
                }, label: {
                    Text("add")
                        .foregroundColor(Color("AccentColor"))
                        .fontWeight(.bold)
                        .font(.title3)
                        .frame(width: 250, height: 50)
                })
                .background(Color("SubBackground"))
                .cornerRadius(15)
                .padding()
            }
            .navigationBarTitle("new-user")
        }
    }
}
