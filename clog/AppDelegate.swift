import UIKit
import CoreData
import BackgroundTasks
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        
        UNUserNotificationCenter.current().delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.protectedDataWillBecomeUnavailableNotification, object: nil)
        
//        let surveyResults = fetchRecordsForEntity("Questionnaire")
//        if surveyResults.count > 0 {
//            let dateCompleted = surveyResults.last?.value(forKey: "date")
//            if Calendar.current.isDateInToday(dateCompleted as! Date){
//
//            }
//
//        }else{
//            scheduleNotification()
//        }
        
        return true
    }
    
    private func fetchRecordsForEntity(_ entity: String) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        var result = [NSManagedObject]()

        do {
            let records = try persistentContainer.viewContext.fetch(fetchRequest)

            if let records = records as? [NSManagedObject] {
                result = records
            }

        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }

        return result
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    

    // MARK: - Core Data stack

//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "clog")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "myDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    @objc private func applicationDidBecomeActive(notification: NSNotification) {
        print("ACTIVE")
        let entity =
            NSEntityDescription.entity(forEntityName: "Activation", in: persistentContainer.viewContext)!
        let activation = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext)

        let date = NSDate()
        activation.setValue(date, forKeyPath: "date")
        activation.setValue(false, forKeyPath: "push")
        
        saveContext()
        
    }
//    @objc func applicationDidEnterBackground(notification: NSNotification) {
//        print("BACKGROUND")
//    }

}

//extension AppDelegate: UNUserNotificationCenterDelegate{
//
//  // This function will be called right after user tap on the notification
//  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//    let storyboard = UIStoryboard(name: "Home", bundle: nil)
//
//    // instantiate the view controller from storyboard
//    if  let surveyVC = storyboard.instantiateViewController(withIdentifier: "surveyHomeVC") as? HomeViewController {
//
//        // set the view controller as root
//        self.window?.rootViewController = surveyVC
//        window?.makeKeyAndVisible()
//    }
//    // tell the app that we have finished processing the user???s action / response
//    completionHandler()
//  }
//}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
  // This function will be called right after user tap on the notification
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    print("push notification delegate")
    
//        guard var rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
//            return
//        }
//
//        let storyboard = UIStoryboard(name: "Home", bundle: nil)
//
//        // instantiate the view controller from storyboard
//        if  let surveyVC = storyboard.instantiateViewController(withIdentifier: "surveyHomeVC") as? HomeViewController {
//            rootViewController = surveyVC
//            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.makeKeyAndVisible()
//        }
    
    let entity =
        NSEntityDescription.entity(forEntityName: "Activation", in: persistentContainer.viewContext)!
    let activation = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext)

    let date = NSDate()
    activation.setValue(date, forKeyPath: "date")
    activation.setValue(true, forKeyPath: "push")
    saveContext()
    // tell the app that we have finished processing the user???s action / response
    completionHandler()
  }
}

