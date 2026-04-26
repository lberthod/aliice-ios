import SwiftUI

struct CategoryMeta: Identifiable {
    let id: String
    let english: String
    let thai: String
    let emoji: String
    let gradient: [Color]
}

let CATEGORY_META: [String: CategoryMeta] = [
    "verbs":      CategoryMeta(id: "verbs",      english: "Verbs",      thai: "กริยา",      emoji: "🏃", gradient: [Color(hex: "ff8a80"), Color(hex: "ff5a36")]),
    "adjectives": CategoryMeta(id: "adjectives", english: "Adjectives",  thai: "คำคุณศัพท์",   emoji: "✨", gradient: [Color(hex: "b39ddb"), Color(hex: "7c4dff")]),
    "animals":    CategoryMeta(id: "animals",    english: "Animals",    thai: "สัตว์",       emoji: "🐘", gradient: [Color(hex: "ffe9a8"), Color(hex: "ffb347")]),
    "colors":     CategoryMeta(id: "colors",     english: "Colors",     thai: "สี",          emoji: "🎨", gradient: [Color(hex: "ffccf0"), Color(hex: "ff6bd5")]),
    "numbers":    CategoryMeta(id: "numbers",    english: "Numbers",    thai: "ตัวเลข",     emoji: "🔢", gradient: [Color(hex: "d9d4ff"), Color(hex: "7b6bff")]),
    "fruits":     CategoryMeta(id: "fruits",     english: "Fruits",     thai: "ผลไม้",      emoji: "🍓", gradient: [Color(hex: "ffcfe0"), Color(hex: "ff7ca8")]),
    "family":     CategoryMeta(id: "family",     english: "Family",     thai: "ครอบครัว",  emoji: "👨‍👩‍👧", gradient: [Color(hex: "ffe0c4"), Color(hex: "ffa07a")]),
    "body":       CategoryMeta(id: "body",       english: "Body",       thai: "ร่างกาย",   emoji: "👁️", gradient: [Color(hex: "ffd4d4"), Color(hex: "ff8f8f")]),
    "food":       CategoryMeta(id: "food",       english: "Food",       thai: "อาหาร",     emoji: "🍕", gradient: [Color(hex: "ffe6b0"), Color(hex: "ffa94d")]),
    "clothes":    CategoryMeta(id: "clothes",    english: "Clothes",    thai: "เสื้อผ้า",   emoji: "👕", gradient: [Color(hex: "e6d7ff"), Color(hex: "a78bfa")]),
    "toys":       CategoryMeta(id: "toys",       english: "Toys",       thai: "ของเล่น",   emoji: "🧸", gradient: [Color(hex: "ffd6b8"), Color(hex: "ff8f5c")]),
    "home":       CategoryMeta(id: "home",       english: "Home",       thai: "บ้าน",       emoji: "🏠", gradient: [Color(hex: "ffe8c8"), Color(hex: "e2a672")]),
    "transport":  CategoryMeta(id: "transport",  english: "Transport",  thai: "ยานพาหนะ",  emoji: "🚗", gradient: [Color(hex: "c9e1ff"), Color(hex: "5a9bff")]),
    "nature":     CategoryMeta(id: "nature",     english: "Nature",     thai: "ธรรมชาติ",  emoji: "🌳", gradient: [Color(hex: "c8f0d5"), Color(hex: "4dc87a")]),
    "vegetables": CategoryMeta(id: "vegetables", english: "Vegetables", thai: "ผัก",         emoji: "🥕", gradient: [Color(hex: "d7f7c9"), Color(hex: "7bd85a")]),
    "feelings":   CategoryMeta(id: "feelings",   english: "Feelings",   thai: "อารมณ์",    emoji: "😀", gradient: [Color(hex: "fff2a8"), Color(hex: "ffd04d")]),
    "music":      CategoryMeta(id: "music",      english: "Music",      thai: "ดนตรี",     emoji: "🎸", gradient: [Color(hex: "e6d0ff"), Color(hex: "b079ff")]),
    "sport":      CategoryMeta(id: "sport",      english: "Sport",      thai: "กีฬา",       emoji: "⚽", gradient: [Color(hex: "c0f0d0"), Color(hex: "2fb870")]),
    "drinks":     CategoryMeta(id: "drinks",     english: "Drinks",     thai: "เครื่องดื่ม",emoji: "🥤", gradient: [Color(hex: "d4eaff"), Color(hex: "6fb3ff")]),
    "weather":    CategoryMeta(id: "weather",    english: "Weather",    thai: "อากาศ",     emoji: "⛅", gradient: [Color(hex: "d4eaff"), Color(hex: "89c9ff")]),
    "school":     CategoryMeta(id: "school",     english: "School",     thai: "โรงเรียน",  emoji: "🏫", gradient: [Color(hex: "ffe0a0"), Color(hex: "ffb04d")]),
    "tech":       CategoryMeta(id: "tech",       english: "Tech",       thai: "เทคโนโลยี", emoji: "💻", gradient: [Color(hex: "c0d0e0"), Color(hex: "5070a0")]),
    "characters": CategoryMeta(id: "characters", english: "Characters", thai: "ตัวละคร",   emoji: "🦸", gradient: [Color(hex: "ffc0d5"), Color(hex: "e05090")]),
    "sea":        CategoryMeta(id: "sea",        english: "Sea Life",   thai: "ทะเล",       emoji: "🐙", gradient: [Color(hex: "a8e6ff"), Color(hex: "4d94ff")]),
    "insects":    CategoryMeta(id: "insects",    english: "Insects",    thai: "แมลง",       emoji: "🦋", gradient: [Color(hex: "f0ffcc"), Color(hex: "9ed85a")]),
    "space":      CategoryMeta(id: "space",      english: "Space",      thai: "อวกาศ",     emoji: "🚀", gradient: [Color(hex: "2c3e50"), Color(hex: "4ca1af")]),
    "tools":      CategoryMeta(id: "tools",      english: "Tools",      thai: "เครื่องมือ", emoji: "🛠️", gradient: [Color(hex: "bdc3c7"), Color(hex: "2c3e50")]),
    "places":     CategoryMeta(id: "places",     english: "Places",     thai: "สถานที่",    emoji: "📍", gradient: [Color(hex: "ffe259"), Color(hex: "ffa751")]),
    "hygiene":    CategoryMeta(id: "hygiene",    english: "Hygiene",    thai: "สุขอนามัย",  emoji: "🧼", gradient: [Color(hex: "ccfbff"), Color(hex: "ef96ff")]),
    "shapes":     CategoryMeta(id: "shapes",     english: "Shapes",     thai: "รูปทรง",    emoji: "📐", gradient: [Color(hex: "ff9a9e"), Color(hex: "fecfef")]),
    "events":     CategoryMeta(id: "events",     english: "Events",     thai: "เทศกาล",    emoji: "🎉", gradient: [Color(hex: "ffecd2"), Color(hex: "fcb69f")]),
    "dinos":      CategoryMeta(id: "dinos",      english: "Dinos",      thai: "ไดโนเสาร์", emoji: "🦖", gradient: [Color(hex: "84fab0"), Color(hex: "8fd3f4")]),
]

// Learning path - order in which categories unlock
let LEARNING_PATH: [String] = [
    "animals", "colors", "numbers",
    "fruits", "family", "body",
    "verbs", "adjectives", "food",
    "clothes", "toys", "home",
    "transport", "nature", "vegetables",
    "feelings", "music", "sport",
    "drinks", "weather", "school",
    "tech", "characters", "sea",
    "insects", "space", "tools",
    "places", "hygiene", "shapes",
    "events", "dinos"
]

let INITIAL_UNLOCKED = 3
let MASTERY_THRESHOLD = 0.6

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
