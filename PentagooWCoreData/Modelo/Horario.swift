//
//  Horario.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 25/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import Foundation

struct Horario : Identifiable {
    var id: String
    var codigo: Int
    var departamento: String
    var genero: String
    var dia: String
    var rango: String
    var disponible: Bool
    var nRatings: Int
    var ratingPromedio: Double
    var nombre: String
    var semestre: Int
}
