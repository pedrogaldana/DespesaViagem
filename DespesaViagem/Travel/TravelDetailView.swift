//
//  TravelDetailView.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 24/05/24.
//

import SwiftUI

struct TravelDetailView: View {
    
    @State private var showAddExpenseView = false
    @State private var showDeleteAlert = false
    
    @State private var isLoading = false
    
    @StateObject private var expenseViewModel: ExpenseViewModel
    @EnvironmentObject private var travelViewModel: TravelViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    init(travel: Travel) {
        _expenseViewModel = StateObject(wrappedValue: ExpenseViewModel(travel: travel))
    }
    
    
    var body: some View {
        VStack{
            
            ZStack {
                Circle()
                    .fill(.cardBackground)
                    .frame(width: 96, height: 96)
                Image(systemName: getTravel().icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(.customBlue)
            }
            .padding(.top, 32)
            
            
            Text(getTravel().destination)
                .font(.system(size: 16, weight: .none))
                .padding(.top)
            
            Text(getInterval())
                .font(.system(size: 16, weight: .none))
                .foregroundStyle(.gray)
            
            
            Text(getTravel().description ?? "")
                .foregroundStyle(.gray)
                .padding(.top)
            
            ZStack{
                ProgressView(value: travelUtils().currentFloatPercentage())
                    .progressViewStyle(TravelProgressViewStyle(travel: getTravel()))
                    .scaleEffect(CGSize(width: 1.0, height: 5.5))
                
                Text(travelUtils().currentStringPercentage())
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .bold))
                    .shadow(color: .gray, radius: 1, x: 1, y:1)
            }
            .padding(.top, 32)
            .padding(.horizontal)
            
            
            HStack{
                VStack(alignment: .leading){
                    Text("Total gasto")
                        .foregroundStyle(.gray)
                    
                    if getTravel().currentExpense > getTravel().expectedExpense{
                        Text(travelUtils().currentExpenseString())
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.red)
                    } else {
                        Text(travelUtils().currentExpenseString())
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                
                
                Spacer()
                
                
                VStack(alignment: .trailing){
                    Text("Gasto previsto")
                        .foregroundStyle(.gray)
                    Text(travelUtils().expectedExpenseString())
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.gray)
                }
                
                
            }
            .padding(.horizontal)
            
            
            if !expenseViewModel.expenseList.isEmpty {
                
                VStack{
                    
                    HStack{
                        Text("Despesas")
                            .font(.system(size: 22, weight: .semibold))
                        
                        Spacer()
                        
                        Button(action: {
                            self.showAddExpenseView = true
                        }, label: {
                            Image(systemName: "plus")
                        })
                        .sheet(isPresented: self.$showAddExpenseView, content: {
                            AddExpenseView(showAddExpenseView: $showAddExpenseView, travel: getTravel())
                        })
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    List{
                        ForEach(expenseViewModel.expenseList){ expenseItem in
                            expenseListItem(expense: expenseItem)
                                .padding(.top, 4)
                                .listRowInsets(EdgeInsets())
                        }
                        .onDelete(perform: { indexSet in
                            for index in indexSet{
                                deleteExpense(expense: expenseViewModel.expenseList[index])
                            }
                            
                        })
                        .listRowBackground(Color("CardBackground"))
                    }
                    .padding(.horizontal)
                    .listStyle(PlainListStyle())
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.cardBackground)
                )
                .padding(.top, 32)
            } else {
                CustomButton(action: {
                    self.showAddExpenseView = true
                }, content: {
                    HStack{
                        
                        Image(systemName: "plus")
                            .padding(.leading)
                        Text("Adicionar Despesa")
                            .padding(.trailing)
                    }
                })
                .sheet(isPresented: self.$showAddExpenseView, content: {
                    AddExpenseView(showAddExpenseView: $showAddExpenseView, travel: getTravel())
                })
                .padding(.top, 32)
            }
            
            Spacer()
        }
        .navigationTitle(getTravel().title)
        .navigationBarItems(
            trailing: Button(action: {
                showDeleteAlert = true
                
            }, label: {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .red))
                } else {
                    
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
            })
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Excluir viagem?"),
                    message: Text("Deseja deletar a viagem '\(getTravel().title)' permanentemente?"),
                    primaryButton: .default(Text("Deletar"), action: {
                        deleteTravel()
                    }),
                    secondaryButton: .cancel(Text("Cancelar"), action: {
                        print("Option 2 selected")
                    })
                )
            }
        )
        .padding(.horizontal)
        .onAppear{
            getExpenses()
        }
        .background(.lightGray)
        
    }
    
    func expenseListItem(expense: Expense) -> some View{
        return HStack{
            Image(systemName: "dollarsign")
                .foregroundColor(.gray)
            
            Text(expense.title)
                .foregroundStyle(.gray)
            
            Spacer()
            
            Text(expense.priceString())
                .foregroundStyle(.gray)
        }
    }
    
    func getTravel() -> Travel { expenseViewModel.travel }
    
    func getInterval() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "pt_BR" )
        
        let initial = formatter.string(from: getTravel().startDate)
        let final = formatter.string(from: getTravel().endDate)
        
        var result = "\(initial)  -  \(final)"
        
        result.replace("de", with: "")
        
        return result
    }
    
    func getExpenses(){
        expenseViewModel.fetchExpenses(travelId: getTravel().id!)
    }
    
    func deleteTravel(){
        if authViewModel.loggedUser != nil {
            isLoading = true
            travelViewModel.deleteTravel(userId: authViewModel.loggedUser!.id!, travel: self.getTravel()){ success in
                isLoading = false
                if success {
                    dismiss()
                }
            }
        } else {
            authViewModel.signOut()
        }
    }
    
    func deleteExpense(expense: Expense){
        expenseViewModel.deleteExpense(travel: getTravel(), expense: expense){success in
            if(success){
                
            } else {
                
            }
        }
    }
    
    func travelUtils() -> TravelUtils {
        return TravelUtils(travel: getTravel())
    }
}

//#Preview {
//    TravelDetailView(travel: TravelMock.travel)
//}
