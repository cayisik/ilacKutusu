//
//  FormRowStaticView.swift
//  IlacKutusu
//
//  Created by Can Ayışık on 18.08.2020.
//  Copyright © 2020 Can Ayışık. All rights reserved.
//

import SwiftUI

struct FormRowStaticView: View {
    //AYARLAR
    var ikon : String
    var ilkText : String
    var ikinciText : String
    
    //BODY
    var body: some View {
        HStack
        {
            ZStack
            {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.gray)
                Image(systemName: ikon)
                    .foregroundColor(Color.white)
            }
            .frame(width: 36, height: 36, alignment: .center)
            
            Text(ilkText).foregroundColor(Color.gray)
            Spacer()
            Text(ikinciText)
        }
    }
}


//ÖNİZLEME
struct FormRowStaticView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowStaticView(ikon: "gear", ilkText: "Uygulama", ikinciText: "İlaç Kutusu")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
