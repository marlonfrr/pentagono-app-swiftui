//
//  ExercisesCollection.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 26/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import SwiftUI

struct ExercisesCollection: View {
    @ObservedObject private var pdfsModel = GetPdfs()
    @State var materia:String = "vectorial"
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Ingresa la materia para buscar ejercicios")
                TextField("vectorial, diferencial, etc", text: self.$materia).textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {self.pdfsModel.fetchPdfs(materia: self.materia)}, label: {Text("Buscar")})
                List{
                    ForEach(self.pdfsModel.pdfs, id: \.self){ pdf in
                        NavigationLink(destination: ExerciseViewer(url: pdf), label: {Text("Ejercicio")})
                    }
                }
            }.navigationBarTitle("Busca ejercicios").padding(.all)
        }
    }
}

struct ExercisesCollection_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesCollection()
    }
}
