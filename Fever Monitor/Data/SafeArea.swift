//
//  SafeArea.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2022/06/07.
//
//https://stackoverflow.com/questions/26028918/how-to-determine-the-current-iphone-device-model

import UIKit

public extension UIDevice {

    static let safeAreaHeightForEachModels: CGFloat = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            print(identifier + String(UnicodeScalar(UInt8(value))))
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        //0 = Normal
        //1 = With Notch
        func mapToDevice(identifier: String) -> CGFloat { // swiftlint:disable:this cyclomatic_complexity
            switch identifier {
            case "iPod9,1"                  //iPod touch (7th generation)
                ,"iPhone8,1"                //iPhone 6s
                ,"iPhone8,2"                //iPhone 6s Plus
                ,"iPhone9,1", "iPhone9,3"   //iPhone 7
                ,"iPhone9,2", "iPhone9,4"   //iPhone 7 Plus
                ,"iPhone10,1", "iPhone10,4" //iPhone 8
                ,"iPhone10,2", "iPhone10,5" //iPhone 8 Plus
                ,"iPhone8,4"                //iPhone SE
                ,"iPhone12,8"               //iPhone SE (2nd generation)
                ,"iPhone14,6"               //iPhone SE (3rd generation)
                : return 7
                
            case "iPhone10,3", "iPhone10,6" //iPhone X"
                ,"iPhone11,2"               //iPhone XS"
                ,"iPhone11,4", "iPhone11,6" //iPhone XS Max"
                ,"iPhone11,8"               //iPhone XR"
                ,"iPhone12,1"               //iPhone 11"
                ,"iPhone12,3"               //iPhone 11 Pro"
                ,"iPhone12,5"               //iPhone 11 Pro Max"
                ,"iPhone13,1"               //iPhone 12 mini"
                ,"iPhone13,2"               //iPhone 12"
                ,"iPhone13,3"               //iPhone 12 Pro"
                ,"iPhone13,4"               //iPhone 12 Pro Max"
                ,"iPhone14,4"               //iPhone 13 mini"
                ,"iPhone14,5"               //iPhone 13"
                ,"iPhone14,2"               //iPhone 13 Pro"
                ,"iPhone14,3"               //iPhone 13 Pro Max"
                
                : return 48
            default
                : return 7
            }
        }

        return mapToDevice(identifier: identifier)
    }()

}

