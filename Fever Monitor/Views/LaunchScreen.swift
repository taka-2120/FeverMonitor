//
//  LaunchScreen.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2022/06/08.
//

import SwiftUI

struct LaunchScreen: View {
    @State var isLoading = true
    
    var body: some View {
        if isLoading {
            ZStack {
                gradient
                Image("Temperature")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 256, height: 256)
            }
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        isLoading = false
                    }
                }
            }
        } else {
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
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
