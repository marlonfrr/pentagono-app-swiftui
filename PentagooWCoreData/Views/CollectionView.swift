//
//  CollectionView.swift
//  Pentagono CoreData
//
//  Created by Juan Arengo on 4/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import SwiftUI

struct CollectionView: View {
    
    @FetchRequest(entity: Ejercicios.entity(), sortDescriptors :[
        NSSortDescriptor(keyPath: \Ejercicios.nombre, ascending: true)
    ])var ejercicios : FetchedResults<Ejercicios>
    @ObservedObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack{
            HStack{
                 Spacer()
            Text("Imagenes guardadas").font(.largeTitle)
            Spacer()
            }
            ScrollView(.horizontal, showsIndicators: true){
                HStack{
                    ForEach(self.ejercicios){ ejercicio in
                        if  UIImage(data: ejercicio.imagen) != nil {
                        self.Print("EJE",ejercicio.imagen)
                        }
                        if  UIImage(data: ejercicio.imagen) != nil {
                                            
                        VStack{
                            
                            Spacer()
                            Image(uiImage : UIImage(data: ejercicio.imagen)!)
                                .resizable()
                                .frame(width: 300, height: 500).cornerRadius(20).padding(10).shadow(radius: 20)
                            Spacer()
                          
                        }
                        }
                        
                    }
                }
            }
        
        }.navigationBarItems(trailing: Button(action:{
            self.viewRouter.currentPage = 2
        }){
            Text("Guardar")
        })
}

}
extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}
struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(viewRouter: ViewRouter())
    }
}


