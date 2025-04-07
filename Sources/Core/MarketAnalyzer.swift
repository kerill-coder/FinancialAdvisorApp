import Foundation

struct MarketSignal {
    let symbol: String
    let recommendation: String  // "Buy", "Sell", "Hold"
    let confidence: Double
    let analysisDetails: String
}

class MarketAnalyzer {
    // Пример обучающихся паттернов (в будущем можно подключить ML-модель)
    private var knownPatterns: [String: Double] = [:]

    init() {
        loadKnowledge()
    }

    // Получение торгового сигнала на основе анализа
    func analyze(symbol: String, priceHistory: [Double], newsSentiment: Double) -> MarketSignal {
        let trend = detectTrend(priceHistory)
        let score = trend * 0.7 + newsSentiment * 0.3

        let recommendation: String
        if score > 0.6 {
            recommendation = "Buy"
        } else if score < -0.6 {
            recommendation = "Sell"
        } else {
            recommendation = "Hold"
        }

        return MarketSignal(
            symbol: symbol,
            recommendation: recommendation,
            confidence: abs(score),
            analysisDetails: "Trend score: \(trend), News: \(newsSentiment)"
        )
    }

    // Анализ тренда по историческим ценам
    private func detectTrend(_ prices: [Double]) -> Double {
        guard prices.count >= 2 else { return 0.0 }
        let change = prices.last! - prices.first!
        let percentageChange = change / prices.first!
        return percentageChange
    }

    // Загрузка накопленных знаний (эмуляция)
    private func loadKnowledge() {
        knownPatterns = [
            "bullish-reversal": 0.8,
            "bearish-reversal": -0.8
        ]
    }

    // Обучение новому паттерну (будет использоваться KnowledgeBase)
    func learnPattern(name: String, score: Double) {
        knownPatterns[name] = score
    }
}