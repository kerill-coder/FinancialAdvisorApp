import Foundation

class AIAssistant {
    private let marketAnalyzer: MarketAnalyzer
    private let strategyManager: StrategyManager
    private let riskController: RiskController
    private let tradeExecutor: TradeExecutor
    private let portfolioManager: PortfolioManager
    private let learningModule: LearningModule
    private let diagnostics: SelfDiagnosis

    init(initialCapital: Double) {
        diagnostics = SelfDiagnosis()
        tradeExecutor = TradeExecutor()
        portfolioManager = PortfolioManager(initialCapital: initialCapital, executor: tradeExecutor)
        strategyManager = StrategyManager()
        riskController = RiskController(maxDrawdown: 0.1)
        marketAnalyzer = MarketAnalyzer()
        learningModule = LearningModule()

        diagnostics.log("AIAssistant", "Инициализация завершена")
    }

    func run(marketData: [String: Double]) {
        diagnostics.log("AIAssistant", "Запуск анализа рынка")

        let opportunities = marketAnalyzer.analyzeMarket(data: marketData)
        let orders = strategyManager.generateTradeSignals(from: opportunities)

        for order in orders {
            if riskController.shouldAllowTrade(order, portfolioManager: portfolioManager) {
                tradeExecutor.execute(order)
                portfolioManager.applyTrade(order)

                // Предположим, что через какое-то время цена изменилась:
                let exitPrice = simulateExitPrice(for: order, in: marketData)
                learningModule.recordDecision(
                    symbol: order.symbol,
                    decision: order.type.rawValue.capitalized,
                    entryPrice: order.entryPrice,
                    exitPrice: exitPrice
                )
            } else {
                diagnostics.log("AIAssistant", "Сделка не одобрена контроллером риска", severity: .warning)
            }
        }

        learningModule.improveStrategy(strategyManager: strategyManager)
        let snapshot = portfolioManager.calculatePortfolioValue(marketPrices: marketData)
        diagnostics.log("AIAssistant", "Текущая прибыль: \(snapshot.profitLoss)")

        portfolioManager.summaryReport()
    }

    private func simulateExitPrice(for order: TradeOrder, in data: [String: Double]) -> Double {
        // Примитивная модель выхода из позиции
        let volatilityFactor = Double.random(in: -0.03...0.03)
        return order.entryPrice * (1 + volatilityFactor)
    }
}