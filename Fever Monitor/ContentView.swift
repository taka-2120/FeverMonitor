//
//  ContentView.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2022/06/07.
//

import SwiftUI
import SwiftUIPager

struct ContentView: View {
    enum Alerts {
        case normalTempError, authorizationError
    }
    
    @Binding var users: [Users]
    @Binding var normalTemp: Double
    @Binding var safearea: CGFloat
    var lastWeek: [Date]

    //User Pages
    @State var page: Page = .first()
    //Sheets and Alerts
    @State var isAddShown = false
    @State var isSettingsShown = false
    //Value
    @State var chartLabel = "--"
    @State var dateLabel = "--"
    @State var error = false
    @State var alerts: Alerts = .normalTempError


    var body: some View {
        ZStack {
            //Pages For Each Users
            Pager(page: page, data: users.map{$0.name}, id: \.self) { user in
                let index = users.map{$0.name}.firstIndex(of: user) ?? 0
                Dashboard(
                    tempList: $users[index].tempList,
                    chartTemp: $users[index].chartTemp,
                    lastWeek: lastWeek
                )
            }
            .horizontal()
            .sensitivity(.low)
            .onPageChanged { index in
                withAnimation {
                    hapticReaction()
                    page = .withIndex(index)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            
            //Header and Footer Overlay
            VStack(alignment: .leading) {
                //Gradient Horizontal Background
                HStack {
                    HStack(spacing: 0) {
                        //Chevrons
                        VStack(spacing: 7) {
                            Button(action: {
                                page.update(.previous)
                                hapticReaction()
                            }, label: {
                                DefaultIcon(systemName: "chevron.up")
                            })
                            
                            Button(action: {
                                page.update(.next)
                                hapticReaction()
                            }, label: {
                                DefaultIcon(systemName: "chevron.down")
                            })
                        }
                        
                        //Users Small List
                        GeometryReader { geo in
                            Pager(page: page, data: users.map{$0.name}, id: \.self) { user in
                                Text(user)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: geo.size.width, alignment: .leading)
                                    .padding(.leading)
                            }
                            .vertical()
                            .interactive(scale: 0.8)
                            .onPageChanged({ index in
                                withAnimation {
                                    hapticReaction()
                                    page = .withIndex(index)
                                }
                            })
                        }
                    }
                    .padding(.top, safearea)
                    .padding(.leading)
                    
                    Spacer()
                    
                    //
                    VStack(spacing: 0) {
                        if $users[page.index].tempList.count == 0 {
                            Text("N/A")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.top, 5)
                                .multilineTextAlignment(.trailing)
                        } else {
                            Text(users[page.index].tempList[0].temp.toTempString())
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.top, 5)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        Spacer()
                        
                        //Date Label
                        if $users[page.index].tempList.count != 0 {
                            Text(users[page.index].tempList[0].date.formatDateToString(
                                showDate: true,
                                showTime: true)
                            )
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
                    CircleNavigationButton(
                        isShown: $isSettingsShown,
                        icon: "gearshape.fill",
                        destination: AnyView(EmptyView())
                    )
                    Spacer()
                    CircleNavigationButton(
                        isShown: $isAddShown,
                        icon: "plus",
                        destination: AnyView(EmptyView())
                    )
                }
                .padding()
            }
            .edgesIgnoringSafeArea(.top)
            
        }
        
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let tempList = [TempList(condition: 0, temp: 36.7, date: Date()),
                        TempList(condition: 0, temp: 36.3, date: Date()),
                        TempList(condition: 0, temp: 36.5, date: Date())]
        let lastWeek = Date().getLastWeek()
        
        ContentView(
            users: .constant([Users(
                name: "TEST",
                normalTemp: 36.5,
                tempList: tempList,
                chartTemp: tempList.forChart(lastWeek: lastWeek),
                allDate: [Date]())]),
            normalTemp: .constant(36.5),
            safearea: .constant(48),
            lastWeek: Date().getLastWeek())
    }
}
