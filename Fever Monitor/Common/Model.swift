//
//  Model.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2020/12/26.
//

import SwiftUI
import HealthKit


// MARK: - Lists

//0 is Primary User
struct Users: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var name: String
    var normalTemp: Double
    var tempList: [TempList]        //0 is LATEST!!
    var chartList: [ChartList]
    var allDate: [Date]
}

struct TempList: Identifiable, Hashable, Codable{
    var id = UUID()
    //0->Normal, 1->Slight, 2->Severe
    var condition: Int
    
    var temp: CGFloat
    var date: Date
}

struct ChartList: Identifiable, Hashable, Codable {
    var id = UUID()
    var x: CGFloat
    var temp: CGFloat
    var date: Date
    var multi: Bool
}


// MARK: - Variables

let gradient = LinearGradient(gradient: Gradient(colors: [Color("Header_Gradient_Start"), Color("Header_Gradient_End")]), startPoint: .topLeading, endPoint: .bottomTrailing)

//Degree Symbol
let degree = NSString(format: "%@", "\u{00B0}") as String

//Data Keys
let userDataKey = "userData"
let firstLaunchKey = "firstLaunch"

//Notif Keys
let sunKey = "notification-fever-monitor-sunday"
let monKey = "notification-fever-monitor-monday"
let tueKey = "notification-fever-monitor-tuesday"
let wedKey = "notification-fever-monitor-wednesday"
let thuKey = "notification-fever-monitor-thursday"
let friKey = "notification-fever-monitor-friday"
let satKey = "notification-fever-monitor-saturday"

//Toggle Keys
let sunTogKey = "sunday-toggle"
let monTogKey = "monday-toggle"
let tueTogKey = "tuesday-toggle"
let wedTogKey = "wednesday-toggle"
let thuTogKey = "thursday-toggle"
let friTogKey = "friday-toggle"
let satTogKey = "saturday-toggle"
let eveTogKey = "everyday-toggle"

//Time Keys
let sunTimeKey = "sunday-set-time"
let monTimeKey = "monday-set-time"
let tueTimeKey = "tuesday-set-time"
let wedTimeKey = "wednesday-set-time"
let thuTimeKey = "thursday-set-time"
let friTimeKey = "friday-set-time"
let satTimeKey = "saturday-set-time"
let eveTimeKey = "everyday-set-time"


// MARK: - Common View
struct DefaultIcon: View {
    let systemName: String
    var body: some View {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .black))
                .foregroundColor(Color(.secondaryLabel))
    }
}


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


//MARK: - Common Functions

//Store (Restore is in ContentView.swift)
func storeUserData(users: [Users]) {
    do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(users)
        UserDefaults.standard.set(data, forKey: userDataKey)
    } catch {
        print("Unable to Encode User Data")
    }
}

func isSafeTemp(temp: Double) -> Bool {
    if temp > 44.0 || temp < 32.0 {
        return false
    } else {
        return true
    }
}

func filterDate(tempList: [TempList], date: String) -> [TempList] {
    var new = [TempList]()
    for i in 0 ..< tempList.count {
        if date == dateToString(date: true, time: false).string(from: tempList[i].date) {
            new.append(tempList[i])
        }
    }
    return new
}

func updateNormalTemp(users: [Users], currentIndex: Int, normalTemp: Double) -> [TempList] {
    var tempList = users[currentIndex].tempList
    
    for i in 0 ..< tempList.count {
        tempList[i].condition = determineCondition(normalTemp: normalTemp, temp: tempList[i].temp)
    }
    
    return tempList
}

func tempLabel(value: Double) -> String {
    return "\(String(format: "%.1f", value)) \(degree)C"
}

func hapticReaction() {
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    impactMed.impactOccurred()
}

func dateToString(date: Bool, time: Bool) -> DateFormatter {
    let dateFormatter = DateFormatter()
    if date == true {
        dateFormatter.dateStyle = .medium
    }
    if time == true {
        dateFormatter.timeStyle = .short
    }
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = Locale(identifier: Locale.current.languageCode ?? "en-US")
    return dateFormatter
}

