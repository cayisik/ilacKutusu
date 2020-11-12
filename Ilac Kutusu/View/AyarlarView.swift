//
//  AyarlarView.swift
//  IlacKutusu
//
//  Created by Can Ayışık on 15.08.2020.
//  Copyright © 2020 Can Ayışık. All rights reserved.
//

import SwiftUI

struct AyarlarView: View {
    //AYARLAR
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var ikonAyarlar : ikonIsim
    
    //TEMA
    let temalar:[Tema] = temaData
    @ObservedObject var tema = TemaAyarlar()
    @State private var temaDegisti: Bool = false
    
    //BODY
    var body: some View {
        NavigationView
        {
            VStack(alignment: .center, spacing: 0)
            {
            //FORM
                Form
                {
                    //Ikonlar
                    Section(header: Text("Uygulama İkonu"))
                    {
                        Picker(selection: $ikonAyarlar.mevcutIndex, label:
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .strokeBorder(Color.primary, lineWidth: 2)
                                    
                                    Image(systemName: "paintbrush")
                                        .font(.system(size: 28, weight: .regular, design: .default))
                                        .foregroundColor(Color.primary)
                                }
                                .frame(width: 44, height: 44)
                                
                                Text("Uygulama İkonları")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.primary)
                            })
                        {
                            ForEach(0..<ikonAyarlar.ikonIsim.count)
                            {
                                index in
                                HStack
                                {
                                    Image(uiImage: UIImage(named: self.ikonAyarlar.ikonIsim[index] ?? "Blue" ) ?? UIImage())
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44)
                                        .cornerRadius(8)
                                    
                                    Spacer().frame(width: 8 )
                                    
                                    Text(self.ikonAyarlar.ikonIsim[index] ?? "Mavi")
                                        .frame(alignment: .leading)
                                }//Son -- HStack
                                .padding(3)
                            }
                        }//Son -- Picker
                            .onReceive( [self.ikonAyarlar.mevcutIndex].publisher.first()){
                                (value) in
                                let index = self.ikonAyarlar.ikonIsim.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
                                    if index != value
                                    {
                                        UIApplication.shared.setAlternateIconName(self.ikonAyarlar.ikonIsim[value])
                                        {
                                            error in
                                            if let error = error
                                            {
                                                print(error.localizedDescription)
                                            }
                                            else
                                            {
                                                print("İkon değiştirdiniz!")
                                            }
                                        }
                                        
                                }
                            }
                    }
                    .padding(.vertical, 3)
                    
                    //Temalar
                    Section(header:
                        HStack {
                            Text("Tema Seçenekleri")
                            Image(systemName: "circle.fill")
                            .resizable()
                                .frame(width:10, height:10)
                                .foregroundColor(temalar[self.tema.temaAyarlar].temaRenk)
                        }
                        )
                    {
                        List
                        {
                            ForEach(temalar, id: \.id)
                            {
                                item in
                                Button(action:
                                {
                                    self.tema.temaAyarlar = item.id
                                    UserDefaults.standard.set(self.tema.temaAyarlar, forKey: "Tema")
                                    self.temaDegisti.toggle()
                                })
                                {
                                    HStack
                                    {
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(item.temaRenk)
                                        Text(item.temaIsmi)
                                    }
                                }
                                .accentColor(Color.primary)
                            }
                            
                        }
                    }
                    .padding(.vertical,3)
                    .alert(isPresented: $temaDegisti)
                    {
                        Alert(title: Text("Tema Değişikliği Başarılı!"), message: Text("Uygulamanın tema rengini değiştirdiniz. Uygulamayı açıp kapattıktan sonra devreye girecektir. Lütfen uygulamayı açıp kapatın."), dismissButton: .default(Text("Tamam")))
                    }
                    
                    //Sosyal Medyalar
                    Section(header: Text("Sosyal Medya Hesaplarımız"))
                    {
                        FormRowLinkView(ikon: "globe", renk: Color.gray, text: "Web Sitesi", link: "www.google.com")
                        FormRowLinkView(ikon: "link", renk: Color.blue, text: "Twitter", link: "https://twitter.com/cayisik")
                        FormRowLinkView(ikon: "play.rectangle", renk: Color.red, text: "Youtube", link: "https://youtube.com")
                        
                    }
                    .padding(.vertical, 3)
                    
                    //Hakkımızda
                    Section(header: Text("Uygulama Hakkında"))
                    {
                        FormRowStaticView(ikon: "gear", ilkText: "Uygulama", ikinciText: "İlaç Kutusu")
                        FormRowStaticView(ikon: "checkmark.seal", ilkText: "Uyumluluk", ikinciText: "iPhone")
                        FormRowStaticView(ikon: "keyboard", ilkText: "Yazılımcı", ikinciText: "Can AYIŞIK")
                        FormRowStaticView(ikon: "flag", ilkText: "Versiyon", ikinciText: "1.0.0")
                    }
                    .padding(.vertical, 3)
                }//Son -- Form
                    .listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
                //FOOTER
                Text("Sağlıklı olman için çabalıyoruz ♡ ")
                    .multilineTextAlignment(.center)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(Color.secondary)
            }//Son -- VStack
                
            .navigationBarItems( trailing:
                Button(action: { self.presentationMode.wrappedValue.dismiss() })
                {
                Image(systemName: "xmark")
                }
                )
                .navigationBarTitle("Ayarlar", displayMode: .inline)
                .background(Color("BackgroundRenk")
                .edgesIgnoringSafeArea(.all))
        }//Son -- Navigation
            .accentColor(temalar[self.tema.temaAyarlar].temaRenk)
        .navigationViewStyle(StackNavigationViewStyle())

    }
}


//ÖNİZLEME
struct AyarlarView_Previews: PreviewProvider {
    static var previews: some View {
        AyarlarView().environmentObject(ikonIsim())
    }
}
