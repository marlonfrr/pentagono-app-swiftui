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
            //            if viewRouter.currentPage == 0 {
            //                CollectionView()
            //            } else if viewRouter.currentPage == 1 {
            //                Guardar()
            //            } else
            if viewRouter.logged {
                Appointments(viewRouter: viewRouter)
                .environment(\.managedObjectContext, managedObjectContext)
            } else {
                Login(viewRouter: viewRouter)
            }
            
            
            //            viewRouter.currentPage == 0?CollectionView() : Guardar()
            
            //            Spacer()
            //            Picker (selection: $viewRouter.currentPage, label: Text("")){
            //                Image(systemName: "folder.fill").tag(0)
            //                Image(systemName: "arrow.up.doc").tag(1)
            //                //   Image(systemName: "pencil").tag(2)
            //
            //            }.pickerStyle(SegmentedPickerStyle())
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())
    }
}
