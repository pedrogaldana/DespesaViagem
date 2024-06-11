//
//  TravelIcons.swift
//  DespesaViagem
//
//  Created by Pedro Galdana on 22/05/24.
//

import Foundation

struct TravelIcon: Identifiable {
    let id = UUID()
    
    let label: String
    let iconName: String
}

struct TravelIconsConstants{
    static let aviao = TravelIcon(label: "Avião",iconName: "airplane")
    static let bagagem = TravelIcon(label: "Bagagem",iconName: "suitcase.fill")
    static let carro = TravelIcon(label: "Carro",iconName: "car.fill")
    static let empresa = TravelIcon(label: "Empresa",iconName: "building.2.fill")
    static let festa = TravelIcon(label: "Festa",iconName: "party.popper.fill")
    static let praia = TravelIcon(label: "Praia",iconName: "beach.umbrella.fill")
    
    static let defaultIcon = bagagem
    
    static func getList() -> [TravelIcon] {
        return [
            aviao,
            bagagem,
            carro,
            empresa,
            festa,
            praia
        ]
    }
    
    static func getIconFromName(iconName: String) -> TravelIcon {
        var travelIcon = defaultIcon
        
        getList().forEach { icon in
            if icon.iconName == iconName{
                travelIcon = icon
            }
        }
        
        return travelIcon
    }
}

