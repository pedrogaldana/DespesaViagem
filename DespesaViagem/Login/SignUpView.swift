//
//  SignUpView.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 27/05/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var isLoading = false
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        ZStack{
            VStack {
                Spacer()
                
                Text("Preencha os campos abaixo")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.customBlue)
                
                
                RoundedTextField(label: "Nome", text: $name)
                    .padding(.top, 48)
                
                RoundedTextField(label: "Email", text: $email, isEmail: true)
                    .padding(.top)
                
                RoundedTextField(label:"Senha", text: $password, isPassword: true)
                    .padding(.top)
                
                RoundedTextField(label:"Confirmar senha", text: $confirmPassword, isPassword: true)
                    .padding(.top)
                
                CustomButton(action: {
                    createUser()
                }) {
                    HStack{
                        Spacer()
                        if isLoading{
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Criar conta")
                        }
                        Spacer()
                    }
                }
                .padding(.top, 48)

                
                Spacer()
            }
            .navigationBarTitle("Criar conta")
            
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
    
    func createUser(){
        isLoading = true
        if validatedAllFields(){
            authViewModel.signUp(email: email, password: password, name: name){ success in
              isLoading = false
                if success {
                    dismiss()
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
        
        else if !validatedConfirmPassword(){
            authViewModel.errorMessage = "Confirmação de senha incorreta."
            authViewModel.showError = true
            return false
        }
        
        
        return true
    }
    
    
    func validatedEmptyFields() -> Bool{
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty || name.isEmpty {
            return false
        }
        return true
    }
    
    func validatedEmailFormat() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validatedConfirmPassword() -> Bool {
        return password == confirmPassword
    }
}

#Preview {
    SignUpView()
}
