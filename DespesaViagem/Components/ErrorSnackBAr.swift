//
//  ErrorSnackBar.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 27/05/24.
//

import SwiftUI

struct ErrorSnackBar: View {
    var message: String

    var body: some View {
        HStack {
            Text(message)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .padding()
            Spacer()
        }
        .background(Color.red)
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .cornerRadius(10)
        .padding()
    }
}

#Preview {
    ErrorSnackBar(message: "Ocorreu um erro inesperado")
}
