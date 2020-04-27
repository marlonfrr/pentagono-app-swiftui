//
//  ContentView.swift
//  Pentagono CoreData
//
//  Created by Juan Arengo on 4/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//
import SwiftUI


struct ContentView: View {
    @ObservedObject var viewRouter: ViewRouter
    @Environment(\.managedObjectContext) var managedObjectContext
    //    @ViewBuilder
    var body: some View {
        VStack{
            if viewRouter.logged {
                if viewRouter.currentPage == 2 {
                    Guardar(viewRouter: viewRouter).environment(\.managedObjectContext, managedObjectContext)
                } else {
                    Navigator(viewRouter: viewRouter).environment(\.managedObjectContext, managedObjectContext)
//                    Home(viewRouter: viewRouter)
//                        .environment(\.managedObjectContext, managedObjectContext)
                }
            } else {
                Login(viewRouter: viewRouter)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())
    }
}
