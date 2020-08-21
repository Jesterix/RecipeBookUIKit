import Foundation

protocol CustomMeasureProvider {
    var customMeasures: [CustomMeasure] { get set }
    func updateMeasures(_ measures: [CustomMeasure])
}

struct CustomMeasure {
    var id: String = UUID().uuidString
    var title: String
    var baseUnitSymbol: String
    var coefficient: Double
}
