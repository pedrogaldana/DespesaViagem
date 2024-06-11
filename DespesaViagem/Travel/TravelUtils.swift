//
//  TravelUtils.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 05/06/24.
//

import Foundation

struct TravelUtils{
    let travel: Travel
    
    func currentFloatPercentage() -> Float {
        return Float(travel.currentExpense / travel.expectedExpense)
    }
    
    func currentStringPercentage() -> String {
        let percentage = currentFloatPercentage()*100
        let stringPercentage = String(format: "%.1f", percentage)
        return "\(stringPercentage)%"
    }
    
    func currentExpenseString() -> String{
        let formatedCurrentExpense = String(format: "%.2f", travel.currentExpense)
        return "R$ \(formatedCurrentExpense)"
    }
    
    func expectedExpenseString() -> String {
        let formatedExpectedExpense = String(format: "%.2f", travel.expectedExpense)
        return "R$ \(formatedExpectedExpense)"
    }
}
