//
//  Settings.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2020/08/18.
//

import SwiftUI

struct Settings: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var sheet = false
    @Binding var users: [Users]
    
    var body: some View {
        NavigationView {
            ZStack {
                //Color("ListBackground").edgesIgnoringSafeArea(.all)
                
                List {
                    
                    Section {
                        NavigationLink(destination: NormalTempView(users: $users)){
                            Text("norm-temp")
                        }
                        NavigationLink(destination: Notification()){
                            Text("notif")
                        }
                        NavigationLink(destination: UserOptions(users: $users)){
                            Text("user-settings")
                        }
                    }
                    
                    Section(header: Text("info")) {
                        NavigationLink(destination: HelpView(sheet: $sheet)){
                            Text("help")
                        }
                        
                        NavigationLink(destination: Attributes()){
                            Text("credits")
                        }
                        
                        HStack {
                            Text("version")
                            Spacer()
                            Text("1.0.0")
                                .onTapGesture(count: 10) {
                                    UserDefaults.standard.set("true", forKey: firstLaunchKey)
                                }
                        }
                    }
                    
                    Button(action: {
                        UIApplication.shared.open(URL(string: "x-apple-health://")!)
                    }, label: {
                        HStack {
                            Image(systemName: "arrow.up.forward.app.fill")
                            
                            Text("open-health-app")
                                .padding(.horizontal)
                        }
                    })
                }
                .listStyle(InsetGroupedListStyle())
            }
            .font(.body)
            .navigationTitle("settings")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .font(Font.system(size: 14).weight(.bold))
                                            .padding([.vertical, .leading], 3)
                                            .padding(.trailing, 10.5)
                                            .foregroundColor(Color("AccentColor"))
                                    })
                                    .background(Color("SubBackground"))
                                    .clipShape(Circle())
            )
            //.onAppear() {
            //    UITableView.appearance().backgroundColor = UIColor.clear
            //}
        }
    }
}
