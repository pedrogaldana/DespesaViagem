//
//  User.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 28/05/24.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Decodable {
    @DocumentID var id: String?
    var name: String
    var email: String
}
