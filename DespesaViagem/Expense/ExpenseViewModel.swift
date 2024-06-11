//
//  TravelViewModel.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 31/05/24.
//

import Foundation

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class ExpenseViewModel: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var addExpenseSuccess: Bool = false
    @Published var deleteExpenseSuccess: Bool = false
    @Published var expenseList: [Expense] = []
    @Published var currentExpense: Double = 0.0
    
    @Published var travel: Travel
    
    private var listener: ListenerRegistration?
    private var travelListener: ListenerRegistration?

    
    @State private var firestoreService = FirestoreService()
    
    private var userId: String?
    
    init(travel: Travel) {
        self.addExpenseSuccess = false
        userId = Auth.auth().currentUser?.uid
        self.travel = travel
        fetchTravel()
    }
    
    func addExpense(expense: Expense, completion: @escaping (Bool) -> Void) {
        firestoreService.addExpense(userId: userId!, travelId: travel.id!, expense: expense){ result in
            switch result {
            case .success():
                self.showError = false
                self.updateTotalSpent(by: expense.price)
                completion(true)
            case .failure(let error):
                self.errorMessage = "Erro ao adicionar despesa: \(error.localizedDescription)"
                self.showError = true
                completion(false)
            }
        }
    }
    
    func getExpenseList(travelId: String){
        if userId != nil {
            firestoreService.fetchExpenses(userId: userId!, travelId: travelId) { result in
                switch result {
                case.success(let expenses):
                    expenses.forEach { item in self.currentExpense += item.price }
                    self.showError = false
                    self.expenseList = expenses
                case .failure(let error):
                    self.errorMessage = "Erro ao adicionar despesa: \(error.localizedDescription)"
                    self.showError = true
                }
            }
        }
    }
    
    func fetchExpenses(travelId: String) {
        listener = db.collection("Users").document(userId!).collection("Travels").document(travelId).collection("Expenses").addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.expenseList = querySnapshot.documents.compactMap { document -> Expense? in
                    do {
                        return try document.data(as: Expense.self)
                    } catch {
                        print("Error decoding document: \(error)")
                        return nil
                    }
                }
                print("Fetched expenses: \(self.expenseList)")
            } else if let error = error {
                print("Error getting documents: \(error)")
            }
        }
    }
    
    func deleteExpense(travel: Travel, expense: Expense, completion: @escaping (Bool) -> Void) {
        firestoreService.deleteExpense(userId: userId!, travelId: travel.id!, expenseId: expense.id!) { result in
            switch result {
            case .success():
                self.showError = false
                completion(true)
                self.updateTotalSpent(by: -expense.price)
            case .failure(let error):
                self.errorMessage = "Erro ao deletar gasto: \(error.localizedDescription)"
                self.showError = true
                completion(false)
            }
        }
    }
    
    func fetchTravel() {
        travelListener = db.collection("Users").document(userId!).collection("Travels").document(travel.id!).addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("Error fetching trip: \(error.localizedDescription)")
                    return
                }
                if let document = documentSnapshot, document.exists {
                    self.travel = try! document.data(as: Travel.self)
                }
            }
        }
    
    private func updateTotalSpent(by amount: Double) {
        travel.currentExpense += amount
            do {
                try db.collection("Users").document(userId!).collection("Travels").document(travel.id!).setData(from: travel, merge: true)
            } catch {
                print("Error updating total spent: \(error.localizedDescription)")
            }
        }
    
    deinit {
        listener?.remove()
        travelListener?.remove()
    }
}
