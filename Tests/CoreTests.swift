import XCTest
@testable import Core

class CoreTests: XCTestCase {

    // MARK: - Тесты для MarketAnalyzer

    func testMarketAnalyzerWithValidData() {
        let marketData: [String: Double] = ["AAPL": 150.0, "GOOG": 2800.0, "TSLA": 700.0]
        let analyzer = MarketAnalyzer()

        let opportunities = analyzer.analyzeMarket(data: marketData)

        // Проверим, что анализ рынка дал хотя бы один результат
        XCTAssertGreaterThan(opportunities.count, 0, "Анализ рынка не дал результатов")
    }

    func testMarketAnalyzerWithEmptyData() {
        let marketData: [String: Double] = [:] // Пустые данные
        let analyzer = MarketAnalyzer()

        let opportunities = analyzer.analyzeMarket(data: marketData)

        // Проверим, что если данных нет, то результат будет пустым
        XCTAssertEqual(opportunities.count, 0, "Анализ рынка не должен был дать результатов с пустыми данными")
    }

    // MARK: - Тесты для TradeExecutor

    func testTradeExecutionWithValidOrder() {
        let order = TradeOrder(symbol: "AAPL", type: .buy, quantity: 10, entryPrice: 150.0)
        let executor = TradeExecutor()

        let result = executor.execute(order)

        // Проверим, что сделка прошла успешно
        XCTAssertTrue(result, "Ошибка при выполнении сделки с корректными данными")
    }

    func testTradeExecutionWithInvalidOrder() {
        let order = TradeOrder(symbol: "XYZ", type: .buy, quantity: -10, entryPrice: -100.0)
        let executor = TradeExecutor()

        let result = executor.execute(order)

        // Проверим, что сделка не пройдет из-за некорректных данных
        XCTAssertFalse(result, "Сделка не должна была быть выполнена с некорректными данными")
    }

    // MARK: - Тесты для PortfolioManager

    func testPortfolioManager() {
        var portfolioManager = PortfolioManager()
        
        portfolioManager.addAsset(symbol: "AAPL", amount: 10, price: 150.0)
        portfolioManager.addAsset(symbol: "GOOG", amount: 5, price: 2800.0)

        let totalValue = portfolioManager.calculateTotalValue(marketPrices: ["AAPL": 160.0, "GOOG": 2900.0])

        // Проверим, что общая стоимость портфеля подсчитана корректно
        XCTAssertEqual(totalValue, 20650.0, "Неверная общая стоимость портфеля")
    }

    func testPortfolioManagerEmptyPortfolio() {
        var portfolioManager = PortfolioManager()
        
        let totalValue = portfolioManager.calculateTotalValue(marketPrices: ["AAPL": 160.0, "GOOG": 2900.0])

        // Проверим, что если портфель пуст, общая стоимость должна быть 0
        XCTAssertEqual(totalValue, 0.0, "Портфель не должен иметь стоимости при отсутствии активов")
    }

    // MARK: - Тесты для RiskController

    func testRiskControllerWithLowRisk() {
        let riskController = RiskController(riskTolerance: 0.1)  // 10% рисков
        let risk = riskController.calculateRisk(forInvestment: 1000.0, volatility: 0.05)
        
        // Проверим, что риск на уровне 10% не превышает допустимый порог
        XCTAssertLessThanOrEqual(risk, 100.0, "Риск не должен превышать 10% от вложенной суммы")
    }

    func testRiskControllerWithHighRisk() {
        let riskController = RiskController(riskTolerance: 0.2)  // 20% рисков
        let risk = riskController.calculateRisk(forInvestment: 1000.0, volatility: 0.25)
        
        // Проверим, что риск на уровне 20% превышает допустимый порог
        XCTAssertGreaterThan(risk, 200.0, "Риск должен превышать 20% от вложенной суммы при высокой волатильности")
    }

    // MARK: - Тесты для SelfDiagnosis

    func testSelfDiagnosis() {
        let selfDiagnosis = SelfDiagnosis()
        let isHealthy = selfDiagnosis.runDiagnostics()

        // Проверим, что система корректно работает и не имеет ошибок
        XCTAssertTrue(isHealthy, "Система должна быть без ошибок")
    }
}