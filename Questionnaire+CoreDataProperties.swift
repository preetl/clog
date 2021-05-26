//
//  Questionnaire+CoreDataProperties.swift
//  clog
//
//  Created by Preet Lalli on 26/05/2021.
//
//

import Foundation
import CoreData


extension Questionnaire {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Questionnaire> {
        return NSFetchRequest<Questionnaire>(entityName: "Questionnaire")
    }

    @NSManaged public var anxiety: Bool
    @NSManaged public var down: Bool
    @NSManaged public var interest: Bool
    @NSManaged public var phoneBed: Int16
    @NSManaged public var sleep: Int16
    @NSManaged public var sleepQuality: Int16
    @NSManaged public var worry: Bool
    @NSManaged public var date: Date?

}

extension Questionnaire : Identifiable {

}
