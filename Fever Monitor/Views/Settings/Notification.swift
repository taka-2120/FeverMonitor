//
//  Notification.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2020/08/21.
//

import SwiftUI

struct Notification: View {
    
    let content = UNMutableNotificationContent()
    let dateFormatter = DateFormatter()
    
    @State var failedToAuthorize = false
    @State var notification = false
    
    @State var everydayTime = Date()
    @State var sundayTime = Date()
    @State var mondayTime = Date()
    @State var tuesdayTime = Date()
    @State var wednesdayTime = Date()
    @State var thursdayTime = Date()
    @State var fridayTime = Date()
    @State var saturdayTime = Date()
    
    @State var everyday = true
    @State var sunday = false
    @State var monday = false
    @State var tuesday = false
    @State var wednesday = false
    @State var thursday = false
    @State var friday = false
    @State var saturday = false
    
    @State var opacity: Double = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("enable-notif")
                    .font(.body)
                    .fontWeight(.regular)
                
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
            .padding(.vertical, 7)
            .padding(.horizontal)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(10)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            
            List {
                Section(header: Text("")) {
                    HStack {
                        Text("everyday")
                        Spacer()
                        
                        if everyday {
                            DatePicker("", selection: $everydayTime, displayedComponents: .hourAndMinute)
                                .frame(maxWidth: 100)
                        }
                        
                        Toggle("", isOn: $everyday.animation())
                            .onChange(of: everyday) { _ in
                                if everyday == true {
                                    sunday = false
                                    monday = false
                                    tuesday = false
                                    wednesday = false
                                    thursday = false
                                    friday = false
                                    saturday = false
                                } else {
                                    sunday = true
                                    monday = true
                                    tuesday = true
                                    wednesday = true
                                    thursday = true
                                    friday = true
                                    saturday = true
                                }
                            }
                            .labelsHidden()
                    }
                }
                
                Section(header: Text("")) {
                    
                    HStack {
                        Text("sun")
                        Spacer()
                        
                        if sunday {
                            DatePicker("", selection: $sundayTime, displayedComponents: .hourAndMinute)
                                .frame(maxWidth: 100)
                        }
                        
                        Toggle("", isOn: $sunday.animation())
                            .labelsHidden()
                    }
                    
                    HStack {
                        Text("mon")
                        Spacer()
                        if monday {
                            DatePicker("", selection: $mondayTime, displayedComponents: .hourAndMinute)
                                .frame(maxWidth: 100)
                        }
                        Toggle("", isOn: $monday.animation())
                            .labelsHidden()
                    }
                    
                    HStack {
                        Text("tue")
                        Spacer()
                        if tuesday {
                            DatePicker("", selection: $tuesdayTime, in: ...Date(), displayedComponents: .hourAndMinute)
                            .frame(maxWidth: 100)
                        }
                        Toggle("", isOn: $tuesday.animation())
                            .labelsHidden()
                    }
                    
                    HStack {
                        Text("wed")
                        Spacer()
                        if wednesday {
                            DatePicker("", selection: $wednesdayTime, in: ...Date(), displayedComponents: .hourAndMinute)
                            .frame(maxWidth: 100)
                        }
                        Toggle("", isOn: $wednesday.animation())
                            .labelsHidden()
                    }
                    
                    HStack {
                        Text("thu")
                        Spacer()
                        if thursday {
                            DatePicker("", selection: $thursdayTime, in: ...Date(), displayedComponents: .hourAndMinute)
                            .frame(maxWidth: 100)
                        }
                        Toggle("", isOn: $thursday.animation())
                            .labelsHidden()
                    }
                    
                    HStack {
                        Text("fri")
                        Spacer()
                        if friday {
                            DatePicker("", selection: $fridayTime, in: ...Date(), displayedComponents: .hourAndMinute)
                            .frame(maxWidth: 100)
                        }
                        Toggle("", isOn: $friday.animation())
                            .labelsHidden()
                    }
                    
                    HStack {
                        Text("sat")
                        Spacer()
                        
                        if saturday {
                            DatePicker("", selection: $saturdayTime, displayedComponents: .hourAndMinute)
                            .frame(maxWidth: 100)
                        }
                        
                        Toggle("", isOn: $saturday.animation())
                            .labelsHidden()
                    }
                }
            }
            .opacity(opacity)
            .listStyle(InsetGroupedListStyle())
            .font(.body)
            .navigationTitle("notif")
            .onDisappear() {
                saveNotificationSettings()
            }
            .onAppear() {
                loadNotificationSettings()
            }
            .alert(isPresented: $failedToAuthorize) {
                Alert(title: Text("e_title"), message: Text("e_failed-to-auth-notif"), dismissButton: .cancel(Text("OK"), action: {
                    failedToAuthorize = false
                }))
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
    
    func setNotif(key: String, date: Date, toggle: Bool, index: Int, everyday: Bool) {
        if toggle == true {
            
            if everyday == true {
                for i in 1...7 {
                    settingNotif(key: keyGenerator(index: i), date: date, index: i)
                }
            } else {
                settingNotif(key: key, date: date, index: index)
            }
        } else {
            let nc = UNUserNotificationCenter.current()
            nc.removeDeliveredNotifications(withIdentifiers: [key])
            nc.removePendingNotificationRequests(withIdentifiers: [key])
        }
    }
    
    func settingNotif(key: String, date: Date, index: Int) {
        let nc = UNUserNotificationCenter.current()
        var dateConponetsDay = DateComponents()
        var calendar = Calendar.current
        calendar.locale = Locale.current
        calendar.timeZone = TimeZone.current
        
        nc.removeDeliveredNotifications(withIdentifiers: [key])
        nc.removePendingNotificationRequests(withIdentifiers: [key])
        
        dateConponetsDay.hour = calendar.component(.hour, from: date)
        dateConponetsDay.minute = calendar.component(.minute, from: date)
        dateConponetsDay.weekday = index
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateConponetsDay, repeats: true)
        let request = UNNotificationRequest(identifier: key, content: content, trigger: trigger)
        
        nc.add(request)
    }
    
