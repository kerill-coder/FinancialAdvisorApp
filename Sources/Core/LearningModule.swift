import Foundation

struct LearningRecord: Codable {
    let symbol: String
    let decision: String
    let result: String
    let entryPrice: Double
    let exitPrice: Double
    let profitLoss: Double
    let timestamp: Date
}

class LearningModule {
    private var history: [LearningRecord] = []

    // Добавление новой записи
    func recordDecision(symbol: String, decision: String, entryPrice: Double, exitPrice: Double) {
        let pl = (decision == "Buy" ? exitPrice - entryPrice : entryPrice - exitPrice)
        let result = pl >= 0 ? "Success" : "Failure"

        let record = LearningRecord(
            symbol: symbol,
            decision: decision,
            result: result,
            entryPrice: entryPrice,
            exitPrice: exitPrice,
            profitLoss: pl,
            timestamp: Date()
        )

        history.append(record)
    }

    // Поиск закономерностей на основе истории
    func analyzePerformance() -> (winRate: Double, avgProfit: Double, avgLoss: Double) {
        let successes = history.filter { $0.profitLoss > 0 }
        let failures = history.filter { $0.profitLoss <= 0 }

        let winRate = Double(successes.count) / Double(history.count)
        let avgProfit = successes.map { $0.profitLoss }.average()
        let avgLoss = failures.map { $0.profitLoss }.average()

        return (winRate, avgProfit, avgLoss)
    }

    // Экспорт истории для анализа или обучения ИИ
    func exportHistory() -> [LearningRecord] {
        return history
    }

    // Обновление стратегии (в будущем — обучение модели)
    func improveStrategy(strategyManager: StrategyManager) {
        let stats = analyzePerformance()
        if stats.winRate < 0.5 {
            print("Performance below 50% — reviewing strategy logic.")
            // В будущем: подключение модели ML
        } else {
            print("Performance acceptable. Continuing current strategy.")
        }
    }
}

private extension Array where Element == Double {
    func average() -> Double {
        guard !isEmpty else { return 0.0 }
        return reduce(0, +) / Double(count)
    }
}