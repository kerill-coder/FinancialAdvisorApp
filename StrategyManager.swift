import Foundation

enum TradingStrategyType: String {
    case trendFollowing
    case meanReversion
    case crisisDefense
    case aggressiveGrowth
}

struct StrategyDecision {
    let strategyUsed: TradingStrategyType
    let action: String // "Buy", "Sell", "Hold"
    let reason: String
}

class StrategyManager {
    private var activeStrategy: TradingStrategyType = .trendFollowing

    init() {
        // можно подгрузить профиль стратегии с сервера или из памяти
    }

    func selectStrategy(for marketCondition: String) {
        switch marketCondition.lowercased() {
        case "bull", "growth":
            activeStrategy = .trendFollowing
        case "sideways", "flat":
            activeStrategy = .meanReversion
        case "crisis", "volatile":
            activeStrategy = .crisisDefense
        case "recovery", "opportunity":
            activeStrategy = .aggressiveGrowth
        default:
            activeStrategy = .meanReversion
        }
    }

    func makeDecision(from signal: MarketSignal) -> StrategyDecision {
        switch activeStrategy {
        case .trendFollowing:
            return handleTrendFollowing(signal)
        case .meanReversion:
            return handleMeanReversion(signal)
        case .crisisDefense:
            return handleCrisisDefense(signal)
        case .aggressiveGrowth:
            return handleAggressiveGrowth(signal)
        }
    }

    // Пример логики для каждой стратегии
    private func handleTrendFollowing(_ signal: MarketSignal) -> StrategyDecision {
        if signal.recommendation == "Buy" && signal.confidence > 0.7 {
            return StrategyDecision(strategyUsed: .trendFollowing, action: "Buy", reason: "Strong upward trend detected.")
        }
        return StrategyDecision(strategyUsed: .trendFollowing, action: "Hold", reason: "Trend unclear.")
    }

    private func handleMeanReversion(_ signal: MarketSignal) -> StrategyDecision {
        if signal.recommendation == "Sell" && signal.confidence > 0.5 {
            return StrategyDecision(strategyUsed: .meanReversion, action: "Sell", reason: "Price above mean, expecting correction.")
        }
        return StrategyDecision(strategyUsed: .meanReversion, action: "Hold", reason: "Awaiting better signal.")
    }

    private func handleCrisisDefense(_ signal: MarketSignal) -> StrategyDecision {
        return StrategyDecision(strategyUsed: .crisisDefense, action: "Hold", reason: "Risk-averse mode in crisis.")
    }

    private func handleAggressiveGrowth(_ signal: MarketSignal) -> StrategyDecision {
        if signal.recommendation == "Buy" {
            return StrategyDecision(strategyUsed: .aggressiveGrowth, action: "Buy", reason: "Seeking high-growth opportunities.")
        }
        return StrategyDecision(strategyUsed: .aggressiveGrowth, action: "Hold", reason: "No opportunity detected.")
    }
}