//
//  ItemRow.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2022/06/07.
//

import SwiftUI

struct ItemRow: View {
    var temp: String
    var condition: Int
    var date: String
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: condition.convertCondition().text)
                    .foregroundColor(condition.convertCondition().color)
                    .frame(maxWidth: 20)
                Text(temp)
            }
            Spacer()
            Text(date)
        }
        .padding()
    }
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemRow(temp: "36.5", condition: 1, date: "6/5")
    }
}
