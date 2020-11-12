//
//  TemaAyarlar.swift
//  IlacKutusu
//
//  Created by Can Ayışık on 29.08.2020.
//  Copyright © 2020 Can Ayışık. All rights reserved.
//

import SwiftUI

//Tema Class

class TemaAyarlar:ObservableObject
{
    @Published var temaAyarlar: Int=UserDefaults.standard.integer(forKey: "Tema")
    {
        didSet
        {
            UserDefaults.standard.set(self.temaAyarlar, forKey: "Tema")
        }
    }
}
