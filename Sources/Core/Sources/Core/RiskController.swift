import Foundation

struct RiskEvaluation {
    let isApproved: Bool
    let maxLossAllowed: Double
    let suggestedStopLoss: Double?
    let reason: String
}

class RiskController {
    private let maxLossPerTrade: Double = 0.10 // 10% максимальный убыток

    // Основной метод оценки риска
    func evaluateRisk(entryPrice: Double, currentCapital: Double, estimatedLoss: Double) -> RiskEvaluation {
        let maxAllowedLoss = currentCapital * maxLossPerTrade

        if estimatedLoss <= maxAllowedLoss {
            let suggestedStopLoss = entryPrice - (estimatedLoss / currentCapital * entryPrice)
            return RiskEvaluation(
                isApproved: true,
                maxLossAllowed: maxAllowedLoss,
                suggestedStopLoss: suggestedStopLoss,
                reason: "Risk acceptable."
            )
        } else {
            return RiskEvaluation(
                isApproved: false,
                maxLossAllowed: maxAllowedLoss,
                suggestedStopLoss: nil,
                reason: "Risk exceeds limit (max 10% loss)."
            )
        }
    }

    // Дополнительная функция расчета размера позиции
    func calculatePositionSize(entryPrice: Double, capital: Double, riskPercent: Double = 0.01) -> Int {
        let riskAmount = capital * riskPercent
        let positionSize = Int(riskAmount / entryPrice)
        return max(positionSize, 1)
    }
}