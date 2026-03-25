# 🌥️ Weather Magic

**Weather Magic**, an elegant, animated weather application developed with Flutter.

## ✨ Features

- **Real-Time Weather:** Live data retrieval (temperature, conditions, humidity, UV index, and wind speed) using the free Open-Meteo API.
- **Interactive Interface:** Animated transitions, floating particle effects, and a premium design using `flutter_animate`.
- **Dynamic Theme:** Smooth and elegant transition between Light Mode and Dark Mode.
- **Live Map & GPS:** Google Maps integration coupled with `geolocator` and `geocoding` to display exact location forecasts with precise neighborhood names.
---

## 🏗️ Project Structure

The project follows a clean architecture and is easy to maintain:
- `lib/core/` : Constants, App Routes, Utilities (Extensions), and Theme logic.
- `lib/data/` : Models (`WeatherData`) and Network Services (`WeatherService`).
- `lib/presentation/` : Reusable UI Screens and Widgets.

---

## 🚀 Getting Started

To run this project locally, you will need two API keys.

### 1. Open-Meteo & Open-Weather API (Weather Data)

Weather Magic uses **Open-Meteo** for real-time weather data.
The great thing about Open-Meteo is that it is completely **free for non-commercial use and does not require an API key**!

*Note: The project previously referenced OpenWeatherMap, but we have migrated to Open-Meteo to simplify the setup process for new users.*

**How to get the key:**
1. Go to the [OpenWeather website](https://openweathermap.org/).
2. Create a free account or log in.
3. Generate a new key and copy it.
4. In the code, open `lib/core/constants/app_constants.dart` and paste your key:
   ```dart
   static const String openWeatherApiKey = 'YOUR_OPEN_WEATHER_API_KEY';
   ```


### 2. Google Maps API Key (Location Map)

The application integrates a Google Maps view to visually illustrate the selected city.

**How to get the key:**
1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a new project (or select an existing one).
3. Go to **APIs & Services** > **Library**.
4. Search for and **Enable** the API:
   - `Maps SDK for Android`
5. Go to **APIs & Services** > **Credentials**.
6. Click on **Create credentials** > **API key**. Copy your new API key.

**Where to configure the Google Maps key:**

**For Android:**
Open `android/app/src/main/AndroidManifest.xml` and update the meta-data tag inside `<application>`:
```xml
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE"/>
```

*Note: The application also requires GPS permissions (`ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`) and uses the Apache HTTP legacy library (`org.apache.http.legacy`) to support older map renderers. These are already pre-configured in the `AndroidManifest.xml`.*

---

## 💻 Running the Application

Once you have configured your API keys:

1. Clone the repository.
2. Run `flutter pub get` to install all dependencies.
3. Run the application on your preferred emulator or a physical device:
   ```bash
   flutter run
   ```

