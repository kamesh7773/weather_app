import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../services/get_current_weather.dart';
import '../services/kelvin_to_celcius.dart';
import 'hourly_forecast_widget.dart';
import 'additinol_information_widget.dart';
import 'location_search_widget.dart';

class WeatherMainScreen extends StatefulWidget {
  const WeatherMainScreen({super.key});

  @override
  State<WeatherMainScreen> createState() => _WeatherMainScreenState();
}

class _WeatherMainScreenState extends State<WeatherMainScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getCurrentWeatherData(),
      builder: (context, snapshot) {
        // handling loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        // handling Error state
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: const TextStyle(fontSize: 20),
            ),
          );
        }

        final data = snapshot.data!;

        // varible for location info
        final String location = data['city']['name'];

        // varibles for MainBox UI

        final currentWeather = data['list'][0];

        final double temp = kelvinIntoCelsius(currentWeather['main']['temp']);
        final String skyCondition = currentWeather['weather'][0]['main'];

        late LottieBuilder mainBoxWeatherIcon;
        if (skyCondition == "Clear") {
          mainBoxWeatherIcon = Lottie.asset("assets/sunnyIcon.json");
        }
        if (skyCondition == "Rain") {
          mainBoxWeatherIcon = Lottie.asset("assets/rainIcon.json");
        }
        if (skyCondition == "Snow") {
          mainBoxWeatherIcon = Lottie.asset("assets/snowIcon.json");
        }
        if (skyCondition == "Clouds") {
          mainBoxWeatherIcon = Lottie.asset("assets/CloudIcon.json");
        }

        // varibles for additinol information
        final int humiditity = currentWeather['main']["humidity"];
        final int pressure = currentWeather['main']["pressure"];
        final num windSpeed = currentWeather["wind"]["speed"];

        return Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(left: 10, right: 0),
              child: Row(
                children: [
                  Text(
                    location,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Icon(
                    Icons.location_on,
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    getCurrentWeatherData();
                  });
                },
                icon: const Icon(Icons.replay_outlined),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------------------
                // Google place Widget
                // -------------------

                const GooglePlacesWidget(),

                // ----------------------
                // main Weather container
                // ----------------------
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadiusDirectional.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "${temp.toStringAsFixed(0)}°C",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 32),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                height: 80,
                                child: mainBoxWeatherIcon,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                skyCondition.toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // -------------------------
                // Hourly Fourcast container
                // -------------------------
                const Text(
                  "Hourly Fourcast",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(
                  height: 6,
                ),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      index++;
                      // varibles for Hourly Fourcast
                      final hourlyFourcast = data['list'][index];
                      final time =
                          DateTime.parse(hourlyFourcast['dt_txt'].toString());
                      final String skyConditionForecast =
                          hourlyFourcast['weather'][0]['main'];
                      late LottieBuilder fourCastBox;
                      if (skyConditionForecast == "Clear") {
                        fourCastBox = Lottie.asset("assets/sunnyIcon.json");
                      }
                      if (skyConditionForecast == "Rain") {
                        fourCastBox = Lottie.asset("assets/rainIcon.json");
                      }
                      if (skyConditionForecast == "Snow") {
                        fourCastBox = Lottie.asset("assets/snowIcon.json");
                      }
                      if (skyConditionForecast == "Clouds") {
                        fourCastBox = Lottie.asset("assets/CloudIcon.json");
                      }
                      final double temperature =
                          kelvinIntoCelsius(hourlyFourcast['main']['temp']);
                      return HourlyForecastWidget(
                        time: DateFormat.jm().format(time),
                        icon: fourCastBox,
                        temperature: temperature.toStringAsFixed(0),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 28,
                ),
                // -------------------------------
                // additinol information container
                // -------------------------------
                const Text(
                  "Additinol information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AdditinolInformation(
                          icon: Icons.water_drop,
                          lable: "Humiditiy",
                          value: "${humiditity.toString()}%",
                        ),
                        AdditinolInformation(
                          icon: Icons.air,
                          lable: "Wind Speed",
                          value: "${windSpeed.toString()} km",
                        ),
                        AdditinolInformation(
                          icon: Icons.beach_access,
                          lable: "Pressure",
                          value: pressure.toString(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
