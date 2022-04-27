//
//  ChartView.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2021/10/02.
//

import SwiftUI

struct Point {
    let x: CGFloat //Date or Time
    let y: CGFloat //Temp
}

let weeklyData: [Point] = [.init(x: 0, y: 36.5),
                           .init(x: 1, y: 36.7),
                           .init(x: 2, y: 36.4),
                           .init(x: 3, y: 36.8),
                           .init(x: 4, y: 36.6),
                           .init(x: 5, y: 37.5),
                           .init(x: 6, y: 36.2)] //TEST

struct LinerChart: View {
    @State var gridWidth: CGFloat = 0
    let data: [ChartList]
    
    let lineRadius: CGFloat = 0.4
    let xStepValue: CGFloat = 100
    let yStepValue: CGFloat = 100
    
    var minYValue: CGFloat {
        var value = data.min { $0.temp < $1.temp }?.temp ?? 0
        if data.count == 1 {
            value += 0.5
        }
        return value
    }
        
    var maxYValue: CGFloat {
        var value = data.max { $0.temp < $1.temp }?.temp ?? 0
        if data.count == 1 {
            value -= 0.5
        }
        return value
    }
    
    var minXValue: CGFloat {
        data.min { $0.x < $1.x }?.x ?? 0
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                //Left Vertical Label (Only Top and Bottom)
                VStack(spacing: 0) {
                    Text(String(format: "%.1f\(degree)C", maxYValue))
                        .font(.system(size: 9))
                        .foregroundColor(Color(.secondaryLabel))
                    Spacer()
                    Text(String(format: "%.1f\(degree)C", minYValue))
                        .font(.system(size: 9))
                        .foregroundColor(Color(.secondaryLabel))
                }
                .padding(.horizontal, 5)
                .padding(.bottom, 5)
                
                //Main Graph
                GeometryReader { geo in
                    drawGrid(thickness: 1)
                        .overlay(drawBackground().opacity(0.7))
                        .overlay(drawLine())
                        .overlay(drawDot())
                        .onAppear(){
                            gridWidth = geo.size.width / 6
                        }
                        .padding(.trailing, 15)
                }
            }
            
            //Bottom Horizontal Label (7 Items)
            HStack(spacing: 0) {
                ForEach((2...6).reversed(), id: \.self) { i in
                    Text(getDayOfWeek(date: Calendar.current.date(byAdding: .day, value: -i, to: Date())!))
                        .frame(maxWidth: gridWidth)
                        .font(.system(size: 9))
                        .foregroundColor(Color(.secondaryLabel))
                }
                Text("yesterday")
                    .frame(maxWidth: gridWidth+5)
                    .font(.system(size: 9))
                    .foregroundColor(Color(.secondaryLabel))
                Text("today")
                    .frame(maxWidth: gridWidth)
                    .font(.system(size: 9))
                    .foregroundColor(Color(.secondaryLabel))
            }
            .padding(.leading, 25)
            .padding(.bottom, 5)
        }
    }
    
    // MARK: - In Graph
    
    //Common Function
    func drawPath(path: Path, geo: GeometryProxy) -> Path {
        var new_path: Path = path
        var previousPoint = Point(x: minXValue, y: yValue(height: geo.size.height, y: 0))
        let lastIndex = data.count-1
        
        data.reversed().forEach { point in
            
            let x = (point.x / 6) * geo.size.width
            
            if point.x == data[lastIndex].x {
                //If this is the last item...
                new_path.move(to: .init(x: x, y: yValue(height: geo.size.height, y: minYValue)))
                new_path.addLine(to: CGPoint(x: x, y: yValue(height: geo.size.height, y: point.temp)))
                
                previousPoint = Point(x: x, y: yValue(height: geo.size.height, y: point.temp))
            } else {
                let y = yValue(height: geo.size.height, y: point.temp)
                let deltaX = x - previousPoint.x
                let curveXOffset = deltaX * lineRadius
                
                //Draw Line
                new_path.addCurve(to: .init(x: x, y: y),
                              control1: .init(x: previousPoint.x + curveXOffset, y: previousPoint.y),
                              control2: .init(x: x - curveXOffset, y: y ))
                
                previousPoint = .init(x: x, y: y)
            }
        }
        new_path.addLine(to: CGPoint(x: (data[0].x / 6) * geo.size.width, y: yValue(height: geo.size.height, y: minYValue)))
        new_path.closeSubpath()
        
        return new_path
    }
    
    //Grid Line
    func drawGrid(thickness: CGFloat) -> some View {
        VStack(spacing: 0) {
            //Top Bar
            Color.gray.frame(height: thickness, alignment: .center)
            
            //Vertical Bar (6 Lines)
            HStack(spacing: 0) {
                ForEach(0 ..< 6) { i in
                    Color.gray.frame(width: thickness, alignment: .center)
                    Spacer()
                }
                
                Color.gray.frame(width: thickness, alignment: .center)
            }
            
            //Bottom Bar
            Color.gray.frame(height: thickness, alignment: .center)
        }
    }
    
    //Gradient
    func drawBackground() -> some View {
        LinearGradient(gradient: Gradient(colors: [Color(hex: "fc76b3"), Color.white.opacity(0.0)]), startPoint: .top, endPoint: .bottom)
            .mask (
                GeometryReader { geo in
                    if data.count != 1 {
                        Path { path in
                            path = drawPath(path: path, geo: geo)
                        }
                    }
                }
            )
    }
    
    //Line
    func drawLine() -> some View {
        GeometryReader { geo in
            if data.count != 1 {
                Path { path in
                    path = drawPath(path: path, geo: geo)
                }
                .stroke(Color.pink, lineWidth: 2)
            }
        }
    }
    
    //Dot
    func drawDot() -> some View {
        GeometryReader { geo in
            Path { path in
                data.forEach { point in
                    let x = (point.x / 6) * geo.size.width
                    let y = yValue(height: geo.size.height, y: point.temp)
                    
                    path.addEllipse(in: CGRect(x: x-5, y: y-5, width: 10, height: 10))
                }
            }
            .fill(.white, strokeContent: .pink, strokeStyle: StrokeStyle(lineWidth: 2))
        }
    }
    
    //Convert y axis value depending on device height or its value
    func yValue(height: CGFloat, y: CGFloat) -> CGFloat {
        if data.count == 1 {
            return (height/2)
        } else {
            return (height - ((y - minYValue) / (maxYValue - minYValue)) * height)
        }
    }
    
    //Get day of week
    func getDayOfWeek(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
}
