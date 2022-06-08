//
//  DefaultIcon.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2022/06/07.
//

import SwiftUI

struct DefaultIcon: View {
    let systemName: String
    var body: some View {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .black))
                .foregroundColor(Color(.secondaryLabel))
    }
}

struct DefaultIcon_Previews: PreviewProvider {
    static var previews: some View {
        DefaultIcon(systemName: "chevron.up")
    }
}
