//
//  ContentView.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2020/08/16.
//

import SwiftUI
import SwiftUIPager
import HealthKit

struct ContentView: View {
    
    enum Alerts {
        case normalTempError, authorizationError
    }
    
    let reloadNotif = NotificationCenter.default.publisher(for: .init("reloadTempNotif"))
    
    @Binding var normalTemp: Double
    @Binding var safearea: CGFloat
    @State var tapped = [Bool]()
    
    //User Pages
    @State var page_head: Page = .first()
    @State var page: Page = .first()
    //Sheets and Alerts
    @State var addSheet = false
    @State var settingsSheet = false
    @State var error = false
    @State var alerts: Alerts = .normalTempError
    //Value
    @State var chartLabel = "--"            //Top
    @State var dateLabel = "--"             //Top
    @Binding var last7Days: [Date]          //Store Last 7 Days
    @State var add_cancelled = false        //When Add Sheet Was Closed By Tapping X
    //Users
    @Binding var users: [Users]
    
    
    var body: some View {
        ZStack {
            
            //Body
            Pager(page: page, data: users.map{ $0.name }, id: \.self) { user in
                let index = users.map{ $0.name }.firstIndex(of: user) ?? 0
                Dashboard(allDate: $users[index].allDate, tempList: $users[index].tempList, chartList: $users[index].chartList)
            }
            .horizontal()
            .sensitivity(.low)
            .onPageChanged { index in
                hapticReaction()
                page_head = .withIndex(index)
            }
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeInOut)
            
            
            //Header and Footer
            VStack {
                //Header
                HStack {
                    HStack(spacing: 0) {
                        //Chevrons
                        VStack(spacing: 7) {
                            Button(action: {
                                page.update(.previous)
                                page_head.update(.previous)
                                hapticReaction()
                            }, label: {
                                DefaultIcon(systemName: "chevron.up")
                            })
                            
                            Button(action: {
                                page.update(.next)
                                page_head.update(.next)
                                hapticReaction()
                            }, label: {
                                DefaultIcon(systemName: "chevron.down")
                            })
                        }
                        
                        //Users List
                        GeometryReader { geo in
                            Pager(page: page_head, data: users.map{ $0.name }, id: \.self) { user in
                                Text(user)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: geo.size.width, alignment: .leading)
                                    .padding(.leading)
                            }
                            .vertical()
                            .interactive(scale: 0.8)
                            .onPageChanged({ index in
                                hapticReaction()
                                page = .withIndex(index)
                            })
                            .animation(.easeInOut)
                        }
                    }
                    .padding(.top, safearea)
                    .padding(.leading)
                    
                    Spacer()
                    VStack(spacing: 0) {
                        //Temp Label  *Dinamically Index
                        if $users[page.index].tempList.count == 0 {
                            Text("N/A")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.top, 5)
                                .multilineTextAlignment(.trailing)
                        } else {
                            Text(tempLabel(value: users[page.index].tempList[0].temp))
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.top, 5)
                                .multilineTextAlignment(.trailing)
                        }
                        Spacer()
                        
                        //Date Label
                        if $users[page.index].tempList.count != 0 {
                            Text((dateToString(date: true, time: true).string(from: users[page.index].tempList[0].date)))
                                .foregroundColor(Color(.secondaryLabel))
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    .padding(.top, safearea)
                    .padding(.trailing)
                }
                .foregroundColor(Color(.label))
                .padding([.horizontal, .top], 5)
                .padding(.bottom)
                .frame(width: UIScreen.main.bounds.width, height: 100 + safearea)
                .background(gradient)
                .cornerRadius(30, corners: [.bottomLeft, .bottomRight])
                .shadow(color: Color("AccentColor"), radius: 8, x: 0, y: 3)
                
                Spacer()
                
                //Footer
                HStack {
                    
                    //Settings Button
                    Button(action: {
                        settingsSheet = true
                    }, label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Color("AccentColor"))
                            .font(.title2)
                    })
                    .frame(minWidth: 50, minHeight: 50)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(25)
                    .shadow(radius: 8)
                    .sheet(isPresented: $settingsSheet) {
                        Settings(users: $users)
                    }
                    
                    Spacer()
                    
