//
//  CurrencyTextField.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 08/06/24.
//

import SwiftUI

struct CurrencyTextField: View {
    var title: String
    @Binding var value: Double

    private var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "R$ "
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }

    var body: some View {
        TextField(title, text: Binding<String>(
            get: {
                return value.isZero ? "R$ 0,00" : formatter.string(for: Double(value)) ?? ""
            },
            set: { newValue in
                let cleanedValue = newValue.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                if let doubleValue = Double(cleanedValue) {
                    let formattedValue = doubleValue / 100
                    value = formattedValue
                } else {
                    value = 0.0
                }
            }
        ))
        .keyboardType(.decimalPad)
        .multilineTextAlignment(.trailing)
        .onAppear {
            value = 0.0
        }
    }
}
