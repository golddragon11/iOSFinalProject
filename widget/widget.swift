import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), title: "")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        URLSession.shared.dataTask(with: URL(string: "https://newsapi.org/v2/top-headlines?country=tw&apiKey=eac3e630243249dba444adeda61a0a39")!) { (data, response, error) in
            let currentDate = Date()
            let decoder = JSONDecoder()
            if let data = data, let headlineResults = try? decoder.decode(TopHeadlinesResultWidget.self, from: data) {
                if let data = try? Data(contentsOf: URL(string: headlineResults.articles[0].urlToImage!)!) {
                    let uiImage = UIImage(data: data)
                    let entry = SimpleEntry(date: currentDate, title: headlineResults.articles[0].title, uiImage: uiImage)
                    entries.append(entry)
                }
            }
            let timeline = Timeline(entries: entries, policy: .after(currentDate.addingTimeInterval(3600)))
            completion(timeline)
        }.resume()
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var title: String
    var uiImage: UIImage?
}

struct widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            if entry.uiImage != nil {
                Image(uiImage: entry.uiImage!)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
            }
            Text(entry.title)
        }
    }
}

@main
struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        widgetEntryView(entry: SimpleEntry(date: Date(), title: ""))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct sourceWidget: Codable {
    let name: String
}

struct articleWidget: Codable {
    let source: sourceWidget
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct TopHeadlinesResultWidget: Codable {
    let status: String
    let totalResults: Int
    let articles: [articleWidget]
}
