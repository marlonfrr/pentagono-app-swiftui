//
//  ViewRouter.swift
//  PentagooWCoreData
//
//  Created by Marlon Alejandro Forero Forero on 18/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import SwiftUI
import Foundation
import Combine

class ViewRouter: ObservableObject {
    let objectWillChange = PassthroughSubject<ViewRouter,Never>()
    var currentPage: Int = 3 {
        didSet {
            objectWillChange.send(self)
        }
    }
    var logged: Bool = false {
        didSet {
            objectWillChange.send(self)
        }
    }

}

//struct ViewRouter: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}

//struct ViewRouter_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewRouter()
//    }
//}
