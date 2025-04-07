import SwiftUI

struct MainView: View {
    @State private var marketData: [String: Double] = [
        "AAPL": 192.41,
        "GOOG": 2891.54,
        "TSLA": 259.71
    ]
    @State private var logs: [String] = []
    @State private var portfolioValue: Double = 100_000

    private let assistant = AIAssistant(initialCapital: 100_000)

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Финансовый AI-Советник")
                    .font(.title2)
                    .bold()

                Text("Текущий портфель: $\(String(format: "%.2f", portfolioValue))")
                    .foregroundColor(.green)
                    .font(.headline)

                Button("Запустить Анализ и Торговлю") {
                    assistant.run(marketData: marketData)
                    portfolioValue = marketData.values.reduce(0, +)
                    logs.append("Анализ завершён в \(Date().formatted())")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)

                Divider()

                List(logs.reversed(), id: \.self) { log in
                    Text(log)
                        .font(.caption)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Главная")
        }
    }
}