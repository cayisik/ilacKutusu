//
//  MainView.swift
//  Ilac Kutusu
//
//  Created by Can Ayışık on 8.08.2020.
//  Copyright © 2020 Can Ayışık. All rights reserved.
//

import UserNotifications
import SwiftUI

struct MainView: View {
    //AYARLAR
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext

    
    @State private var isim: String = ""
    @State private var zamanDilimi: String = "Öğle"
    @State private var acTok: String = "Aç"
    //@State private var alarm = Date()
    @State private var saat : String = ""
    @State private var dakika : String = ""
    
    
    let zamanlar = ["Sabah", "Öğle", "Akşam"]
    let acTokDurum = ["Aç", "Tok"]
    
    @State private var hataGoster: Bool = false
    @State private var hataBaslik: String = ""
    @State private var hataMesaj: String = ""
    
    //TEMA
    
    @ObservedObject var tema = TemaAyarlar()
    var temalar : [Tema] = temaData
    
    
    
    //BODY
    var body: some View {
        NavigationView
        {
            VStack
            {
                VStack(alignment: .leading, spacing: 20)
                {
                    //İlaç İsmi
                    TextField("İlacın ismini giriniz.", text: $isim)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size:24, weight: .bold, design: .default))
                    
                    //İlaç Zamanı
                    Picker("Ne Zaman İçilecek?", selection: $zamanDilimi)
                    {
                        ForEach(zamanlar, id: \.self)
                        {Text($0)}
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    //Aç-Tok
                    Picker("Nasıl Tüketilecek?", selection: $acTok)
                    {
                        ForEach(acTokDurum, id: \.self)
                        {Text($0)}
                    }
                    .pickerStyle(SegmentedPickerStyle())
                                        
                    //DatePicker("Alarmın ne zaman çalacağını seçiniz." , selection: $alarm, displayedComponents: .hourAndMinute)
                    //  .labelsHidden()
                    
                    
                    HStack {
                        TextField("Saat", text: $saat)
                            .padding()
                            .background(Color(UIColor.tertiarySystemFill))
                            .cornerRadius(9)
                            .font(.system(size:15, weight: .bold, design: .default))
                        
                        TextField("Dakika", text: $dakika)
                            .padding()
                            .background(Color(UIColor.tertiarySystemFill))
                            .cornerRadius(9)
                            .font(.system(size:15, weight: .bold, design: .default))
                    }
                    
                    
                    //Kaydet
                    Button(action:
                        {
                            if self.isim != ""
                            {
                                let kaydet = IlacKutusuDB(context: self.managedObjectContext)
                                kaydet.isim = self.isim
                                kaydet.zamanDilimi = self.zamanDilimi
                                kaydet.durum = self.acTok
                                kaydet.saat = self.saat
                                kaydet.dakika = self.dakika
                                
                                do
                                {
                                    try self.managedObjectContext.save()
                                    //print("Yeni İlaç Eklendi. İlaç Adı: \(kaydet.isim ?? ""), İçileceği Vakit: \(kaydet.zamanDilimi ?? ""), Nasıl İçilecek: \(kaydet.durum ?? "") ")
                                }
                                catch
                                {
                                    print(error)
                                }
                                
                            }
                            else
                            {
                                self.hataGoster = true
                                self.hataBaslik = "Bir Hata Oluştu!"
                                self.hataMesaj = "Yeni bir ilaç oluşturmak için\nisim alanını boş bırakmamalısınız."
                                return
                            }
                            
                            UNUserNotificationCenter.current()
                                .requestAuthorization(options: [.alert, .badge, .sound])
                                {
                                        basarili, error in
                                    if basarili
                                    {
                                        print("Ayarlandı")
                                    }
                                    else if let error = error
                                    {
                                        print(error.localizedDescription)
                                    }
                                }
                            
                            let icerik = UNMutableNotificationContent()
                            icerik.title = self.isim
                            icerik.subtitle = "İlaç Zamanı"
                            icerik.sound = UNNotificationSound.default
                            
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                            
                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: icerik, trigger: trigger)
                            
                            UNUserNotificationCenter.current().add(request)
                            
                            self.presentationMode.wrappedValue.dismiss()
                        })
                        {
                           Text("Kaydet")
                            .font(.system(size:24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(temalar[self.tema.temaAyarlar].temaRenk)
                            .cornerRadius(9)
                            .foregroundColor(Color.white)
                        }
                    }//Son -- VStack
                    .padding(.horizontal)
                    .padding(.vertical, 30)
                Spacer()
                
            }//Son -- VStack
            .navigationBarTitle("İlaç Kutusu", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action:
                    {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                )
                    {
                        Image(systemName: "xmark")
                    }//Son -- Ekleme Butonu
            )
            .alert(isPresented: $hataGoster)
            {
                Alert(title: Text(hataBaslik), message: Text(hataMesaj), dismissButton: .default(Text("Tamam")))
            }
        }//Son -- NavigationView
        .accentColor(temalar[self.tema.temaAyarlar].temaRenk)
        .navigationViewStyle(StackNavigationViewStyle())

    }
}


//ÖNİZLEME
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
