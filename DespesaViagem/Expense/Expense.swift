//
//  Expense.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 20/05/24.
//

import Foundation
import FirebaseFirestoreSwift

struct Expense: Identifiable, Codable {
    @DocumentID var id: String?
    let title: String
    let price: Double
    
    func priceString() -> String{
        let formattedPrice = String(format: "%.2f", price)
        return "R$ \(formattedPrice)"
    }
}
