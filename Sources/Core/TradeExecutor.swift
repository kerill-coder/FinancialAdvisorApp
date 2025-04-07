import Foundation

enum TradeType {
    case buy, sell
}

struct TradeOrder {
    let symbol: String
    let type: TradeType
    let quantity: Int
    let entryPrice: Double
    let stopLoss: Double?
    let timestamp: Date
}

class TradeExecutor {
    private(set) var tradeHistory: [TradeOrder] = []

    func executeTrade(
        symbol: String,
        decision: StrategyDecision,
        entryPrice: Double,
        capital: Double,
        riskController: RiskController
    ) -> TradeOrder? {
        let estimatedLoss = entryPrice * 0.05 // 5% базовая оценка
        let riskEvaluation = riskController.evaluateRisk(
            entryPrice: entryPrice,
            currentCapital: capital,
            estimatedLoss: estimatedLoss
        )

        guard riskEvaluation.isApproved else {
            print("Trade rejected due to risk: \(riskEvaluation.reason)")
            return nil
        }

        let positionSize = riskController.calculatePositionSize(entryPrice: entryPrice, capital: capital)

        let trade = TradeOrder(
            symbol: symbol,
            type: decision.action == "Buy" ? .buy : .sell,
            quantity: positionSize,
            entryPrice: entryPrice,
            stopLoss: riskEvaluation.suggestedStopLoss,
            timestamp: Date()
        )

        tradeHistory.append(trade)
        print("Trade executed: \(trade)")
        return trade
    }

    func getOpenTrades(for symbol: String) -> [TradeOrder] {
        return tradeHistory.filter { $0.symbol == symbol }
    }
}