
import WidgetKit
import SwiftUI
import Intents

let fakeData = CurrentData(name: "Da Nang",
                       weather: [Weather(main: "Clouds", description: "light rain", icon: "10d")],
                    main: Main(temp: 30))
let fakeEntry = DataEntry(date: Date(), data: fakeData)

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> DataEntry {
        return fakeEntry
    }

    func getSnapshot(in context: Context, completion: @escaping (DataEntry) -> Void) {
        completion(fakeEntry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DataEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!

        DataRequest().locationRequest { data, error in
            guard let data = data, error == nil else { return }
            let entry = DataEntry(date: currentDate, data: data)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
}

struct DataEntry: TimelineEntry {
    let date: Date
    var data: CurrentData
}

struct Main: Codable {
    var temp: Float?
}

struct Weather: Codable {
    var main: String?
    var description: String?
    var icon: String?
}

struct CurrentData: Codable {
    var name: String?
    var weather: [Weather]?
    var main: Main?
}

struct dailyData: Codable {
    var dt: Double?
    var temp: Float?
    var weather: [Weather]?
}

struct APIResponse: Codable {
    var hourly: [dailyData]?
    var daily: [dailyData]?
}

struct DataRequest {
    func locationRequest(completion: @escaping (CurrentData?, Error?) -> Void) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Da Nang&appid=08feb95078d3f88886ddbf99a2bfd310&units=metric".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            let dataObject = try? decoder.decode(CurrentData.self, from: data)
            DispatchQueue.main.async {
                completion(dataObject, nil)
            }
            
        }.resume()
    }
    
//    func dailyRequest(completion: @escaping (dailyData?, Error?) -> Void) {
//        var components = URLComponents(string: Domain.dailyForecast7DaysUrl)
//        components?.queryItems = parameter.map {
//            URLQueryItem(name: $0.key, value: String(describing: $0.value))
//        }
//
//        var request = URLRequest(url: (components?.url)!)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers
//        print(request)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                completion(nil, error)
//                return
//            }
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            if let dataObject = try? decoder.decode(APIResponse.self, from: data) {
//                completion(dataObject.daily, nil)
//            }
//        }.resume()
//    }
}

enum WeatherType: String {
    case Clear, Clouds, Rain, Mist
}

struct Weather_WidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: DataEntry
    
    //var backgroundColorCustom: Color = .white

    init(entry: DataEntry) {
        self.entry = entry
    }
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            VStack {
                Text(entry.data.name ?? "")
                    .font(.system(.body))
                    
                Text("\(String(format: "%0.0f", entry.data.main?.temp ?? 0))°C")
                    .font(.system(size: 30))
                    
                Spacer(minLength: 5)
                if let icon =  entry.data.weather?.first?.icon ,
                   let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png"),
                   let data = try? Data(contentsOf: url) {
                    Image(uiImage: UIImage(data:data) ?? UIImage())
                        .frame(width: 5, height: 5, alignment: .center)
                }
                Spacer(minLength: 5)
                Text(entry.data.weather?.first?.description ?? "")
                    .font(.system(size: 17))
                    
            }
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
            .background(setBackground(weather: (entry.data.weather?.first?.main)!))
        case .systemMedium:
            VStack {
                
            }
        case .systemLarge:
            Text("large")
        @unknown default:
            EmptyView()
        }
    }
    
    func setBackground(weather: String) -> Color {
        if weather == WeatherType.Clear.rawValue {
            return Color("clear")
        } else if weather == WeatherType.Mist.rawValue {
            return Color("mist")
        } else if weather == WeatherType.Rain.rawValue {
            return Color("rain")
        } else if weather == WeatherType.Clouds.rawValue {
            return Color("clouds")
        } else {
            return Color("storm")
        }
    }
}

@main
struct Weather_Widget: Widget {
    let kind: String = "Weather_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Weather_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct Weather_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Weather_WidgetEntryView(entry: fakeEntry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            Weather_WidgetEntryView(entry: fakeEntry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            Weather_WidgetEntryView(entry: fakeEntry)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
