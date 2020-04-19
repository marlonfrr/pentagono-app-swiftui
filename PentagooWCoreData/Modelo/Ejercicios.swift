//
//  Ejercicios.swift
//  Pentagono CoreData
//
//  Created by Juan Arengo on 4/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import Foundation
import CoreData

class Ejercicios: NSManagedObject, Identifiable{
      @NSManaged public var nombre : String
      @NSManaged public var imagen : Data
      @NSManaged public var materia : String
      @NSManaged public var descripcion : String
    
}


