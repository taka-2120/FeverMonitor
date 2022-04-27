//
//  FirstSettings.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2020/08/17.
//

import SwiftUI
import SwiftUIPager
import HealthKit
import CorePermissionsSwiftUI
import PermissionsSwiftUIHealth
import PermissionsSwiftUINotification

struct FirstSettings: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var users: [Users]
    @State var page: Page = .first()
    @State var failedToAuthorize = false
    @State var indexes: [Int] = [0,1,2,3,4]
    @State var buttonLabel = String.init(localized: "auth")
    @State var currentIndex = 0
    @State var prevButton = false
    @State var tempBox = TempBoxModel()
    @State var tempError = false
    @State var showAuthAlert = false
    @State var userName = ""
    @State var nameError = false
    let readAndWriteData = Set([
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyTemperature)!
    ])
    
    var body: some View {
        VStack {
            Pager(page: page, data: indexes, id: \.self) { index in
                switch index {
                case 0: Authorization(showModal: $showAuthAlert)
                case 1: UserSettings()
                case 2: UserName(userName: $userName, error: $nameError)
                case 3: NormalTemp(tempBox: $tempBox, error: $tempError)
                case 4: Completion()
                default: Authorization(showModal: $showAuthAlert)
                }
            }
            .horizontal()
            .allowsHitTesting(prevButton)
            
            ZStack(alignment: .center) {
                Button(action: {
                    switch currentIndex {
                    case 0: auth()
                    case 1: userNameIntro()
                    case 2: registerUserName()
                    case 3: registerNT()
                    case 4: complete()
                    default: auth()
                    }
                }, label: {
                    Text(buttonLabel)
                        .foregroundColor(Color("AccentColor"))
                        .fontWeight(.bold)
                        .frame(maxWidth: 200, maxHeight: 50)
                        .font(.title3)
                })
                .background(Color(.secondarySystemBackground))
                .cornerRadius(15)
                .padding()
                
                HStack {
                    Button(action: {
                        goBack()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .padding(10)
                            .foregroundColor(Color(.label))
                    })
                    .background(Color(.systemGray).opacity(0.8))
                    .clipShape(Circle())
                    .isHidden(!prevButton, remove: false)
                    Spacer()
                }
                .padding()
            }
        }
        .animation(.easeInOut(duration: 0.3))
        .alert(isPresented: $failedToAuthorize) {
            Alert(title: Text("e_title"), message: Text("e_failed-to-auth-hk"), dismissButton: .cancel(Text("OK"), action: {
                failedToAuthorize = false
            }))
        }
        .JMAlert(showModal: $showAuthAlert, for: [.health(categories: HKAccess(readAndWrite: readAndWriteData)), .notification], restrictDismissal: false)
        .setPermissionComponent(for: .health, image: AnyView(Image(systemName: "heart.fill")), title: "HealthKit")
        .setPermissionComponent(for: .notification, image: AnyView(Image(systemName: "app.badge.fill")), title: "Notification")
    }
    
    func buttonLabelSetter() -> String {
        switch currentIndex {
        case 0: return String.init(localized: "auth")
        case 1: return String.init(localized: "next")
        case 2: return String.init(localized: "register")
        case 3: return String.init(localized: "register")
        case 4: return String.init(localized: "lets-go")
        default: return String.init(localized: "auth")
        }
    }
    
    func goBack() {
        page.update(.previous)
        currentIndex -= 1
        if currentIndex == 0 {
            prevButton = false
        }
        buttonLabel = buttonLabelSetter()
    }
    
    //MARK: -1ST
    func auth() {
        showAuthAlert = true
        page.update(.next)
        currentIndex += 1
        prevButton = true
        buttonLabel = buttonLabelSetter()
    }
    
    //MARK: - 1ST OLD
    func authorizeHK() {
        let healthStore = HKHealthStore()
        
        if HKHealthStore.isHealthDataAvailable() {
            let readAndWriteData = Set([
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyTemperature)!
            ])

            healthStore.requestAuthorization(toShare: readAndWriteData, read: readAndWriteData) { success, error in
                if success {
                    page.update(.next)
                    currentIndex += 1
                } else {
                    failedToAuthorize = true //FOR HK
                }
            }
        } else {
            //hk is not supported
        }
    }
    
    //MARK: - 2ND OLD
    func authorizeNC() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                page.update(.next)
                currentIndex += 1
            } else {
                failedToAuthorize = true //FOR NC
            }
        }
    }
    
    //MARK: - 3RD
    func userNameIntro() {
        page.update(.next)
        currentIndex += 1
        prevButton = true
        buttonLabel = buttonLabelSetter()
    }
    
    //MARK: - 4th
    func registerUserName() {
        if userName == ""  {
            nameError = true
        } else {
            UIApplication.shared.endEditing()
            
            users.append(Users(name: userName, normalTemp: 0, tempList: [], chartList: [], allDate: []))
            page.update(.next)
            currentIndex += 1
            prevButton = true
            buttonLabel = buttonLabelSetter()
            
            storeUserData(users: users)
        }
    }
    
    //MARK: - 5TH
    func registerNT() {
        UIApplication.shared.endEditing()
        if tempBox.upperDp_NT != "" && tempBox.underDp != "" {
            let temp = Double("3\(tempBox.upperDp_NT).\(tempBox.underDp)")
            
            if temp! > 44.0 || temp! < 32.0 {
                tempError = true
            } else {
                users[0].normalTemp = temp!
                page.update(.next)
                currentIndex += 1
                prevButton = true
                buttonLabel = buttonLabelSetter()
            }
        } else {
            tempError = true
        }
    }
    
    //MARK: - Last
    func complete() {
        UserDefaults.standard.set(true, forKey: firstLaunchKey)
        storeUserData(users: users)
        presentationMode.wrappedValue.dismiss()
    }
}
