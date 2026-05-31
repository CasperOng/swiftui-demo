import SwiftUI
import Charts

struct SalesData: Identifiable {
    let id = UUID()
    let month: String
    let sales: Double
    let profit: Double
}

struct ChartsDemoView: View {
    let salesData: [SalesData] = [
        SalesData(month: "Jan", sales: 1000, profit: 200),
        SalesData(month: "Feb", sales: 1500, profit: 300),
        SalesData(month: "Mar", sales: 1200, profit: 250),
        SalesData(month: "Apr", sales: 1800, profit: 400),
        SalesData(month: "May", sales: 2000, profit: 500),
        SalesData(month: "Jun", sales: 2200, profit: 600)
    ]

    @State private var selectedMonth: String?

    var body: some View {
        List {
            Section("Bar Chart") {
                Chart(salesData) { data in
                    BarMark(
                        x: .value("Month", data.month),
                        y: .value("Sales", data.sales)
                    )
                    .foregroundStyle(.blue.gradient)
                }
                .frame(height: 200)
                .accessibilityLabel("Bar chart showing monthly sales from January to June")
            }

            Section("Line Chart") {
                Chart(salesData) { data in
                    LineMark(
                        x: .value("Month", data.month),
                        y: .value("Sales", data.sales)
                    )
                    .foregroundStyle(.green)
                    .symbol(.circle)
                }
                .frame(height: 200)
                .accessibilityLabel("Line chart showing sales trend from January to June")
            }

            Section("Area Chart") {
                Chart(salesData) { data in
                    AreaMark(
                        x: .value("Month", data.month),
                        y: .value("Sales", data.sales)
                    )
                    .foregroundStyle(.blue.opacity(0.2))

                    LineMark(
                        x: .value("Month", data.month),
                        y: .value("Sales", data.sales)
                    )
                    .foregroundStyle(.blue)
                }
                .frame(height: 200)
                .accessibilityLabel("Area chart showing sales volume from January to June")
            }

            Section("Multiple Series") {
                Chart {
                    ForEach(salesData) { data in
                        BarMark(
                            x: .value("Month", data.month),
                            y: .value("Amount", data.sales)
                        )
                        .foregroundStyle(by: .value("Type", "Sales"))

                        BarMark(
                            x: .value("Month", data.month),
                            y: .value("Amount", data.profit)
                        )
                        .foregroundStyle(by: .value("Type", "Profit"))
                    }
                }
                .chartForegroundStyleScale([
                    "Sales": .blue,
                    "Profit": .green
                ])
                .frame(height: 200)
                .accessibilityLabel("Grouped bar chart comparing sales and profit by month")
            }

            Section("Scatter Plot") {
                Chart(salesData) { data in
                    PointMark(
                        x: .value("Sales", data.sales),
                        y: .value("Profit", data.profit)
                    )
                    .foregroundStyle(.purple)
                    .symbolSize(100)
                    .annotation(position: .top) {
                        Text(data.month)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(height: 200)
                .accessibilityLabel("Scatter plot showing relationship between sales and profit")
            }

            Section("Interactive Chart") {
                Chart(salesData) { data in
                    BarMark(
                        x: .value("Month", data.month),
                        y: .value("Sales", data.sales)
                    )
                    .foregroundStyle(selectedMonth == data.month ? Color.blue : Color.blue.opacity(0.5))
                }
                .chartXSelection(value: $selectedMonth)
                .frame(height: 200)
                .accessibilityLabel("Interactive bar chart. Tap a bar to select it.")

                if let month = selectedMonth,
                   let data = salesData.first(where: { $0.month == month }) {
                    LabeledContent("Selected", value: "\(month): $\(Int(data.sales))")
                        .font(.caption)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Charts Demo")
    }
}

#Preview {
    NavigationStack {
        ChartsDemoView()
    }
}
