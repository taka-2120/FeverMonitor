//
//  Attributes.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2020/08/19.
//

import SwiftUI

struct Attributes: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                AttributedURL()
            }
            .frame(alignment: .center)
            
            Spacer()
        }
        .padding()
        .navigationTitle("credits")
    }
}

struct AttributedURL: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UITextView {
        let attribute = "Icons made by Freepik from www.flaticon.com"
        
        let label = UITextView()
        
        let attributedString = NSMutableAttributedString(string: attribute)
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: attribute.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: attribute.count))
        
        attributedString.addAttribute(.link,
                                      value: "https://www.flaticon.com/authors/freepik",
                                      range: NSString(string: attribute).range(of: "Freepik"))
        attributedString.addAttribute(.link,
                                      value: "https://www.flaticon.com/",
                                      range: NSString(string: attribute).range(of: "www.flaticon.com"))
        label.attributedText = attributedString
        label.isSelectable = true
        label.isEditable = false
        label.delegate = context.coordinator
        
        return label
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            UIApplication.shared.open(URL)
            return false
        }
    }
}
