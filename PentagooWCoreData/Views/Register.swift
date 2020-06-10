//
//  Register.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 9/06/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import SwiftUI
import Firebase

struct Register: View {
    
    @State var nombre = ""
    @State var apellidos = ""
    @State var email = ""
    @State var password = ""
    @State var showAlert = false
    
    @ObservedObject var viewRouter: ViewRouter
    
    @Environment(\.presentationMode) var back
    
    func register(){
        let conectado = ReachabilityHandlerR().isConnectedToNetwork()
        if(conectado){
            print("Tienes conexión a internet")
        } else {
            print("No tienes conexión a internet")
            self.showAlert = true
            return
        }
        Auth.auth().createUser(withEmail: self.email, password: self.password, completion: { (result, error) in
            if error != nil {
                print("Error")
                print(error!)
            } else {
                print("Adiós")
                let change = Auth.auth().currentUser?.createProfileChangeRequest();
                change?.displayName = self.nombre + " " + self.apellidos;
                change?.commitChanges { (error) in
                }
                print(result!)
                // Devolverse
                self.back.wrappedValue.dismiss()
            }
        })
        
//        Auth.auth().signIn(withEmail: <#T##String#>, link: <#T##String#>, completion: <#T##AuthDataResultCallback?##AuthDataResultCallback?##(AuthDataResult?, Error?) -> Void#>)
//        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//            if error != nil {
//                print("Error")
//                print(error!)
//            } else {
//                print("Adiós")
//                print(result!)
//                self.viewRouter.logged = true
//                UserDefaults.standard.set(true, forKey: "logged")
//            }
//        }
    }
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 18){
                
//                Image("penta").resizable().frame(width: 120, height: 120)
//                Spacer()
                TextField("Nombres", text: $nombre).textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Apellidos", text: $apellidos).textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Email", text: $email).textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Contraseña", text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
                //                NavigationLink(destination: Guardar()) {
                Button(action: {
                    self.register()
                }) {
                    Text("Aceptar")
                }
                Spacer()
            }.navigationBarTitle("Regístrate", displayMode: .large).padding(.all).alert(isPresented: $showAlert) {
                Alert(title: Text("No tienes internet"), message: Text("No tienes internet, inténtalo de nuevo"), dismissButton: .default(Text("Got it!")))
            }
        }
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register(viewRouter: ViewRouter())
    }
}
