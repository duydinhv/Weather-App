//
//  Weather_Widget.swift
//  Weather Widget
//
//  Created by Duy Dinh on 11/6/20.
//

import WidgetKit
import SwiftUI
import Intents

let fakeData: [Daily] = [Daily(dt: 1605067200, temp: Temp(eve: 25), weather: [Weather(main: "Clear", description: "", icon: "01d")]),Daily(dt: 1605067200, temp: Temp(eve: 25), weather: [Weather(main: "Clear", description: "", icon: "01d")]),Daily(dt: 1605067200, temp: Temp(eve: 25), weather: [Weather(main: "Clear", description: "", icon: "01d")]),Daily(dt: 1605067200, temp: Temp(eve: 25), weather: [Weather(main: "Clear", description: "", icon: "01d")]),Daily(dt: 1605067200, temp: Temp(eve: 25), weather: [Weather(main: "Clear", description: "", icon: "01d")]),Daily(dt: 1605067200, temp: Temp(eve: 25), weather: [Weather(main: "Clear", description: "", icon: "01d")]),Daily(dt: 1605067200, temp: Temp(eve: 25), weather: [Weather(main: "Clear", description: "", icon: "01d")])]
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

        DataRequest().dailyRequest { data, error in
            guard let data = data, error == nil else { return }
            let entry = DataEntry(date: currentDate, data: data)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
}

struct DataEntry: TimelineEntry {
    let date: Date
    var data: [Daily]
}

struct Temp: Codable {
    var eve: Float?
}

struct Weather: Codable {
    var main: String?
    var description: String?
    var icon: String?
}

struct Daily: Codable {
    var dt: Double?
    var temp: Temp?
    var weather: [Weather]?
}

struct APIResponse: Codable {
    var daily: [Daily]?
}

struct DataRequest {
    func dailyRequest(completion: @escaping ([Daily]?, Error?) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=16.07&exclude=hourly,current,minutely,alerts&appid=08feb95078d3f88886ddbf99a2bfd310&lon=108.22&units=metric"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let dataObject = try? decoder.decode(APIResponse.self, from: data) {
                completion(dataObject.daily, nil)
            }
        }.resume()
    }
}

enum WeatherType: String {
    case Clear, Clouds, Rain, Mist
}

struct Weather_WidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: DataEntry

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            VStack {
                Text("Da Nang")
                    .font(.system(.body))
                Text("\(String(format: "%0.0f", entry.data.first?.temp?.eve ?? 0))°C")
                    .font(.system(size: 30))
                Spacer()
                Image(uiImage: getImage(icon: entry.data.first?.weather?.first?.icon ?? "01d"))
                    .frame(width: 5, height: 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Spacer()
                Text(entry.data.first?.weather?.first?.description ?? "")
                    .font(.system(size: 17))
            }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
            .background(setBackground(weather: (entry.data.first?.weather?.first?.main) ?? "mist"))
        
        case .systemMedium:
            VStack {
                HStack {
                    VStack {
                        Text("Da Nang")
                            .font(.system(size: 20))
                        Text("\(String(format: "%0.0f", entry.data.first?.temp?.eve ?? 0))°C")
                            .font(.system(size: 40))
                    }.padding()
                    Spacer()
                    VStack {
                        Image(uiImage: getImage(icon: entry.data.first?.weather?.first?.icon ?? "01d"))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Spacer()
                        Text(entry.data.first?.weather?.first?.description ?? "clear")
                            .font(.system(size: 15))
                    }
                }
                
                HStack {
                    ForEach(0..<7) { index in
                        VStack {
                            Text(entry.data[index].dt?.toDate() ?? "")
                                .font(.system(size: 13))
                            Spacer()
                            Image(uiImage: getImage(icon: entry.data[index].weather?.first?.icon ?? "01d"))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Spacer()
                            Text("\(String(format: "%0.0f", entry.data[index].temp?.eve ?? 0))°C")
                                .font(.system(size: 13))
                        }
                    }
                }
            }.background(setBackground(weather: (entry.data.first?.weather?.first?.main) ?? "mist"))
            
        case .systemLarge:
            VStack {
                HStack {
                    VStack {
                        Spacer()
                        Text("Da Nang")
                            .font(.system(size: 20))
                        Spacer()
                        Text("\(String(format: "%0.0f", entry.data.first?.temp?.eve ?? 0))°C")
                            .font(.system(size: 30))
                    }.padding()
                    Spacer()
                    VStack {
                        Image(uiImage: getImage(icon: entry.data.first?.weather?.first?.icon ?? "01d"))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Spacer()
                        Text(entry.data.first?.weather?.first?.description ?? "clear")
                            .font(.system(size: 15))
                    }
                }
                VStack {
                    ForEach(1..<3) { index in
                        HStack {
                            Text(entry.data[index].dt?.toLongDate() ?? "")
                                .font(.system(size: 15))
                            Spacer()
                            Image(uiImage: getImage(icon: entry.data[index].weather?.first?.icon ?? "01d"))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Spacer()
                            Text("\(String(format: "%0.0f", entry.data[index].temp?.eve ?? 0))°C")
                                .font(.system(size: 15))
                        }.padding([.leading, .trailing])
                    }
                }
            }.background(setBackground(weather: (entry.data.first?.weather?.first?.main) ?? "mist"))
        @unknown default:
            EmptyView()
        }
    }
    
    func getImage(icon: String) -> UIImage {
        var image = UIImage()
        if let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png"),
           let data = try? Data(contentsOf: url) {
            image = UIImage(data: data) ?? UIImage()
        }
        return image
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
        
    }
}

struct Weather_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            Weather_WidgetEntryView(entry: fakeEntry)
//                .previewContext(WidgetPreviewContext(family: .systemSmall))
            Weather_WidgetEntryView(entry: fakeEntry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
//            Weather_WidgetEntryView(entry: fakeEntry)
//                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

extension Double {
    func toDate() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
    
    func toLongDate() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd/MM/yy"
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
}
