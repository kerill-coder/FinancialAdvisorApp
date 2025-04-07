import Foundation

enum DiagnosticSeverity: String {
    case info, warning, critical
}

struct DiagnosticLog {
    let timestamp: Date
    let module: String
    let message: String
    let severity: DiagnosticSeverity
}

class SelfDiagnosis {
    private var logs: [DiagnosticLog] = []

    func log(_ module: String, _ message: String, severity: DiagnosticSeverity = .info) {
        let entry = DiagnosticLog(
            timestamp: Date(),
            module: module,
            message: message,
            severity: severity
        )
        logs.append(entry)
        print("[\(entry.severity.rawValue.uppercased())] \(entry.timestamp): [\(module)] - \(message)")

        // Автовосстановление при критической ошибке
        if severity == .critical {
            attemptRecovery(for: module)
        }
    }

    func attemptRecovery(for module: String) {
        // Примитивная имитация восстановления
        print("Attempting recovery for module: \(module)...")
        // Здесь можно вставить перезапуск модуля, очистку кэша и т.д.
        // Например:
        if module == "MarketAnalyzer" {
            // Перезапустить поток анализа
            print("Restarting MarketAnalyzer...")
        }
        log(module, "Recovery attempted", severity: .info)
    }

    func getRecentLogs(limit: Int = 10) -> [DiagnosticLog] {
        return Array(logs.suffix(limit))
    }

    func exportLogs() -> [DiagnosticLog] {
        return logs
    }
}