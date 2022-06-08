//
//  Dashboard.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2022/06/07.
//

import SwiftUI

struct Dashboard: View {
    @Binding var tempList: [TempList]
    @Binding var chartTemp: [Double]
    var lastWeek: [Date]
    @State var graphSelection = 0
    @State var graphTypeLabel = String.init(localized: "daily")
    
    var body: some View {
        ScrollView {
            if tempList.count == 0 {
                VStack(alignment: .center) {
                    Text("no-data")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .foregroundColor(Color(.systemGray))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 70)
                }
            } else {
                VStack {
                    if chartTemp.count == 0 {
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
                                    Text(String(format: "%.1f\(degree)C", chartTemp[0]))
                                        .font(.system(size: 24, weight: .bold))
                                    Spacer()
                                    Text(lastWeek[0].formatDateToString(showDate: true, showTime: true))
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(.systemGray))
                                }
                                .padding(12)
                                
                                ZStack {
                                    Text("CHART HERE")
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
                    
                    ForEach(tempList, id: \.self) { tempItem in
                        ItemRow(
                            temp: "\(String(format: "%.1f", tempItem.temp)) \(degree)C",
                            condition: tempItem.condition,
                            date: tempItem.date.formatDateToString(showDate: true, showTime: true)
                        )
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

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard(
            tempList: .constant([TempList]()),
            chartTemp: .constant([Double]()),
            lastWeek: Date().getLastWeek()
        )
    }
}