//Int to String
func conditionChecking(condition: Int) -> (text: String, color: Color) {
    if condition == 1 {
        return (text: "exclamationmark.triangle", color: Color(.systemYellow))
    } else if condition == 2 {
        return (text: "xmark.shield", color: Color(.systemRed))
    } else {
        return (text: "checkmark.circle", color: Color(.systemGreen))
    }
}

//Temp to Int
func determineCondition(normalTemp: Double, temp: Double) -> Int {
    var condition = 0
    
    if normalTemp + 1.0 < temp && temp <= normalTemp + 2.0 {
        condition = 1
    } else if temp > normalTemp + 2.0 {
        condition = 2
    }
    
    return condition
}

//Check wether same date
func determineDate(date: String, last7Days: [Date]) -> Bool {
    for i in 0 ... 6 {
        if dateToString(date: true, time: false).string(from: last7Days[i]) == date {
            return true
        }
    }
    return false
}

//Date to X
func getIndex(last7Days: [Date], date: String) -> CGFloat {
    //0 is Today, but 7th index of graph is Today
    for i in 0 ... 6 {
        if dateToString(date: true, time: false).string(from: last7Days[i]) == date {
            return CGFloat(6 - i)
        }
    }
    return -1
}

//Convert TempList into ChartList
func convertForChart(tempList: [TempList], last7Days: [Date]) -> [ChartList] {
    var chartList: [ChartList] = []
    
    if tempList.count != 0 {
        for i in 0 ... tempList.count - 1 {
            let date = dateToString(date: true, time: false).string(from: tempList[i].date)
            
            //Check this date is past a week
            if determineDate(date: date, last7Days: last7Days) == true {
                //If a temp of same date is already in the chart list...
                if tempList.filter({ dateToString(date: true, time: false).string(from: $0.date) == date }).count >= 2 {
                    if chartList.filter({ dateToString(date: true, time: false).string(from: $0.date) == date }).count == 0 {
                        let multiTemp: [TempList] = tempList.filter({ dateToString(date: true, time: false).string(from: $0.date) == date})
                        let x: CGFloat = getIndex(last7Days: last7Days, date: date)
                        
                        var tempAv: CGFloat = 0
                        for i in 0 ... multiTemp.count - 1 {
                            tempAv = tempAv + multiTemp[i].temp
                        }
                        
                        chartList.append(ChartList(x: x, temp: round(tempAv / CGFloat(multiTemp.count) * 10) / 10, date: tempList[i].date, multi: true))
                    }
                } else {
                    var x: CGFloat = 0
                    x = getIndex(last7Days: last7Days, date: date)
                    chartList.append(ChartList(x: x, temp: tempList[i].temp, date: tempList[i].date, multi: false))
                }
                
            }
        }
    }
    return chartList
}


//MARK: - Specific Corner Radius

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//MARK: - hex to Color

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

//MARK: - Text Limitation

class TempBoxModel: ObservableObject {
    var limitUpperDp: Int = 2
    var limitUnderDp: Int = 1
    var limitUnderDp_NT: Int = 1
    
    @Published var upperDp: String = "" {
        didSet {
            if upperDp.count > limitUpperDp {
                upperDp = String(upperDp.prefix(limitUpperDp))
            }
        }
    }
    
    @Published var underDp: String = "" {
        didSet {
            if underDp.count > limitUnderDp {
                underDp = String(underDp.prefix(limitUnderDp))
            }
        }
    }
    
    @Published var upperDp_NT: String = "" {
        didSet {
            if upperDp_NT.count > limitUnderDp_NT {
                upperDp_NT = String(upperDp_NT.prefix(limitUnderDp_NT))
            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct Background<Content: View>: View {
    private var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        Color(.clear)
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
        .overlay(content)
    }
}

//Shape Extension
extension Shape {
    
    //fills and strokes a shape
    public func fill<S:ShapeStyle>(
        _ fillContent: S,
        strokeContent: S,
        strokeStyle: StrokeStyle
    ) -> some View {
        ZStack {
            self.fill(fillContent)
            self.stroke(strokeContent, style: strokeStyle)
        }
    }
}
