//
//  HideKeyboard.swift
//  Devote
//
//  Created by Bora Gündoğu on 14.01.2024.
//

import SwiftUI

#if canImport(UIKit) // --> UIKit framework özellikleri kullanmak için kullanılır  Neden ? import yerine sadece bu alanı kullanabilmek için
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


