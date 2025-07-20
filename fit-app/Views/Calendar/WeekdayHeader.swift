import SwiftUI

struct WeekdayHeader: View {
    private let symbols = ["L","M","X","J","V","S","D"]   // lun→dom

    var body: some View {
        HStack(spacing: 0) {
            ForEach(symbols, id: \.self) { sym in
                Text(sym)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    WeekdayHeader()
        .background(Color.black)
}