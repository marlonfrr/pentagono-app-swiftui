//
//  Profile.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 24/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import SwiftUI
import Firebase

struct Profile: View {
    
    @State var name: String = Auth.auth().currentUser?.displayName ?? "Sin especificar"
    @State var lastname: String = "García"
    @State var major: String = "Seleccionar carrera..."
    @State var age: String = "Ingresar edad..."
    @State var isAlert: Bool = false
    @ObservedObject var viewRouter: ViewRouter
    
    var body: some View {
        
        VStack {
            Image("usericon").resizable().aspectRatio(contentMode: .fill).frame(width: 150, height: 150).clipped().cornerRadius(150)
            TextField("Nombre(s)", text: self.$name).disabled(true).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Seleccionar carrera", text: self.$major).disabled(true).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Ingresar edad", text: self.$age).disabled(true).textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
               if(!ReachabilityHandlerR().isConnectedToNetwork()){
                   print("No tienes conexión a internet, no se puede guardar la información");
                self.isAlert = true;
                   return;
               }
            }, label: {
                Text("Guardar información").foregroundColor(.white)
            }).padding(.all, 8).background(Color.green).cornerRadius(12)
            Spacer()
            Button(action: {
                DispatchQueue.global().async {
                    UserDefaults.standard.removeObject(forKey: "logged")
                    self.viewRouter.logged = false
                    try! Auth.auth().signOut()
                }
            }, label: {
                Text("Cerrar sesión").foregroundColor(.white)
            }).padding(.all, 8).background(Color.red).cornerRadius(12)
            }.padding(.all).alert(isPresented: self.$isAlert){
                Alert(title: Text("No tienes internet"), message: Text("No tienes internet para guardar los cambios"), dismissButton: .default(Text("Aceptar")))
            }
        
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(viewRouter: ViewRouter())
    }
}
