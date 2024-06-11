//
//  ContentView.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 20/05/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

       var body: some View {
           NavigationView {
               if authViewModel.isSignedIn {
                   MainTravelView()
               } else {
                   LoginView()
               }
           }
       }
}

