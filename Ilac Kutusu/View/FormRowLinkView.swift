//
//  FormRowLinkView.swift
//  IlacKutusu
//
//  Created by Can Ayışık on 18.08.2020.
//  Copyright © 2020 Can Ayışık. All rights reserved.
//

import SwiftUI

struct FormRowLinkView: View {
    //AYARLAR
    var ikon : String
    var renk : Color
    var text : String
    var link : String
    
    
    //BODY
    var body: some View {
        HStack
        {
            ZStack
            {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(renk)
                Image(systemName: ikon)
                    .imageScale(.large)
                    .foregroundColor(Color.white)
            }
            .frame(width: 36, height: 36, alignment: .center)
            
            Text(text).foregroundColor(Color.gray)
            Spacer()
            
            Button(action:
            {
                guard let url = URL(string: self.link), UIApplication.shared.canOpenURL(url)
                else
                {
                    return
                }
                UIApplication.shared.open(url as URL)
                
            })
            {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }
            .accentColor(Color(.systemGray))
        }
    }
}


//ÖNİZLEME
struct FormRowLinkView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowLinkView(ikon: "globe", renk: Color.pink, text: "Web Sitesi", link: "www.google.com")
        .previewLayout(.fixed(width: 375, height: 60))
        .padding()
    }
}
