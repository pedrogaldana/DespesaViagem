//
//  AccountView.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 29/05/24.
//

import SwiftUI

struct AccountView: View {
    @Binding var showAccountView: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView{
            VStack{
                if authViewModel.loggedUser != nil {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 64)
                        .foregroundStyle(.customBlue)
                        .padding(.top, 100)
                    
                    Text(authViewModel.loggedUser!.name)
                        .foregroundStyle(.customBlue)
                        .font(.system(size: 24, weight: .semibold))
                        .padding(.top)
                    
                    Text(authViewModel.loggedUser!.email)
                        .foregroundStyle(.gray)
                    
                }
                
                Spacer()
                
                CustomButton(action: {
                    authViewModel.signOut()
                }, content: {
                    Text("Sair da conta")
                }, color: .red)
            }
            .navigationBarTitle("")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        self.showAccountView = false
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                    })
            )
            .onAppear{
                authViewModel.getUser(){success in
                }
            }
        }
    }
}

//#Preview {
//    AccountView(showAccountView: Binding.constant(true))
//}
