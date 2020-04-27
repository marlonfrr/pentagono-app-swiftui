
//
//  Guardar.swift
//  Pentagono CoreData
//
//  Created by Juan Arengo on 4/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import SwiftUI

struct Guardar: View {
    @Environment(\.managedObjectContext) var contexto
    @ObservedObject var viewRouter: ViewRouter
    @State private var imageData : Data = .init(capacity: 0)
    @State private var mostrarMenu = false
    @State private var imagePicker = false
    @State private var source : UIImagePickerController.SourceType = .camera
    
    
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: ImagePicker(show: self.$imagePicker, image: self.$imageData, source: self.source), isActive: self.$imagePicker){
                    Text("")
                }.navigationBarTitle("").navigationBarHidden(true)
                if self.imageData.count != 0{
                    Image(uiImage: UIImage(data: self.imageData)!).resizable().frame(width: 250, height: 250)
                }
                
                Button(action: {
                    self.mostrarMenu.toggle()
                }){
                    HStack {
                        Image(systemName: "photo").foregroundColor(.white)
                        Text("Añadir imagen").font(.headline).foregroundColor(.white)
                    }.padding(.all)
                }.background(Color.gray)
                    .cornerRadius(20).actionSheet(isPresented: self.$mostrarMenu){
                        ActionSheet(title: Text("Menu"), message: Text("Seleccionar opcion"), buttons: [.default(Text("Camara"), action:{
                            self.source = .camera
                            self.imagePicker.toggle()
                            
                        }    ),.default(Text("Galeria de fotos"), action:{
                            self.source = .photoLibrary
                            self.imagePicker.toggle()
                            
                        }    ),.default(Text("Cancelar") )
                        ])
                }
                Button(action:{
                    let nuevoEjercicio = Ejercicios(context: self.contexto)
                    nuevoEjercicio.descripcion = "Pa resolver"
                    nuevoEjercicio.nombre = "ejercicio vecto"
                    
                    nuevoEjercicio.imagen = self.imageData
                    do{
                        try self.contexto.save()
                        print("SE GUARDOOO")
                    } catch let error as NSError{
                        print("AAAAAAAa al guardar", error.localizedDescription)
                        
                    }
                }){
                    HStack {
                        Image(systemName: "folder.fill").foregroundColor(.white)
                        Text("Guardar en la BD").font(.headline).foregroundColor(.white)
                    }.padding(.all)
                        .background(Color.black)
                        .cornerRadius(20)
                    
                }
                Spacer()
                Picker (selection: $viewRouter.currentPage, label: Text("")){
                                Image(systemName: "folder.fill").tag(0)
                                Image(systemName: "arrow.up.doc").tag(1)
                                //   Image(systemName: "pencil").tag(2)
                
                            }.pickerStyle(SegmentedPickerStyle())
            }
        }
    }
    func persistir(){
        let nuevoEjercicio = Ejercicios(context: self.contexto)
        nuevoEjercicio.descripcion = "Pa resolver"
        nuevoEjercicio.nombre = "ejercicio vecto"
        
        nuevoEjercicio.imagen = self.imageData
        do{
            try self.contexto.save()
            print("SE GUARDOOO")
        } catch let error as NSError{
            print("AAAAAAAa al guardar", error.localizedDescription)
            
        }
    }
}

struct Guardar_Previews: PreviewProvider {
    static var previews: some View {
        Guardar(viewRouter: ViewRouter())
    }
}





