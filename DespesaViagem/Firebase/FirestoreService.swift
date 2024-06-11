//
//  FirestoreService.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 28/05/24.
//
import FirebaseFirestore
import Foundation

class FirestoreService {
    private let db = Firestore.firestore()
    
    func addUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("Users").document(user.id!).setData([
            "name": user.name,
            "email": user.email
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func addTravel(userId: String, travel: Travel, completion: @escaping (Result<Void, Error>) -> Void) {
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
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func addExpense(userId: String, travelId: String, expense: Expense, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("Users").document(userId).collection("Travels").document(travelId).collection("Expenses").document(expense.id!).setData([
            "price": expense.price,
            "title": expense.title
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        db.collection("Users").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let usuarios = querySnapshot?.documents.compactMap { document -> User? in
                    let data = document.data()
                    let id = document.documentID
                    let name = data["name"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    return User(id: id, name: name, email: email)
                } ?? []
                completion(.success(usuarios))
            }
        }
    }
    
    
    func fetchExpenses(userId: String, travelId: String, completion: @escaping (Result<[Expense], Error>) -> Void) {
        db.collection("Users").document(userId).collection("Travels").document(travelId).collection("Expenses").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let despesas = querySnapshot?.documents.compactMap { document -> Expense? in
                    let data = document.data()
                    let id = document.documentID
                    let title = data["title"] as? String ?? ""
                    let price = data["price"] as? Double ?? 0.0
                    return Expense(id: id, title: title, price: price)
                } ?? []
                completion(.success(despesas))
            }
        }
    }
    
    func deleteTravel(userId: String, travelId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("Users").document(userId).collection("Travels").document(travelId).delete { error in
            if let error = error {
                completion(.failure(error))
                print("Error deleting document: \(error)")
            } else {
                completion(.success(()))
                print("Document successfully deleted")
            }
        }
    }
    
    func deleteExpense(userId: String, travelId: String, expenseId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("Users").document(userId).collection("Travels").document(travelId).collection("Expenses").document(expenseId).delete { error in
            if let error = error {
                completion(.failure(error))
                print("Error deleting document: \(error)")
            } else {
                completion(.success(()))
                print("Document successfully deleted")
            }
        }
    }
}
