//
//  AddTravelView.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 20/05/24.
//

import SwiftUI

struct AddExpenseView: View {
    @Binding var showAddExpenseView: Bool
    
    @State private var title: String = ""
    @State private var price: Double = Double()
    @State private var isLoading = false
    
    @StateObject private var expenseViewModel: ExpenseViewModel
    
    init(showAddExpenseView: Binding<Bool>, travel: Travel) {
        _expenseViewModel = StateObject(wrappedValue: ExpenseViewModel(travel: travel))
        _showAddExpenseView = showAddExpenseView
    }

    
    var body: some View {
        NavigationView{
            ZStack{
                Form{
                    TextField("Descrição", text: $title)
                    HStack{
                        Text("Valor:")
                            .foregroundStyle(.gray)
                        CurrencyTextField(title: "", value: $price)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }

                    CustomButton(action: {
                        addExpense()
                    }) {
                        HStack{
                            Spacer()
                            if isLoading{
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Adicionar")
                            }
                            Spacer()
                        }
                    }
                }
                .navigationBarTitle("Adicionar gasto")
                .navigationBarItems(
                    trailing:
                        Button(action: {
                            self.showAddExpenseView = false
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.gray)
                        })
                )
                
                VStack {
                    Spacer()
                    if expenseViewModel.showError {
                        ErrorSnackBar(message: expenseViewModel.errorMessage)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.5))
                            .padding(.bottom, 32)
                            .onAppear(perform: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                    expenseViewModel.showError = false
                                }
                            })
                    }
                }
            }
        }
    }
    
    func addExpense(){
        isLoading = true
        if validateFields() {
            var expense = Expense(id: UUID().uuidString, title: self.title, price: self.price)
            expenseViewModel.addExpense(expense: expense){ success in
                isLoading = false
                if success {
                    self.showAddExpenseView = false
                }
            }
        } else
        {
            isLoading = false
        }
    }
    
    func validateFields() -> Bool {
        let errors = [
            self.title.isEmpty ? "Preencher campo Descrição\n" : "",
            self.price.isZero ? "Preencher campo Valor" : ""
        ].joined()
        
        guard errors.isEmpty else {
            expenseViewModel.errorMessage = errors.trimmingCharacters(in: .whitespacesAndNewlines)
            expenseViewModel.showError = true
            return false
        }
        
        return true
    }
}

//#Preview {
//    AddExpenseView(expenseList: Binding.constant(TravelMock.expenseList), showAddExpenseView: Binding.constant(true))
//}
