import HealthKit

class HealthKitSetupAssistant {
  
  private enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
  }
  
  class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
    guard HKHealthStore.isHealthDataAvailable() else {
      completion(false, HealthkitSetupError.notAvailableOnDevice)
      return
    }
    //2. Prepare the data types that will interact with HealthKit
    guard   let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount)  else {
            
            completion(false, HealthkitSetupError.dataTypeNotAvailable)
            return
    }

    //3. Prepare a list of types you want HealthKit to read and write
    let healthKitTypesToWrite: Set<HKSampleType> = []
        
    let healthKitTypesToRead: Set<HKObjectType> = [stepCount]
    
    HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)

    //4. Request Authorization
    HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                         read: healthKitTypesToRead) { (success, error) in
      completion(success, error)
    }

  }
}
