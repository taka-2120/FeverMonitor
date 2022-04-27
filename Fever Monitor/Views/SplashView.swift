//
//  SplashView.swift
//  Fever Monitor
//
//  Created by Yu Takahashi on 2022/04/15.
//

import SwiftUI
import HealthKit

struct SplashView: View {
    
    let healthStore = HKHealthStore()
    @State var isLoading = true
    @State var firstSheet = false
    
    @State var normalTemp = 0.0
    @State var safearea: CGFloat = 0.0
    //Date
    @State var last7Days = [Date]()
    //Users
    @State var users = [Users]()
    
    var body: some View {
        if isLoading {
            ZStack(alignment: .center) {
                Color("MainColor")
                
                Image("Temperature")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 256, height: 256)
            }
            .ignoresSafeArea()
            .onAppear(perform: loading)
            .fullScreenCover(isPresented: $firstSheet, onDismiss: loading) {
                FirstSettings(users: $users)
            }
        } else {
            ContentView(normalTemp: $normalTemp, safearea: $safearea, last7Days: $last7Days, users: $users)
        }
    }
    
    func loading() {
        safearea = UIDevice.safeAreaHeightForEachModels
        print(safearea)
        
        let firstLaunch = UserDefaults.standard.string(forKey: firstLaunchKey)
        
        if firstLaunch == nil || firstLaunch == "true" {
            firstSheet = true
            return
        }
        
        getLast7Days()
        
        restoreUserData()
        
        syncHK()
    }
    
    //Get days for past a week
    func getLast7Days() {
        for i in 0 ... 7 {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current
            
            let _last7Days = calendar.date(byAdding: .day, value: -i, to: Date())!
            last7Days.append(_last7Days)
        }
    }
    
    //Resore (Store is in Models.swift)
    func restoreUserData() {
        if let data = UserDefaults.standard.data(forKey: userDataKey) {
            do {
                let decoder = JSONDecoder()
                users = try decoder.decode([Users].self, from: data)
            } catch {
                users.append(Users(name: "Error", normalTemp: 36.5, tempList: [], chartList: [], allDate: []))//For Primary User
                print("Unable to Decode User Data")
                //IDEA: Unable to load -> Show First Sheet Again??
            }
        }
    }
    
    func getAllDate() {
        for usersIndex in 0 ..< users.count {
            var allDate = [Date]()
            
            for tempIndex in 0 ..< users[usersIndex].tempList.count {
                
                let date = users[usersIndex].tempList[tempIndex].date
                
                if allDate.contains(date) == false {
                    allDate.append(date)
                }
            }
            users[usersIndex].allDate = allDate
        }
    }
    
    //Get Data from HK
    func syncHK() {
        var tempSamples = [HKSample]()
        var _tempList: [TempList] = []
        
        if HKHealthStore.isHealthDataAvailable() {
            
            let temperatureSampleQuery = HKSampleQuery(sampleType: HKSampleType.quantityType(forIdentifier: .bodyTemperature)!, predicate: nil, limit: -1, sortDescriptors: [NSSortDescriptor (key: HKSampleSortIdentifierStartDate, ascending: false)]) { (query, results, error) in
                if let samples = results {
                    var countX = 0
                    
                    DispatchQueue.main.async {
                        for sample in samples {
                            tempSamples.append(sample)
                            
                            let quantitySample = sample as! HKQuantitySample
                            let date = sample.startDate
                            let temperature = quantitySample.quantity.doubleValue(for: .degreeCelsius())
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateStyle = .short
                            dateFormatter.timeStyle = .short
                            
                            _tempList.append(TempList(condition: determineCondition(normalTemp: users[0].normalTemp, temp: temperature), temp: CGFloat(temperature), date: date))
                            
                            if samples.count - 1 == countX {
                                users[0].tempList = _tempList
                            }
                            
                            countX = countX + 1
                        }
                        users[0].chartList = convertForChart(tempList: _tempList, last7Days: last7Days)
                        
                        getAllDate()
                        
                        isLoading = false
                    }
                }
            }
            
            healthStore.execute(temperatureSampleQuery)
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
