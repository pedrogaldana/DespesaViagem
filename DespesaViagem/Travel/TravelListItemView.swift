//
//  TravelListItemView.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 20/05/24.
//

import SwiftUI

struct TravelListItemView: View {
    let travel: Travel
    
    var body: some View {
        ZStack{
            HStack{
                VStack{
                    HStack{
                        Image(systemName: travel.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24)
                            .padding(.trailing, 8)
                            .foregroundColor(.customBlue)
                        
                        Text(travel.title)
                            .font(.system(size: 20, weight: .semibold))
                            .lineLimit(1)
                            .foregroundStyle(.textBlack)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ZStack{
                        
                        ProgressView(value: travelUtils().currentFloatPercentage())
                            .progressViewStyle(TravelProgressViewStyle(travel: self.travel))
                            .scaleEffect(CGSize(width: 1.0, height: 5.5))
                        
                        Text(travelUtils().currentStringPercentage())
                            .foregroundStyle(.white)
                            .font(.system(size: 17, weight: .bold))
                            .shadow(color: .gray, radius: 1, x: 1, y:1)
                    }
                    
                    HStack{
                        VStack(alignment: .leading){
                            Text("Atual")
                            if travel.currentExpense > travel.expectedExpense{
                                Text(String(travelUtils().currentExpenseString()))
                                    .foregroundStyle(.red)
                            } else {
                                Text(String(travelUtils().currentExpenseString()))
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing){
                            Text("Previsto")
                            Text(String(travelUtils().expectedExpenseString()))
                        }
                        
                    }
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                    
                }
                
            }
            .padding()
            
            NavigationLink(value: travel) {
                EmptyView()
            }.opacity(0.0)
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.cardBackground))
        .padding(.all, 8)
    }
    
    func travelUtils() -> TravelUtils {
        return TravelUtils(travel: self.travel)
    }
}

struct TravelProgressViewStyle: ProgressViewStyle {
    let travel: Travel
    
    func makeBody(configuration: Configuration) -> some View {
        if (travel.currentExpense > travel.expectedExpense){
            ProgressView(configuration)
                .accentColor(.progressRed)
        } else {
            ProgressView(configuration)
                .accentColor(.progressGreen)
        }
    }
}

