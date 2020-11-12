//
//  BosListeView.swift
//  IlacKutusu
//
//  Created by Can Ayışık on 15.08.2020.
//  Copyright © 2020 Can Ayışık. All rights reserved.
//

import SwiftUI

struct BosListeView: View {
    //AYARLAR
    @State private var isAnimated: Bool = false
    
    let arkaPlanlar: [String] =
        [
            "illustration-no1",
            "illustration-no2",
            "illustration-no3"
        ]
    let arkaPlanAciklama: [String] =
        [
            "Unutmamak için mutlaka ilaçlarını kaydet!",
            "Sağlığın için ilaçlarını iç!",
            "Herşeyin başı sağlık!",
            "Senin için hatırlıyoruz!",
            "Bizim için değerlisin!"
        ]
    
    //TEMA
    @ObservedObject var tema = TemaAyarlar()
    var temalar : [Tema] = temaData
    
    
    
    //BODY
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20)
            {
                Image("\(arkaPlanlar.randomElement() ?? self.arkaPlanlar[0])")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit().frame(minWidth: 256, idealWidth: 280, maxWidth: 360, minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
                    .layoutPriority(1)
                    .foregroundColor(temalar[self.tema.temaAyarlar].temaRenk)
                
                Text("\(arkaPlanAciklama.randomElement() ?? self.arkaPlanAciklama[0])")
                    .layoutPriority(0.5)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(temalar[self.tema.temaAyarlar].temaRenk)
            }//SON -- VStack
                .padding(.horizontal)
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 1 : -50)
                .animation(.easeOut(duration : 1.5))
                .onAppear(perform: {self.isAnimated.toggle()})
        }//SON -- ZStack
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color("BaseRenk"))
            .edgesIgnoringSafeArea(.all)
    }
}


//ÖNİZLEME
struct BosListeView_Previews: PreviewProvider {
    static var previews: some View {
        BosListeView()
            .environment(\.colorScheme, .dark)
    }
}
