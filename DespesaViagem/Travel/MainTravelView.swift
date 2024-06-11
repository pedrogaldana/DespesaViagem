//
//  MainTravelView.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 27/05/24.
//

import SwiftUI

struct MainTravelView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var travelViewModel: TravelViewModel
    
    @State private var showAddTravelView = false
    @State private var showAccountView = false
    
    @State private var isLoading = false
    
    
    var body: some View {
        NavigationStack{
            VStack{
                if isLoading {
                    VStack{
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .customBlue))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    if !travelViewModel.travelList.isEmpty{
                        List{
                            ForEach(travelViewModel.travelList) { travel in
                                TravelListItemView(travel: travel)
                                    .listRowInsets(EdgeInsets())
                                    .buttonStyle(PlainButtonStyle())
                                
                            }
                            .background(.lightGray)
                            .listRowSeparator(.hidden)
                            
                        }
                        .listStyle(PlainListStyle())
                        .foregroundStyle(.lightGray)
                        .padding(.top)
                        
                    } else{
                        VStack{
                            Spacer()
                            Text("Você não possui viagens cadastradas.")
                                .foregroundStyle(.gray)
                                .frame(alignment: .center)
                                .padding(.bottom)
                            CustomButton {
                                self.showAddTravelView = true
                            } content: {
                                Text("Adicionar viagem")
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .background(.lightGray)
            .navigationDestination(for: Travel.self) { travel in
                TravelDetailView(travel: travel)
            }
            .navigationTitle("Minhas viagens")
            .navigationBarItems(
                trailing:
                    HStack{
                        Button(action: {
                            self.showAddTravelView = true
                        }, label: {
                            Image(systemName: "plus")
                        }).sheet(isPresented: self.$showAddTravelView, content: {
                            AddTravelView(showAddTravelView: $showAddTravelView)
                        })
                        .foregroundStyle(.customBlue)
                    }
            )
            .navigationBarItems(
                leading:
                    HStack{
                        if authViewModel.isSignedIn {
                            Button(action: {
                                self.showAccountView = true
                            }, label: {
                                Image(systemName: "person.circle")
                            }).sheet(isPresented: self.$showAccountView, content: {
                                AccountView(showAccountView: $showAccountView)
                            })
                            .foregroundStyle(.customBlue)
                        }
                    }
            )
        }
        .refreshable {
            if authViewModel.loggedUser != nil {
                refreshList()
            } else {
                authViewModel.getUser(){ success in
                    if success {
                        refreshList()
                    } else{
                        authViewModel.signOut()
                    }
                }
            }
        }
        .onAppear {
            authViewModel.getUser(){ success in
                if success {
                    refreshList()
                } else {
                    authViewModel.signOut()
                }
            }
        }
    }
    
    func refreshList(){
        isLoading = true
        travelViewModel.fetchTravels(userId: authViewModel.loggedUser!.id!){ success in
            isLoading = false
        }
    }
}

//#Preview {
//    MainTravelView()
//}
