//
//  HowToUse.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2020/08/19.
//

import SwiftUI

struct HelpView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var sheet: Bool
    
    var body: some View {
        List {
            
            Section {
                VStack(alignment: .leading) {
                    QAItem(q: true, text: String.init(localized: "1st-q"))
                        .padding(.vertical, 8)
                    QAItem(q: false, text: String.init(localized: "1st-a"))
                        .padding(.bottom, 8)
                }
                
                NavigationLink("1st-add", destination: NormalTempHelp())
            }
            
            Section {
                VStack(alignment: .leading) {
                    QAItem(q: true, text: String.init(localized: "2nd-q"))
                        .padding(.vertical, 8)
                    QAItem(q: false, text: String.init(localized: "2nd-a"))
                        .padding(.bottom, 8)
                }
                
                NavigationLink("2nd-add", destination: MeasureTempHelp(sheet: $sheet))
            }
            
            Section {
                VStack(alignment: .leading) {
                    QAItem(q: true, text: String.init(localized: "3rd-q"))
                        .padding(.vertical, 8)
                    QAItem(q: false, text: String.init(localized: "3rd-a"))
                        .padding(.bottom, 8)
                }
                
                NavigationLink("3rd-add", destination: DeterminationHelp(sheet: $sheet))
            }
            
            Section {
                VStack(alignment: .leading) {
                    QAItem(q: true, text: String.init(localized: "4th-q"))
                        .padding(.vertical, 8)
                    QAItem(q: false, text: String.init(localized: "4th-a"))
                        .padding(.bottom, 8)
                    
                    Text("4th-note")
                        .font(.system(size: 13))
                        .foregroundColor(Color(.secondaryLabel))
                        .padding(.bottom, 8)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            Section {
                VStack(alignment: .leading) {
                    QAItem(q: true, text: String.init(localized: "5th-q"))
                        .padding(.vertical, 8)
                    QAItem(q: false, text: String.init(localized: "5th-a"))
                        .padding(.bottom, 8)
                }
            }
        }
        .font(.body)
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("help")
        .onDisappear() {
            sheet = false
        }
    }
}

struct QAItem: View {
    
    var q: Bool
    var text: String
    
    var body: some View {
        HStack {
            Text(q ? "Q" : "A")
                .font(q ? .title3 : .body)
                .fontWeight(q ? .bold : .regular)
                .frame(width: 15)
            
            Text(text)
                .font(q ? .title3 : .body)
                .fontWeight(q ? .bold : .regular)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
