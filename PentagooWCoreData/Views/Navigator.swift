//
//  Navigator.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 24/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import Foundation
import SwiftUI

struct Navigator: View {
    @ObservedObject var viewRouter: ViewRouter
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        //        NavigationView{
        TabView{
            Home(viewRouter: viewRouter).environment(\.managedObjectContext, managedObjectContext).tabItem{Image(systemName: "house")
                Text("Home")}
            //                ExerciseViewer().tabItem{Image(systemName: "pencil")
            //                Text("Ejercicios")}
            ExercisesCollection().tabItem{Image(systemName: "pencil")
                Text("Ejercicios")}
            Profile(viewRouter: ViewRouter()).tabItem{Image(systemName: "person")
                Text("Perfil")}
        }
    }
}

struct Navigator_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

