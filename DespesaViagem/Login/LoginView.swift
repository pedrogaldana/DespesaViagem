//
//  LoginView.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 26/05/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var isLoading = false

    
    var body: some View {
        ZStack{
            VStack {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .padding(.top, 64)
                
                Text("Despesas de Viagem")
                    .font(.system(size: 30, weight: .black))
                    .italic()
                    .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.customBlue)
                
                RoundedTextField(label: "Email", text: $email, isEmail: true)
                    .padding(.top, 48)
                
                RoundedTextField(label: "Senha", text: $password, isPassword: true)
                    .padding(.top)
                
                CustomButton(action: {
                    login()
                }) {
                    HStack{
                        Spacer()
                        if isLoading{
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Entrar")
                        }
                        Spacer()
                    }
                }                .padding(.vertical)
                
                NavigationLink("Cadastre-se", destination: SignUpView())
                    .foregroundStyle(.gray)
                    .padding()
                
                Spacer()
            }
            .padding(.horizontal, 48)
            
            VStack {
                Spacer()
                if authViewModel.showError {
                    
                    ErrorSnackBar(message: authViewModel.errorMessage)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut(duration: 0.5))
                        .padding(.bottom, 32)
                        .onAppear(perform: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                authViewModel.showError = false
                            }
                        })
                    
                }
            }
        }
    }
    
    
    
    func login(){
        if validatedAllFields(){
            isLoading = true
            authViewModel.signIn(email: email, password: password){ success in
                isLoading = false
                if success {
                    authViewModel.isSignedIn = true
                }
            }
        }
    }
    
    func validatedAllFields() -> Bool{
        if !validatedEmptyFields(){
            authViewModel.errorMessage = "Preencha todos os campos."
            authViewModel.showError = true
            return false
        }
        
        else if !validatedEmailFormat(){
            authViewModel.errorMessage = "Email inválido."
            authViewModel.showError = true
            return false
        }
    
        return true
    }
    
    
    func validatedEmptyFields() -> Bool{
        if email.isEmpty || password.isEmpty {
            return false
        }
        return true
    }
    
    func validatedEmailFormat() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}

#Preview {
    LoginView()
}
