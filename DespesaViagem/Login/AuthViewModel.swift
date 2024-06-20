//
//  AuthViewModel.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 27/05/24.
//

import Foundation

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var isSignedIn: Bool = false
    @Published var user: FirebaseAuth.User?
    @Published var loggedUser: User? = nil
        
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        self.authStateListenerHandle = auth.addStateDidChangeListener { auth, user in
            self.isSignedIn = user != nil
            if let user = user {
                self.user = user
                print("Usuário logado: \(user.email ?? "sem email")")
            } else {
                print("Nenhum usuário logado")
            }
        }
    }
    
    deinit {
        if let handle = authStateListenerHandle {
            auth.removeStateDidChangeListener(handle)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let user = result?.user {
                self.user = user
                self.showError = false
                completion(true)
            } else if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                self.errorMessage = "Não foi possível efetuar o login: \(error.localizedDescription)"
                self.showError = true
                completion(false)
            }
        }
    }
    
    func signUp(email: String, password: String, name: String, completion: @escaping (Bool) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let user = result?.user {
                self.user = user
                
                let usuario = User(
                    id: user.uid, name: name, email: email
                )
                
                db.collection("Users").document(usuario.id!).setData([
                    "name": usuario.name,
                    "email": usuario.email
                ]) { error in
                    if let error = error {
                        print("Erro ao adicionar usuário: \(error.localizedDescription)")
                        self.errorMessage = "Não foi possível criar o usuário: \(error.localizedDescription)"
                        self.showError = true
                        completion(false)
                    } else {
                        print("Usuário adicionado com sucesso!")
                        self.showError = false
                        completion(true)
                    }
                }
                
            } else if let error = error {
                print("Erro ao adicionar usuário: \(error.localizedDescription)")
                self.errorMessage = "Não foi possível criar o usuário: \(error.localizedDescription)"
                self.showError = true
                completion(false)
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
            print("Logout bem-sucedido")
        } catch let signOutError as NSError {
            print("Erro ao deslogar: \(signOutError.localizedDescription)")
        }
    }
    
    func getUser(completion: @escaping (Bool) -> Void) {
        let userId = user!.uid
        let docRef = db.collection("Users").document(userId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    self.loggedUser = try document.data(as: User.self)
                    self.showError = false
                    completion(true)
                } catch {
                    print("Error decoding user: \(error)")
                    self.errorMessage = "Error decoding user: \(error)"
                    self.showError = true
                    completion(false)
                }
            } else {
                self.errorMessage = "Usuário não encontrado."
                self.showError = true
                completion(false)
            }
        }
    }
}
