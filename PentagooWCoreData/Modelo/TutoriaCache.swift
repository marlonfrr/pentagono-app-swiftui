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
    @NSManaged var id: String
    @NSManaged var  idMonitor: String
    @NSManaged var  idEstudiante: String
    @NSManaged var  materia: String
    @NSManaged var  tema: String
    @NSManaged var  rating: Int16
    @NSManaged var  comentario: String
    @NSManaged var  cancelada: Bool
    @NSManaged var  asistio: Bool
    @NSManaged var  fechaFin: Double
    @NSManaged var  fechaInicio: Double
}
