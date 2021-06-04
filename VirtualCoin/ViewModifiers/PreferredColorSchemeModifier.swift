//
//  PreferredColorSchemeModifier.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 01/06/2021.
//

import Foundation
import SwiftUI

/// Color modifier from https://github.com/rizwankce/SwiftUIColorSchemeTest
struct PreferredColorSchemeModifier: ViewModifier {
     var colorScheme: ColorScheme?

     @ViewBuilder
     func body(content: Content) -> some View {
         if let colorScheme = colorScheme {
             content
                 .environment(\.colorScheme, colorScheme)
         } else {
             content
         }
     }
 }

 extension View {
     func applyPreferredColorScheme(_ colorScheme: ColorScheme?) -> some View {
         self.modifier(PreferredColorSchemeModifier(colorScheme: colorScheme))
     }
 }