    func loadNotificationSettings() {
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        notification = UserDefaults.standard.bool(forKey: "notification-toggle")
        if notification == true {
            sunday = UserDefaults.standard.bool(forKey: sunTogKey)
            if sunday == true {
                everyday = false
                sundayTime = dateFormatter.date(from: UserDefaults.standard.string(forKey: sunTimeKey)!) ?? Date()
            }
            
            monday = UserDefaults.standard.bool(forKey: monTogKey)
            if monday == true {
                everyday = false
                mondayTime = dateFormatter.date(from: UserDefaults.standard.string(forKey: monTimeKey)!) ?? Date()
            }
            
            tuesday = UserDefaults.standard.bool(forKey: tueTogKey)
            if tuesday == true {
                everyday = false
                tuesdayTime = dateFormatter.date(from: UserDefaults.standard.string(forKey: tueTimeKey)!) ?? Date()
            }
            
            wednesday = UserDefaults.standard.bool(forKey: wedTogKey)
            if wednesday == true {
                everyday = false
                wednesdayTime = dateFormatter.date(from: UserDefaults.standard.string(forKey: wedTimeKey)!) ?? Date()
            }
            
            thursday = UserDefaults.standard.bool(forKey: thuTogKey)
            if thursday == true {
                everyday = false
                thursdayTime = dateFormatter.date(from: UserDefaults.standard.string(forKey: thuTimeKey)!) ?? Date()
            }
            
            friday = UserDefaults.standard.bool(forKey:friTogKey)
            if friday == true {
                everyday = false
                fridayTime = dateFormatter.date(from: UserDefaults.standard.string(forKey: friTimeKey)!) ?? Date()
            }
            
            saturday = UserDefaults.standard.bool(forKey: satTogKey)
            if saturday == true {
                everyday = false
                saturdayTime = dateFormatter.date(from: UserDefaults.standard.string(forKey: satTimeKey)!) ?? Date()
            }
            
            everyday = UserDefaults.standard.bool(forKey: eveTogKey)
            if everyday == true {
                everydayTime = dateFormatter.date(from: UserDefaults.standard.string(forKey: eveTimeKey)!) ?? Date()
            }
        }
        
        content.title = "Fever Monitor"
        content.body = String.init(localized: "notif-content")
        content.sound = .default
    }
    
    func saveNotificationSettings() {
        
        UserDefaults.standard.set(notification, forKey: "notification-toggle")
        
        if notification == true {
            setNotif(key: sunKey, date: sundayTime, toggle: sunday, index: 1, everyday: false)
            UserDefaults.standard.set(sunday, forKey: sunTogKey)
            if sunday == true {
                UserDefaults.standard.set(dateFormatter.string(from: sundayTime), forKey: sunTimeKey)
            }
            
            setNotif(key: monKey, date: mondayTime, toggle: monday, index: 2, everyday: false)
            UserDefaults.standard.set(monday, forKey: monTogKey)
            if monday == true {
                UserDefaults.standard.set(dateFormatter.string(from: mondayTime), forKey: monTimeKey)
            }
            
            setNotif(key: tueKey, date: tuesdayTime, toggle: tuesday, index: 3, everyday: false)
            UserDefaults.standard.set(tuesday, forKey: tueTogKey)
            if tuesday == true {
                UserDefaults.standard.set(dateFormatter.string(from: tuesdayTime), forKey: tueTimeKey)
            }
            
            setNotif(key: wedKey, date: wednesdayTime, toggle: wednesday, index: 4, everyday: false)
            UserDefaults.standard.set(wednesday, forKey: wedTogKey)
            if wednesday == true {
                UserDefaults.standard.set(dateFormatter.string(from: wednesdayTime), forKey: wedTimeKey)
            }
            
            setNotif(key: thuKey, date: thursdayTime, toggle: thursday, index: 5, everyday: false)
            UserDefaults.standard.set(thursday, forKey: thuTogKey)
            if thursday == true {
                UserDefaults.standard.set(dateFormatter.string(from: thursdayTime), forKey: thuTimeKey)
            }
            
            setNotif(key: friKey, date: fridayTime, toggle: friday, index: 6, everyday: false)
            UserDefaults.standard.set(friday, forKey: friTogKey)
            if friday == true {
                UserDefaults.standard.set(dateFormatter.string(from: fridayTime), forKey: friTimeKey)
            }
            
            setNotif(key: satKey, date: saturdayTime, toggle: saturday, index: 7, everyday: false)
            UserDefaults.standard.set(saturday, forKey: satTogKey)
            if saturday == true {
                UserDefaults.standard.set(dateFormatter.string(from: saturdayTime), forKey: satTimeKey)
            }
            
            setNotif(key: "", date: everydayTime, toggle: everyday, index: 0, everyday: true)
            UserDefaults.standard.set(everyday, forKey: eveTogKey)
            if everyday == true {
                UserDefaults.standard.set(dateFormatter.string(from: everydayTime), forKey: eveTimeKey)
            }
        } else {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.removeAllDeliveredNotifications()
            notificationCenter.removeAllPendingNotificationRequests()
        }
    }
    
    func keyGenerator(index: Int) -> String {
        switch index {
        case 1: return sunKey
        case 2: return monKey
        case 3: return tueKey
        case 4: return wedKey
        case 5: return thuKey
        case 6: return friKey
        case 7: return satKey
        default: return sunKey
        }
    }
}
