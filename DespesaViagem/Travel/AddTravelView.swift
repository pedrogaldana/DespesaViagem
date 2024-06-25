//
//  AddTravelView.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 20/05/24.
//

import SwiftUI

struct AddTravelView: View {
    //    @Binding var travelList: [Travel]
    @Binding var showAddTravelView: Bool
    
    @State var title: String = ""
    @State var description: String = ""
    @State var expectedExpense: Double = 0.0
    @State var icon: String = TravelIconsConstants.defaultIcon.iconName
    @State var initialDate: Date = Date()
    @State var finalDate: Date = Date()
    @State var destination: String = ""
    
    @State private var isLoading = false

    
    @EnvironmentObject var travelViewModel: TravelViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    
    var body: some View {
        NavigationView{
            ZStack{
                Form{
                    TextField("Nome da viagem:", text: $title)
                    TextField("Destino:", text: $destination)
                    DatePicker(selection: $initialDate, displayedComponents: .date) {
                        Text("Data de início:")
                    }
                    DatePicker(selection: $finalDate, displayedComponents: .date) {
                        Text("Data fim:")
                    }
                    TextField("Descrição (opcional):", text: $description)
                    HStack{
                        Text("Gasto esperado:")
                        CurrencyTextField(title: "", value: $expectedExpense)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack{
                        Text("Selecione o ícone:")
                        Spacer()
                        Menu {
                            ForEach(TravelIconsConstants.getList()) { item in
                                menuIconButton(travelIcon: item)
                            }
                        } label: {
                            Image(systemName: icon)
                        }

                            
                        
                    }
                    CustomButton(action: {
                        addTravel()
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
                .navigationBarTitle("Criar viagem")
                .navigationBarItems(
                    trailing:
                        Button(action: {
                            self.showAddTravelView = false
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.gray)
                        })
                )
                
                VStack {
                    Spacer()
                    if travelViewModel.showError {
                        ErrorSnackBar(message: travelViewModel.errorMessage)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.5))
                            .padding(.bottom, 32)
                            .onAppear(perform: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                    travelViewModel.showError = false
                                }
                            })
                    }
                }
            }
            
        }
    }
    
    
    func menuIconButton(travelIcon: TravelIcon) -> some View {
        return Button(action: {
            self.icon = travelIcon.iconName
        }, label: {
            Text(travelIcon.label)
            Spacer()
            Image(systemName: travelIcon.iconName)
        })
    }
    
    func addTravel(){
        if authViewModel.loggedUser != nil {
            let travel = Travel(
                id: UUID().uuidString, title: self.title, description: self.description, icon: self.icon, startDate: self.initialDate, endDate: self.finalDate, expectedExpense: self.expectedExpense, currentExpense: 0.0, destination: self.destination
            )
            
            if validateFields() {
                isLoading = true
                travelViewModel.addTravel(userId: authViewModel.loggedUser!.id! ,travel: travel){ success in
                    isLoading = false
                    if success {
                        self.showAddTravelView = false
                    }
                }
            } else {
                isLoading = false
            }
        } else {
            authViewModel.signOut()
        }
    }
    
    func validateFields() -> Bool {
        let errors = [
            self.title.isEmpty ? "Preencher campo Nome da viagem\n" : "",
            self.destination.isEmpty ? "Preencher campo Destino\n" : "",
            self.expectedExpense.isZero ? "Preencher campo Gasto esperado" : ""
        ].joined()
        
        guard errors.isEmpty else {
            travelViewModel.errorMessage = errors.trimmingCharacters(in: .whitespacesAndNewlines)
            travelViewModel.showError = true
            return false
        }
        
        return true
    }
}

//#Preview {
//    AddTravelView(showAddTravelView: Binding.constant(true))
//}
