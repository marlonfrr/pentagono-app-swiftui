//
//  Login.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 17/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import SwiftUI
import Firebase
import Network

struct Login: View {
    @ObservedObject var viewRouter: ViewRouter
    
    @State var email = "pentagono.moviles@gmail.com"
    @State var password = ""
    @State var alertMessage = "Something went wrong"
    @State var isLoading = false
    @State var isSuccessful = false
    @State var showAlert = false
    
    func login() {
        self.isLoading = true
        let hola = ReachabilityHandlerR().isConnectedToNetwork()
        if(hola){
            print("Tienes conexión a internet")
        } else {
            print("No tienes conexión a internet")
            self.showAlert = true
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print("Hola")
                print(error!)
            } else {
                print("Adiís")
                print(result!)
                self.viewRouter.logged = true
                UserDefaults.standard.set(true, forKey: "logged")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 18){
                
                Image("penta").resizable().frame(width: 120, height: 120)
                Spacer()
                TextField("Correo electrónico", text: $email).textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Contraseña", text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
                //                NavigationLink(destination: Guardar()) {
                Button(action: {
                    self.login()
                }) {
                    Text("Iniciar sesión")
                }
                Spacer()
            }.navigationBarTitle("Bienvenido a Pentágono", displayMode: .large).padding(.all).alert(isPresented: $showAlert) {
                Alert(title: Text("No tienes internet"), message: Text("No tienes internet, inténtalo de nuevo"), dismissButton: .default(Text("Got it!")))
            }
        }.onAppear{
            if UserDefaults.standard.object(forKey: "logged") != nil {
                self.viewRouter.logged = true
            }
        }
    }
    struct Login_Previews: PreviewProvider {
        static var previews: some View {
            Login(viewRouter: ViewRouter())
        }
    }
}
