//
//  RoundedTextField.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 27/05/24.
//

import SwiftUI

struct RoundedTextField: View {
    var label: String
    @Binding var text: String
    var isPassword: Bool = false
    var isEmail: Bool = false
    
    let maxWidth = 300.0
    let fontSize = 16.0
    let cornerRadius = 12.0
    let lineWidth = 2.0
    
    var body: some View {
        if isPassword {
            SecureField(label, text: $text)
                .padding()
                .font(.system(size: fontSize))
                .foregroundStyle(.customBlue)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(.lightCustomBlue, lineWidth: lineWidth)
                )
                .frame(maxWidth: maxWidth)
        }
        else if isEmail{
            TextField(label, text: $text)
                .padding()
                .font(.system(size: fontSize))
                .foregroundStyle(.customBlue)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(.lightCustomBlue, lineWidth: lineWidth)
                )
                .frame(maxWidth: maxWidth)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        else{
            TextField(label, text: $text)
                .padding()
                .font(.system(size: fontSize))
                .foregroundStyle(.customBlue)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(.lightCustomBlue, lineWidth: lineWidth)
                )
                .frame(maxWidth: maxWidth)
        }
    }
}

#Preview {
    RoundedTextField(label: "Label",text: Binding.constant(""), isPassword: false)
}
