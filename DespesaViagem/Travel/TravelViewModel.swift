//
//  TravelViewModel.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 29/05/24.
//

import Foundation

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


class TravelViewModel: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var addTravelSuccess: Bool = false
    @Published var deleteTravelSuccess: Bool = false
    @Published var travelList: [Travel] = []
    
    private var listener: ListenerRegistration?
    
    @State private var firestoreService = FirestoreService()
    
    
    init() {
        self.addTravelSuccess = false
    }
    
    func addTravel(userId: String, travel: Travel, completion: @escaping (Bool) -> Void) {
            firestoreService.addTravel(userId: userId, travel: travel) { result in
                switch result {
                case .success():
                    self.showError = false
                    completion(true)
                case .failure(let error):
                    self.errorMessage = "Erro ao adicionar viagem: \(error.localizedDescription)"
                    completion(false)
                }
            
        }
    }
    
    func fetchTravels(userId: String, completion: @escaping (Bool) -> Void) {
        listener = db.collection("Users").document(userId).collection("Travels").addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.travelList = querySnapshot.documents.compactMap { document -> Travel? in
                    do {
                        return try document.data(as: Travel.self)
                    } catch {
                        print("Error decoding document: \(error)")
                        return nil
                    }
                }
                completion(true)
//                print("Fetched travels: \(self.travelList)")
            } else if let error = error {
                print("Error getting documents: \(error)")
                completion(false)
            }
        }
    }
    
    func deleteTravel(userId: String, travel: Travel, completion: @escaping (Bool) -> Void) {
        firestoreService.deleteTravel(userId: userId, travelId: travel.id!) { result in
            switch result {
            case .success():
                self.showError = false
                completion(true)
            case .failure(let error):
                self.errorMessage = "Erro ao deletar viagem: \(error.localizedDescription)"
                self.showError = true
                completion(false)
            }
        }        
    }
    
    deinit {
        listener?.remove()
    }
}
