import SwiftUI

struct AppColors {
    static let primaryBackground = Color.black
    static let secondaryBackground = Color(red: 0.11, green: 0.11, blue: 0.12) // #1C1C1E
    static let cardBackground = Color(red: 0.17, green: 0.17, blue: 0.18) // #2C2C2E
    
    static let primaryText = Color.white
    static let secondaryText = Color(red: 0.56, green: 0.56, blue: 0.58) // #8E8E93
    
    static let accent = Color.white
    static let border = Color(red: 0.23, green: 0.23, blue: 0.24) // #3A3A3C
}

struct AppFonts {
    static let header = Font.system(size: 32, weight: .bold, design: .default)
    static let subheader = Font.system(size: 22, weight: .semibold, design: .default)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let button = Font.system(size: 17, weight: .semibold, design: .default)
    static let caption = Font.system(size: 13, weight: .regular, design: .default)
}
