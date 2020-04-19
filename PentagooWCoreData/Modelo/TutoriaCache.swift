//
//  TutoriaCache.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 18/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import Foundation
import CoreData

class TutoriaCache: NSManagedObject, Identifiable {
    @NSManaged public var id : String
    @NSManaged public var subject : String
    @NSManaged public var tutor : String
    @NSManaged public var time : String
}
