//
//  NormalTempHelp.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2021/01/25.
//

import SwiftUI

struct NormalTempHelp: View {
    @State var temp_1: String = ""
    @State var temp_2: String = ""
    @State var temp_3: String = ""
    @State var temp_4: String = ""
    @State var time_1: Date = Date()
    @State var time_2: Date = Date()
    @State var time_3: Date = Date()
    @State var time_4: Date = Date()
    @State var notification = false
    @State var opacity: Double = 0
    
    var body: some View {
        ScrollView {
            VStack {
                
                HStack {
                    Text("enable-notif")
                        .fontWeight(.regular)
                        .font(.body)
                    Spacer()
                    Toggle("", isOn: $notification)
                        .onChange(of: notification) { _ in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if notification {
                                    opacity = 1
                                } else {
                                    opacity = 0
                                }
                            }
                        }
                        .labelsHidden()
                }
                .padding()
                .padding(.top, 30)
                
                VStack(spacing: 0) {
                    HStack {
                        Text("after-wake-up")
                            .font(.title3)
                        Spacer()
                        
                        DatePicker("", selection: $time_1, displayedComponents: .hourAndMinute)
                            .frame(maxWidth: 100)
                            .opacity(opacity)
                        
                        TextField("", text: $temp_1)
                            .background(Color(.systemGray4))
                            .font(.system(size: 36))
                            .cornerRadius(10)
                            .frame(maxWidth: 80)
                        Text(degree + "C")
                            .fontWeight(.regular)
                            .font(.body)
                    }
                    .padding()
                    .padding(.top)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    HStack {
                        Text("morning")
                            .font(.title3)
                        Spacer()
                        
                        DatePicker("", selection: $time_2, displayedComponents: .hourAndMinute)
                            .frame(maxWidth: 100)
                            .opacity(opacity)
                        
                        TextField("", text: $temp_2)
                            .background(Color(.systemGray4))
                            .font(.system(size: 36))
                            .cornerRadius(10)
                            .frame(maxWidth: 80)
                        Text(degree + "C")
                            .fontWeight(.regular)
                            .font(.body)
                    }
                    .padding()
                    
                    Divider()
                        .padding(.horizontal)
                
                    HStack {
                        Text("afternoon")
                            .font(.title3)
                        Spacer()
                        
                        DatePicker("", selection: $time_3, displayedComponents: .hourAndMinute)
                            .frame(maxWidth: 100)
                            .opacity(opacity)
                        
                        TextField("", text: $temp_3)
                            .background(Color(.systemGray4))
                            .font(.system(size: 36))
                            .cornerRadius(10)
                            .frame(maxWidth: 80)
                        Text(degree + "C")
                            .fontWeight(.regular)
                            .font(.body)
                    }
                    .padding()
                    
                    Divider()
                        .padding(.horizontal)
                
                    HStack {
                        Text("night")
                            .font(.title3)
                        Spacer()
                        
                        DatePicker("", selection: $time_4, displayedComponents: .hourAndMinute)
                            .frame(maxWidth: 100)
                            .opacity(opacity)
                        
                        TextField("", text: $temp_4)
                            .background(Color(.systemGray4))
                            .font(.system(size: 36))
                            .cornerRadius(10)
                            .frame(maxWidth: 80)
                        Text(degree + "C")
                            .fontWeight(.regular)
                            .font(.body)
                    }
                    .padding()
                }
                
                Button(action: {
                    
                }, label: {
                    Text("calc")
                        .foregroundColor(Color(.systemBackground))
                        .fontWeight(.regular)
                        .font(.body)
                        .frame(width: UIScreen.main.bounds.width - 150, height: 60)
                })
                .background(Color(.label))
                .cornerRadius(15)
                .padding()
                
                
                Text("how-to-measure-nt")
                    .foregroundColor(Color(.secondaryLabel))
                    .fontWeight(.regular)
                    .font(.system(size: 13))
                    .padding()
                    .multilineTextAlignment(.leading)
                
                Text("note-keep-data")
                    .foregroundColor(Color(.secondaryLabel))
                    .fontWeight(.regular)
                    .font(.system(size: 13))
                    .padding()
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
        }
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("measure-nt-title")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            var components = DateComponents()
            components.hour = 8
            components.minute = 0
            time_1 = Calendar.current.date(from: components)!
            components.hour = 10
            components.minute = 0
            time_2 = Calendar.current.date(from: components)!
            components.hour = 12
            components.minute = 0
            time_3 = Calendar.current.date(from: components)!
            components.hour = 20
            components.minute = 0
            time_4 = Calendar.current.date(from: components)!
        }
    }
}

struct NormalTempHelp_Previews: PreviewProvider {
    static var previews: some View {
        NormalTempHelp()
    }
}