                    //Add Button
                    Button(action: {
                        addSheet = true
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color("AccentColor"))
                            .font(.title2)
                    })
                    .frame(minWidth: 50, minHeight: 50)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(25)
                    .shadow(radius: 8)
                    .sheet(isPresented: $addSheet) {
                        AddFeverInfo(add_cancelled: $add_cancelled, index: $page.index, users: $users, normalTemp: $normalTemp, last7Days: $last7Days)
                    }
                }
                .padding()
                
            }
            .edgesIgnoringSafeArea(.top)
            
        }
        //.background(Color("Background"))
        
        //Alert
        .alert(isPresented: $error) {
            switch alerts {
            case .normalTempError:
                return Alert(title: Text("e_title"), message: Text("e_failed-to-auth-hk"), dismissButton: .cancel(Text("OK"), action: {
                    error = false
                }))
            case .authorizationError:
                return Alert(title: Text("e_title"), message: Text("e_norm-temp-isnt-saved"), dismissButton: .cancel(Text("OK"), action: {
                    error = false
                }))
            }
        }
    }
}

// MARK: - List Row View

struct Row: View {
    var temp: String
    var condition: Int
    var date: String
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: conditionChecking(condition: condition).text)
                    .foregroundColor(conditionChecking(condition: condition).color)
                    .frame(maxWidth: 20)
                Text(temp)
            }
            Spacer()
            Text(date)
        }
        .padding()
    }
}

// MARK: - Graph Area
struct Dashboard: View {
    
    @Binding var allDate: [Date]
    @Binding var tempList: [TempList]
    @Binding var chartList: [ChartList]
    @State var graphSelection = 0
    @State var graphTypeLabel = String.init(localized: "daily")
    
    var body: some View {
        ScrollView {
            if tempList.count == 0 {
                Text("no-data")
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .foregroundColor(Color(.systemGray))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 70)
            } else {
                VStack {
                    if chartList.count == 0 {
                        Text("no-data-last-7-days")
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .foregroundColor(Color(.systemGray))
                            .multilineTextAlignment(.center)
                        
                    } else {
                        //Graph Type Label
                        HStack {
                            Menu {
                                Picker("", selection: $graphSelection) {
                                    Text(String.init(localized: "daily")).tag(0)
                                    Text(String.init(localized: "hourly")).tag(1)
                                }
                            }
                            label: {
                                HStack {
                                    Image(systemName: "chevron.up.chevron.down")
                                        .foregroundColor(Color(.secondaryLabel))
                                        .padding(.trailing, 5)
                                    Text(graphTypeLabel)
                                        .foregroundColor(Color(.label))
                                        .frame(width: 100, alignment: .leading)
                                }
                            }
                            .onChange(of: graphSelection, perform: { _ in
                                switch graphSelection {
                                case 0: graphTypeLabel = String.init(localized: "daily")
                                case 1: graphTypeLabel = String.init(localized: "hourly")
                                default: graphTypeLabel = String.init(localized: "daily")
                                }
                            })
                            
                            Spacer()
                        }
                        .padding()
                        .isHidden(true, remove: true)
                        
                        GeometryReader { reader in
                            //Graph
                            VStack(spacing: 0) {
                                HStack {
                                    Text(String(format: "%.1f\(degree)C", chartList[0].temp))
                                        .font(.system(size: 24, weight: .bold))
                                    Spacer()
                                    Text(dateToString(date: true, time: true).string(from: chartList[0].date))
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(.systemGray))
                                }
                                .padding(12)
                                
                                ZStack {
                                    LinerChart(data: chartList)
                                }
                                .frame(minHeight: 150, maxHeight: 150)
                            }
                        }
                        .frame(minHeight: 205)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(15)
                        .shadow(radius: 10)
                        .padding(.horizontal, 20)
                    }
                    
                    ForEach(tempList, id: \.self) { tempData in
                        Row(temp: "\(tempData.temp) \(degree)C", condition: tempData.condition, date: dateToString(date: true, time: true).string(from: tempData.date))
                    }
                    .padding(.top)
                }
                .padding(.top, 70)
                .padding(.bottom, 100)
            }
        }
        .padding(.top, 90)
    }
}
