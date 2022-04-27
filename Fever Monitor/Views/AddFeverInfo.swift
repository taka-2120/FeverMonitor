//
//  AddFeverInfo.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2020/08/17.
//

import SwiftUI
import HealthKit
import SwiftUIPager

struct AddFeverInfo: View {
    
    enum Alerts {
        case valueError, writingError, confirmation, futureDate
    }
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var tempBox = TempBoxModel()
    @State var error = false
    @State var date = Date()
    @State var alerts: Alerts = .valueError
    @State var givenTemp = 0.0
    @State var sheet = false
    @Binding var add_cancelled: Bool
    @Binding var index: Int
    @Binding var users: [Users]
    @Binding var normalTemp: Double
    @Binding var last7Days: [Date]
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    Background {
                        VStack {
                            HStack(spacing: 5) {
                                TextField("", text: $tempBox.upperDp)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: 100)
                                    .background(Color("SubBackground"))
                                    .cornerRadius(10)
                                    .keyboardType(.numberPad)
                                
                                Text(".")
                                
                                TextField("", text: $tempBox.underDp)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: 50)
                                    .background(Color("SubBackground"))
                                    .cornerRadius(10)
                                    .keyboardType(.numberPad)
                            }
                            .frame(maxWidth: 230, maxHeight: 60)
                            .font(.system(size: 64))
                            .padding(.top, 30)
                            
                            Divider()
                                .padding(.horizontal)
                                .padding(.vertical, 20)
                            
                            DatePicker("date", selection: $date)
                                .datePickerStyle(DefaultDatePickerStyle())
                                .padding(.bottom, 20)
                            
                            Spacer()
                            
                            NavigationLink(destination: HelpView(sheet: $sheet)) {
                                Text("other-symptoms")
                                    .fontWeight(.regular)
                                    .font(.body)
                                    .foregroundColor(Color(.systemBlue))
                            }
                            .simultaneousGesture(TapGesture().onEnded{
                                sheet = true
                            })
                            .padding()
                            
                            NavigationLink(destination: MeasureTempHelp(sheet: $sheet)) {
                                Text("mesure-correctly")
                                    .fontWeight(.regular)
                                    .font(.body)
                                    .foregroundColor(Color(.systemBlue))
                            }
                            .simultaneousGesture(TapGesture().onEnded{
                                sheet = true
                            })
                            .padding(.bottom, 50)
                        }
                        .padding()
                    }
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                }
                .alert(isPresented: $error) {
                    switch alerts {
                    case .valueError:
                        return Alert(title: Text("e_title"), message: Text("e_enter-correctly"), dismissButton: .cancel(Text("OK"), action: {
                        error = false
                    }))
                    
                    case .writingError:
                        return Alert(title: Text("e_title"), message: Text("e_filed-to-save"), dismissButton: .cancel(Text("OK"), action: {
                        error = false
                    }))
                        
                    case .confirmation:
                        return Alert(title: Text("c_title"), message: Text("c_too-high"), primaryButton: .default(Text("msg_yes"), action: {
                            error = false
                            
                            save(value: givenTemp, date: date)
                            presentationMode.wrappedValue.dismiss() //Is it working?
                        }), secondaryButton: .cancel(Text("msg_try-again"), action: {
                            error = false
                        }))
                        
                    case .futureDate:
                        return Alert(title: Text("e_title"), message: Text("e_future-date"), dismissButton: .cancel(Text("OK"), action: {
                        error = false
                    }))
                    }
                }
                .navigationTitle("add")
                .navigationBarItems(leading:
                                        Button(action: {
                                            UIApplication.shared.endEditing()
                                            add_cancelled = true
                                            presentationMode.wrappedValue.dismiss()
                                        }, label: {
                                            Image(systemName: "xmark")
                                                .font(Font.system(size: 14).weight(.bold))
                                                .padding([.vertical, .leading], 3)
                                                .padding(.leading, 6)
                                                .foregroundColor(Color("AccentColor"))
                                        })
                                        .background(Color("SubBackground"))
                                        .clipShape(Circle()), trailing: Button(action: {
                    UIApplication.shared.endEditing()
                        
                    if date > Date() {
                        alerts = .futureDate
                        error = true
                        return
                    }
                    
                    if tempBox.upperDp == "" || tempBox.underDp == "" {
                        alerts = .valueError
                        error = true
                        return
                    }
                    
                    let temp = Double("\(tempBox.upperDp).\(tempBox.underDp)")!
                    if !isSafeTemp(temp: temp) {
                        alerts = .valueError
                        error = true
                    } else {
                        let normalTemp = Double(UserDefaults.standard.string(forKey: "UsersNormalTemperature") ?? "0.0")
                        if temp > normalTemp! + 3 {
                            givenTemp = temp
                            alerts = .confirmation
                            error = true
                        } else {
                            save(value: temp, date: date)
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "checkmark")
                        .font(Font.system(size: 14).weight(.bold))
                        .padding([.vertical, .leading], 3)
                        .padding(.trailing, 10.5)
                        .foregroundColor(Color("AccentColor"))
                })
                .background(Color("SubBackground"))
                .clipShape(Circle()))
            }
        }
    }
    
    func save(value: Double, date: Date) {
        //Store in HK
        if index == 0 {
            let tempDataType = HKQuantityType.quantityType(forIdentifier: .bodyTemperature)!
            let tempDataQuantity = HKQuantity.init(unit: .degreeCelsius(), doubleValue: value)
            let tempDataSample = HKQuantitySample(type: tempDataType, quantity: tempDataQuantity, start: date, end: date)
            
            HKHealthStore().save(tempDataSample) { (success, _error) in
                if !success {
                    alerts = .writingError
                    error = true
                } else {
                    NotificationCenter.default.post(name: .init("reloadTempNotif"), object: nil)
                }
            }
        }
        
        users[index].tempList.append(TempList(condition: determineCondition(normalTemp: normalTemp, temp: value), temp: value, date: date))
        users[index].chartList = convertForChart(tempList: users[index].tempList, last7Days: last7Days)
        
        storeUserData(users: users)
    }
}
