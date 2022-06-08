//
//  Hideen.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2022/06/07.
//

import SwiftUI

// MARK: - Hidden Modifier

fileprivate struct HiddenModifier: ViewModifier {

    private let isHidden: Bool
    private let remove: Bool

    init(isHidden: Bool, remove: Bool) {
        self.isHidden = isHidden
        self.remove = remove
    }

    func body(content: Content) -> some View {
        VStack {
            if isHidden == true {
                if remove == true {
                    EmptyView()
                } else {
                    content.hidden()
                }
            } else {
                content
            }
        }
    }
}

extension View {
    func isHidden(_ hidden: Bool, remove: Bool) -> some View {
        modifier(HiddenModifier(isHidden: hidden, remove: remove))
    }
}
