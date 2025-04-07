import Foundation

struct AssetPosition {
    let symbol: String
    var quantity: Int
    var averagePrice: Double
}

struct PortfolioSnapshot {
    let totalValue: Double
    let profitLoss: Double
    let allocations: [String: Double]
    let timestamp: Date
}

class PortfolioManager {
    private(set) var positions: [String: AssetPosition] = [:]
    private(set) var cashBalance: Double
    private var tradeExecutor: TradeExecutor

    init(initialCapital: Double, executor: TradeExecutor) {
        self.cashBalance = initialCapital
        self.tradeExecutor = executor
    }

    func applyTrade(_ trade: TradeOrder) {
        let cost = Double(trade.quantity) * trade.entryPrice

        switch trade.type {
        case .buy:
            guard cashBalance >= cost else {
                print("Недостаточно средств для покупки.")
                return
            }

            cashBalance -= cost
            if var position = positions[trade.symbol] {
                let totalCost = Double(position.quantity) * position.averagePrice + cost
                let totalQuantity = position.quantity + trade.quantity
                position.quantity = totalQuantity
                position.averagePrice = totalCost / Double(totalQuantity)
                positions[trade.symbol] = position
            } else {
                positions[trade.symbol] = AssetPosition(
                    symbol: trade.symbol,
                    quantity: trade.quantity,
                    averagePrice: trade.entryPrice
                )
            }

        case .sell:
            guard var position = positions[trade.symbol], position.quantity >= trade.quantity else {
                print("Недостаточно акций для продажи.")
                return
            }

            cashBalance += cost
            position.quantity -= trade.quantity

            if position.quantity == 0 {
                positions.removeValue(forKey: trade.symbol)
            } else {
                positions[trade.symbol] = position
            }
        }

        print("Trade applied. New cash balance: \(cashBalance)")
    }

    func calculatePortfolioValue(marketPrices: [String: Double]) -> PortfolioSnapshot {
        var totalValue: Double = cashBalance
        var allocations: [String: Double] = [:]
        var unrealizedPL: Double = 0

        for (symbol, position) in positions {
            if let marketPrice = marketPrices[symbol] {
                let marketValue = Double(position.quantity) * marketPrice
                let investedValue = Double(position.quantity) * position.averagePrice
                unrealizedPL += marketValue - investedValue
                totalValue += marketValue
                allocations[symbol] = marketValue
            }
        }

        let totalWithoutCash = totalValue - cashBalance
        for (symbol, value) in allocations {
            allocations[symbol] = (value / totalWithoutCash) * 100
        }

        return PortfolioSnapshot(
            totalValue: totalValue,
            profitLoss: unrealizedPL,
            allocations: allocations,
            timestamp: Date()
        )
    }

    func summaryReport() {
        print("=== Portfolio Summary ===")
        for (symbol, position) in positions {
            print("• \(symbol): \(position.quantity) @ \(position.averagePrice)")
        }
        print("Cash Balance: \(cashBalance)")
    }
}