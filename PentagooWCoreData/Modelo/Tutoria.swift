//
//  Tutoria.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 18/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import Foundation

struct Tutoria : Identifiable {
    var id: String
    var idMonitor: String
    var idEstudiante: String
    var materia: String
    var tema: String
    var rating: Int16
    var comentario: String
    var cancelada: Bool
    var asistio: Bool
    var fechaFin: Double
    var fechaInicio: Double
}
