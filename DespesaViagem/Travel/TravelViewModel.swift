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
    
    
    init() {
        self.addTravelSuccess = false
    }
    
    func addTravel(userId: String, travel: Travel, completion: @escaping (Bool) -> Void) {
        db.collection("Users").document(userId).collection("Travels").document(travel.id!).setData([
            "title": travel.title,
            "description": travel.description ?? "",
            "icon": travel.icon,
            "expectedExpense": travel.expectedExpense,
            "currentExpense": travel.currentExpense,
            "destination": travel.destination,
            "startDate": travel.startDate,
            "endDate": travel.endDate
        ]) { error in
            if let error = error {
                self.showError = true
                self.errorMessage = "Erro ao adicionar viagem: \(error.localizedDescription)"
                completion(false)
            } else {
                self.showError = false
                completion(true)
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
            } else if let error = error {
                print("Error getting documents: \(error)")
                completion(false)
            }
        }
    }
    
    func deleteTravel(userId: String, travel: Travel, completion: @escaping (Bool) -> Void) {
        db.collection("Users").document(userId).collection("Travels").document(travel.id!).delete { error in
            if let error = error {
                self.errorMessage = "Erro ao deletar viagem: \(error.localizedDescription)"
                self.showError = true
                completion(false)
                print("Error deleting document: \(error)")
            } else {
                self.showError = false
                completion(true)
                print("Document successfully deleted")
            }
        }
    }
    
    deinit {
        listener?.remove()
    }
}
