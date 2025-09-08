
import SwiftUI
struct LWProminentButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.vertical,8).padding(.horizontal,14)
      .background(Color.accentColor.opacity(configuration.isPressed ? 0.7 : 1.0))
      .foregroundColor(.white)
      .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}
