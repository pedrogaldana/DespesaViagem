//
//  CustomButton.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 27/05/24.
//

import SwiftUI

struct CustomButton<Content: View>: View {
    let action: () -> Void
    let content: () -> Content
    var color: Color = .customBlue
    
    var body: some View {
        Button(action: action, label: content)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .font(.system(size: 17))
                .frame(height: 48)
                .frame(maxWidth: 300)
                .background(self.color)
                .cornerRadius(12)
        .padding(.vertical)
    }
}
