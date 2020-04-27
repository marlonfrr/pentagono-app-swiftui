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
    
    @State var name: String = "David"
    @State var lastname: String = "García"
    @State var major: String = "Ingeniería industrial"
    @State var age: String = "22"
    @ObservedObject var viewRouter: ViewRouter
    
    var body: some View {
        
        VStack {
            Image("usericon").resizable().aspectRatio(contentMode: .fill).frame(width: 150, height: 150).clipped().cornerRadius(150)
            TextField("Nombre(s)", text: self.$name).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Apellidos", text: self.$lastname).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Carrera", text: self.$major).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Edad", text: self.$age).textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                try! Auth.auth().signOut()
                self.viewRouter.logged = false
                UserDefaults.standard.removeObject(forKey: "logged")
            }, label: {
                Text("Cerrar sesión").foregroundColor(.white)
            }).padding(.all, 8).background(Color.red).cornerRadius(12)
            Spacer()
//            Button(action: {}, label: {
//                Text("Guardar").foregroundColor(.white)
//            }).padding(.all).background(Color.green).cornerRadius(20).padding(.bottom, 8)
        }.padding(.all)
        
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(viewRouter: ViewRouter())
    }
}
