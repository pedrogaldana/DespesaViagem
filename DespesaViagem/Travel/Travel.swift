//
//  Travel.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 20/05/24.
//

import Foundation
import FirebaseFirestoreSwift

struct Travel: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let title: String
    var description: String?
    let icon: String
    let startDate: Date
    let endDate: Date
    let expectedExpense: Double
    var currentExpense: Double
    let destination: String
}
