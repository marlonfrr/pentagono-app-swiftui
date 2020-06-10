//
//  NewAppointment.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 18/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import CoreData

struct NewAppointment: View {
    @State var materia = ""
    @State var topic = ""
    @State var rango = ""
    @State var tutor = ""
    @State var alertMessage = ""
    @State var isSuccessful = false
    @State var showAlert = false
    @State var selectedTutor: String = ""
    @State var nombreDia:String = ""
    
    // Alert
    @State var isAlert:Bool = false
    
    var materiasPosibles:[String] = ["Precalculo", "Calculo diferencial", "Calculo integral", "Matematica estructural", "Calculo vectorial"]
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var back
    @ObservedObject var viewRouter: ViewRouter
    @State var startDate:Date = Date()
    @State var horarios = [Horario]()
    
    func buscar() {
        if(!ReachabilityHandlerR().isConnectedToNetwork()){
            print("No tienes conexión a internet, no se puede buscar horarios");
            self.isAlert = true
            self.alertMessage = "No tienes conexión a internet, no se puede buscar horarios"
            return;
        }
        let formatter = DateFormatter()
        let formatterSend = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatterSend.dateFormat = "YYYY-MM-dd"
        let dayInWeek = formatter.string(from: self.startDate)
        var esp:String = ""
        switch dayInWeek {
        case "Monday":
            esp = "lunes"
        case "Tuesday":
            esp = "martes"
        case "Wednesday":
            esp = "miercoles"
        case "Thursday":
            esp = "jueves"
        case "Friday":
            esp = "viernes"
        default:
            esp = "lunes"
        }
        print(esp)
        self.nombreDia = esp
        self.horarios.removeAll()
        let db = Firestore.firestore()
        db.collection("monitores").whereField("horarios.\(esp).disponible", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let valor = document.data()
                        let id = document.documentID
                        let codigo = valor["codigo"] as? Int ?? 0
                        let departamento = valor["departamento"] as? String ?? "Sin departamento"
                        let genero = valor["genero"] as? String ?? "Sin genero"
                        let dia = esp
                        let disponible = true
                        let nRatings = valor["nRatings"] as? Int ?? 0
                        let ratingPromedio = valor["ratingPromedio"] as? Double ?? 0.0
                        let nombre = valor["nombre"] as? String ?? "Sin nombre"
                        let semestre = valor["semestre"] as? Int ?? 0
                        if let horarios = valor["horarios"] as? [String:Any]{
                            if let diaE = horarios[esp] as? [String:Any]{
                                if let rango1 = diaE["rango"] as? [String:Any]{
                                    if let rango2 = rango1["rango"] as? String{
                                        DispatchQueue.main.async {
                                            let registros = Horario(id: id, codigo: codigo, departamento: departamento, genero: genero, dia: dia, rango: rango2, disponible: disponible, nRatings: nRatings, ratingPromedio: ratingPromedio, nombre: nombre, semestre: semestre)
                                            print(valor["nRatings"]!)
                                            self.horarios.append(registros)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
        }
        print("holappp")
        print(self.horarios)
    }
    
    func create() {
        if(!ReachabilityHandlerR().isConnectedToNetwork()){
            print("No tienes conexión a internet, no se puede crear la monitoria");
            self.isAlert = true
            self.alertMessage = "No tienes conexión a internet, no se puede crear la monitoría"
            return;
        }
        let formatterSend = DateFormatter()
        formatterSend.dateFormat = "y-MM-d"
        var ola:String = formatterSend.string(from: self.startDate)
        let index = self.rango.firstIndex(of: ":")
        let distance = ola.distance(from: ola.startIndex, to: index!)
        var subs1:String.SubSequence = ""
        var subs2:String.SubSequence = ""
        if distance==1 {
            subs1 = self.rango.prefix(4)
            subs2 = self.rango.suffix(from: String.Index(encodedOffset: 5))
        } else if distance == 2 {
            subs1 = self.rango.prefix(5)
            subs2 = self.rango.suffix(from: String.Index(encodedOffset: 6))
        }
        print(subs1)
        print(subs2)
        let jajaI = ola + " " + subs1
        let jejeF = ola + " " + subs2
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("reservas").addDocument(data: [
            "asistio": false,
            "cancelada": false,
            "comentario": "",
            "rating": 0,
            "fechaFin": jejeF,
            "fechaInicio": jajaI,
            "idEstudiante": Auth.auth().currentUser?.uid,
            "idMonitor": self.selectedTutor,
            "materia": self.materia,
            "tema": self.topic
            ]
        ) { err in
            if let err = err {
                print("Error adding document: \(err)")
                return
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.back.wrappedValue.dismiss()
            }
        }
        
        //        Actualizar estado del monitor a no disponible:
        let monitorRef = db.collection("monitores").document(self.selectedTutor)
        
        monitorRef.updateData([
            "horarios.\(self.nombreDia).disponible": false
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm"
        let dateF = dateFormatterGet.date(from: jejeF as! String)?.timeIntervalSince1970
        let dateI = dateFormatterGet.date(from: jajaI as! String)?.timeIntervalSince1970
        
        
        let entity =  NSEntityDescription.entity(forEntityName: "TutoriaCache", in: self.managedObjectContext)
        let cachedTutoria = TutoriaCache(entity: entity!, insertInto: self.managedObjectContext)
        cachedTutoria.id = ref!.documentID
        cachedTutoria.idMonitor = self.selectedTutor
        cachedTutoria.idEstudiante = Auth.auth().currentUser?.uid as! String
        cachedTutoria.materia = self.materia
        cachedTutoria.tema = self.topic
        cachedTutoria.rating = 0
        cachedTutoria.comentario = ""
        cachedTutoria.cancelada = false
        cachedTutoria.asistio = false
        cachedTutoria.fechaInicio = dateI!
        cachedTutoria.fechaFin = dateF!
        
        do{
            try self.managedObjectContext.save()
            print("Guardado correctamente")
            self.back.wrappedValue.dismiss()
        } catch let error as NSError {
            print("Error al guardar tutoria en caché", error.localizedDescription)
        }
    }
    
    var body: some View {
        //        ScrollView{
        VStack {
            VStack(alignment: .leading, spacing: 8){
                Group{
                    Form{
                        DatePicker("Fecha monitoría", selection: self.$startDate, in: Date()...Calendar.current.date(byAdding: .day, value: +6, to: Date())!, displayedComponents: .date)
                        Text("Selecciona materia")
                        List{
                            ScrollView(.horizontal, showsIndicators: false, content: {
                                HStack(spacing: 10) {
                                    ForEach(self.materiasPosibles, id: \.self) { materia in
                                        Button(action: {self.materia = materia}, label: {Text("\(materia)").foregroundColor(.white)})
                                            .padding(.all, 8).background(self.materia==materia ? Color.blue : Color.gray).cornerRadius(20)
                                    }
                                }
                            })
                        }.frame(height: 60).previewDisplayName("name")
                        Text("¿Qué tema quieres revisar?")
                        TextField("Tema a revisar", text: $topic).textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {self.buscar()}, label: {Text("Buscar horarios")})
                    }
                }
                
            }
            List{
                ForEach(self.horarios){item in
                    Button(action: {self.selectedTutor = item.id;self.rango = item.rango}, label:{
                        HStack(alignment: .center) {
                            VStack(alignment: .leading){
                                Text("El \(item.dia) a las \(item.rango)")
                                HStack{
                                    Text(item.nombre)
                                    ForEach(1...Int(item.ratingPromedio), id: \.self) { num in
                                        Image(systemName: "star.fill").resizable().frame(width: 20, height: 20).foregroundColor(Color.yellow)
                                    }
                                }
                            }
                            Spacer()
                            Image(systemName: "circle").resizable().frame(width: 20, height: 20).background(self.selectedTutor==item.id ? Color.yellow : Color.white).foregroundColor(.gray).cornerRadius(20)
                        }.padding(.vertical, 12).padding(.horizontal, 12).background(Color.white).cornerRadius(20).shadow(radius: 5)
                    })
                }
            }
            Spacer()
            Button(action: {self.create()}, label: {
                Spacer()
                Text("Crear").foregroundColor(.white)
                Spacer()
            }).disabled(self.materia==""&&self.selectedTutor=="").padding(.all).background(Color.yellow).cornerRadius(0)
            }.navigationBarTitle("Crear nueva tutoría", displayMode: .large).alert(isPresented: self.$isAlert){
                Alert(title: Text("No tienes internet"), message: Text(self.alertMessage), dismissButton: .default(Text("Aceptar")))
            }
    }
}

struct NewAppointment_Previews: PreviewProvider {
    static var previews: some View {
        NewAppointment(viewRouter: ViewRouter())
    }
}
