//
//  HealthKitManage.swift
//  YiYangCloud
//
//  Created by zhong on 2017/4/27.
//  Copyright © 2017年 gary. All rights reserved.
//
import UIKit

class HealthKitManage: NSObject {
    
    var healthStore:HKHealthStore?
    
    static let shared = HealthKitManage()
    
    private override init() {}
    
    func authorizeHealthKit(result: ((_ success:Bool, _ error:NSError?) -> Void)!){
        if HKVersion >= 8.0 {
            if !HKHealthStore.isHealthDataAvailable() {
                let error = NSError.init(domain: "com.raywenderlich.tutorials.healthkit", code: 2, userInfo: [NSLocalizedDescriptionKey : "HealthKit is not available in th is Device"])
                result(false, error);
                return;
            }
            
            if HKHealthStore.isHealthDataAvailable() {
                if self.healthStore == nil {
                    self.healthStore = HKHealthStore.init()
                    let writeDataTypes = dataTypesToWrite()
                    let readDataTypes = dataTypesRead()
                    self.healthStore?.requestAuthorization(toShare: writeDataTypes, read: readDataTypes, completion: {(success, error) in
                        
                        result(success,error as NSError?)

                    })
                }
            }
        }else {
            let userInfo = [NSLocalizedDescriptionKey:"iOS 系统低于8.0"]
            let error =  NSError.init(domain: CustomHealthErrorDomain, code: 0, userInfo: userInfo)
            result(false,error);
        }
    }
    
    class func predicateForSamplesToday() -> NSPredicate{
        let calendar = NSCalendar.current
        let now = Date.init()
        var components = calendar.dateComponents(NSSet.init(objects: Calendar.Component.year,Calendar.Component.month,Calendar.Component.day) as! Set<Calendar.Component>, from: now)
        components.hour = 0
        components.minute = 0
        components.second = 0
        let startDate = calendar.date(from: components)
        let endDate = calendar.date(byAdding: Calendar.Component.day, value: 1, to: startDate!, wrappingComponents: false)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options:HKQueryOptions.init(rawValue: 0))
        return predicate
    }
}

//读写权限
extension HealthKitManage{
    //写权限
    func dataTypesToWrite() -> Set<HKSampleType> {
//        let heightType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)
//        let weightType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
//        let temperatureType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyTemperature)
//        let activeEnergyType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
        //NSSet.init(objects: heightType!,weightType!,temperatureType!,activeEnergyType!) as! Set<HKSampleType>
        return NSSet.init() as! Set<HKSampleType>
    }
    //读权限
    func dataTypesRead() -> Set<HKObjectType> {
//        let heightType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)
//        let weightType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
//        let temperatureType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyTemperature)
//        let birthdayType = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)
//        let sexType = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)
        let stepCountType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let distance = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
//        let activeEnergyType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)?
        //NSSet.init(objects: heightType!,weightType!,temperatureType!,activeEnergyType!,birthdayType!,sexType!,stepCountType!,distance!,activeEnergyType!) as! Set<HKObjectType>
        return NSSet.init(objects:stepCountType!,distance!) as! Set<HKObjectType>
    }
}

//读取数据
extension HealthKitManage{
    //读取步数
    func getStepCount(result:@escaping((_ value:Double,_ error:NSError?) -> Void)) {
        let stepType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let timeSortDescriptor = NSSortDescriptor.init(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: stepType!, predicate: HealthKitManage.predicateForSamplesToday(), limit: HKObjectQueryNoLimit, sortDescriptors: [timeSortDescriptor]) { (query, results, error) in
            if error != nil {
                result(0,error! as NSError)
            }else{
                var totleSteps = 0.0
                for quantitySample:HKQuantitySample in results as! [HKQuantitySample] {
                    
                    let quantity = quantitySample.quantity
                    let heightUnit = HKUnit.count()
                    let usersHeight = quantity.doubleValue(for: heightUnit)
                    totleSteps += usersHeight;
                }
                print("当天行走步数 = \(totleSteps)")
                result(totleSteps,error as NSError?)
                
            }
        }
        self.healthStore?.execute(query)
    }
    
    //读取步行+跑步距离
    func getDistance(result:@escaping((_ value:Double,_ error:NSError?) -> Void)){
        let distanceType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        let timeSortDescriptor = NSSortDescriptor.init(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery.init(sampleType: distanceType!, predicate: HealthKitManage.predicateForSamplesToday(), limit: HKObjectQueryNoLimit, sortDescriptors: [timeSortDescriptor]) { (query, results, error) in
            if error != nil{
                result(0,error as NSError?);
            }else{
                var totleSteps = 0.0
                for quantitySample:HKQuantitySample in results as! [HKQuantitySample] {
                    let quantity = quantitySample.quantity
                    let distanceUnit = HKUnit.meterUnit(with: .kilo)
                    let usersHeight = quantity.doubleValue(for: distanceUnit)
                    totleSteps += usersHeight
                }
                print("当天行走距离 = \(totleSteps)")
                result(totleSteps,error as NSError?)
            }
        }
        self.healthStore?.execute(query)
    }
}

