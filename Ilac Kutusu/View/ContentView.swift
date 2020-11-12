//
//  ContentView.swift
//  Ilac Kutusu
//
//  Created by Can Ayışık on 8.08.2020.
//  Copyright © 2020 Can Ayışık. All rights reserved.
//

import UserNotifications
import SwiftUI

struct ContentView: View {
    //AYARLAR
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: IlacKutusuDB.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \IlacKutusuDB.isim, ascending: true)]) var ilaclar: FetchedResults<IlacKutusuDB>
    
    @EnvironmentObject var ikonAyarlar : ikonIsim
    
    @State private var ilacEkleGec: Bool = false
    @State private var buttonAnimasyon: Bool = false
    @State private var ayarlarViewGec : Bool = false
    
    //TEMA
    
    @ObservedObject var tema = TemaAyarlar()
    var temalar : [Tema] = temaData
    
    //BODY
    var body: some View {
        NavigationView{
            ZStack {
                List
                {
                    ForEach(self.ilaclar, id: \.self)
                    {
                        ilaclar in HStack
                        {
                            Circle()
                                .frame(width:20, height: 20, alignment: .center)
                                .foregroundColor(self.oncelikRenk(zamanDilimi: ilaclar.zamanDilimi ?? "Öğle"))
                            Text(ilaclar.isim ?? "Bilinmeyen")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(ilaclar.zamanDilimi ?? "Bilinmeyen")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(minWidth: 62)
                                .overlay(
                                    Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                                )
                            //Spacer()
                            //Text(ilaclar.saat ?? "Bilinmeyen")
                        }//Son -- HStack
                            .padding(.vertical,10)
                    }//Son -- ForEach
                    .onDelete(perform: ilacSil)
                    
                }//Son -- List
                .navigationBarTitle("İlaç Kutusu", displayMode: .inline)
                .navigationBarItems(
                    leading: EditButton().accentColor(temalar[self.tema.temaAyarlar].temaRenk),
                    trailing:
                    Button(action:
                        {
                            self.ayarlarViewGec.toggle()
                        }
                    )
                        {
                            Image(systemName: "paintbrush")
                                .imageScale(.large)
                        }//Son -- Ayarlar Butonu
                        .accentColor(temalar[self.tema.temaAyarlar].temaRenk)
                    .sheet(isPresented: $ayarlarViewGec)
                    {
                        AyarlarView().environmentObject(self.ikonAyarlar)
                    }
                )
                //Eğer liste boş ise
                if ilaclar.count == 0
                {
                    BosListeView()
                }
            }//Son -- ZStack
            .sheet(isPresented: $ilacEkleGec)
            {
                MainView().environment(\.managedObjectContext, self.managedObjectContext)
            }
            .overlay(
                ZStack {
                    Group
                    {
                        Circle()
                            .fill(temalar[self.tema.temaAyarlar].temaRenk)
                            .opacity(self.buttonAnimasyon ? 0.2 : 0)
                            .scaleEffect(self.buttonAnimasyon ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        
                        Circle()
                            .fill(temalar[self.tema.temaAyarlar].temaRenk)
                            .opacity(self.buttonAnimasyon ?  0.15 : 0)
                            .scaleEffect(self.buttonAnimasyon ? 1 : 0)
                            .frame(width: 88, height: 88, alignment: .center)
                        
                    }
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                    
                    Button(action: {self.ilacEkleGec.toggle()})
                {
                    Image(systemName: "plus.circle.fill").resizable().scaledToFit().background(Circle().fill(Color("BaseRenk")))
                        .frame(width: 48, height: 48, alignment: .center)
                    }//SON -- Alt Kaydet Butonu
                        .accentColor(temalar[self.tema.temaAyarlar].temaRenk)
                        .onAppear(perform: {self.buttonAnimasyon.toggle()})
                }//SON -- ZStack
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
                    , alignment: .bottomTrailing
            )

               
        }//Son -- Navigation
        .navigationViewStyle(StackNavigationViewStyle())
    }
    //Fonksiyonlar
    private func ilacSil(at nereden: IndexSet)
    {
        for index in nereden
        {
            let ilacListe = ilaclar[index]
            managedObjectContext.delete(ilacListe)
            
            do
            {
                try managedObjectContext.save()
            }
            catch
            {
                print(error)
            }
            
        }
    }
    
    private func oncelikRenk(zamanDilimi : String) -> Color
    {
        switch zamanDilimi {
        case "Sabah":
            return .pink
        case "Öğle":
            return .blue
        case "Akşam":
            return .green
        default:
            return .gray
        }
    }
    
}


//ÖNİZLEME
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       
        let icerik = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return ContentView()
            .environment(\.managedObjectContext, icerik)
    }
}
