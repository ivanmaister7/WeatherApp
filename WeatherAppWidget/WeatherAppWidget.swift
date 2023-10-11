//
//  WeatherAppWidget.swift
//  WeatherAppWidget
//
//  Created by Master on 11.10.2023.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), weather:  WeatherResponce.placeholder, configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), weather: WeatherResponce.placeholder, configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let service = WeatherAppWidgetService()
        service.getCurrentWeather(from: "https://api.weatherapi.com/v1/current.json",
                                  parameters: Parameters(q: WeatherResponce.placeholder.location.name,
                                                         lang: Locale.current.language.languageCode?.identifier ?? "")) { responce in
            guard let data = responce.value else { return }
            var entries: [SimpleEntry] = []
            
            let interval: TimeInterval = 5 //300
            var currentDate = Date()
            let endDate = Calendar.current.date(byAdding: .minute, value: 10, to: currentDate)!
            while currentDate < endDate {
                let entry = SimpleEntry(date: currentDate,
                                        weather: data,
                                        configuration: configuration)
                entries.append(entry)
                currentDate += interval
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let weather: WeatherResponce
    let configuration: ConfigurationIntent
}

struct WeatherAppWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color("skyColor")
            VStack(alignment: .leading) {
                HStack {
                    Text("\(Int(entry.weather.current.temp_c))°C")
                        .font(.largeTitle)
                    weatherImage(for: entry.weather.current.condition)
                }
                Text(entry.weather.location.name)
                Text(entry.weather.current.condition.text)
                    .font(.footnote)
            }
            .padding()
            .foregroundColor(.white)
        }
    }
    
    func weatherImage(for condition: Condition) -> some View {
        var imageName = ""
        switch condition.code {
        case 1000:
            imageName = "sun.max.fill"
        case 1003:
            imageName = "cloud.sun.fill"
        case 1006:
            imageName = "cloud.fill"
        default:
            imageName = "cloud.rain.fill"
        }
        return Image(systemName: imageName).renderingMode(.original).font(.largeTitle)
    }
}

struct WeatherAppWidget: Widget {
    let kind: String = "WeatherAppWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WeatherAppWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WeatherAppWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherAppWidgetEntryView(entry: SimpleEntry(date: Date(), weather:  WeatherResponce.placeholder, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
