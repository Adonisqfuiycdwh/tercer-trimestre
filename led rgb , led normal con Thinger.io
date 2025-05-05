#include <WiFi.h>
#include <ThingerESP32.h>

// Configuración de red y Thinger.io
#define WIFI_SSID   "ADONIS"
#define WIFI_PASS   "johanny2020"
#define USERNAME    "Adonis"
#define DEVICE_ID   "Esp32_A"
#define DEVICE_CRED "kOBjk95BhW-sR@ao"

ThingerESP32 thing(USERNAME, DEVICE_ID, DEVICE_CRED);

// Pines para LED monocromático y RGB
const int MONO_LED = 12;
const int RED_PIN  = 27;
const int GREEN_PIN= 26;
const int BLUE_PIN = 25;

// Estados de los LEDs
bool monoOn = false;
uint8_t redVal = 0, greenVal = 0, blueVal = 0;

void setup() {
  Serial.begin(115200);
  thing.add_wifi(WIFI_SSID, WIFI_PASS);

  pinMode(MONO_LED, OUTPUT);
  pinMode(RED_PIN, OUTPUT);
  pinMode(GREEN_PIN, OUTPUT);
  pinMode(BLUE_PIN, OUTPUT);

  // Control LED monocromático
  thing["LED_MONO"] << [](pson& value){
    if(value.is_empty()) {
      value = monoOn;
    } else {
      monoOn = (bool)value;
      digitalWrite(MONO_LED, monoOn ? HIGH : LOW);
      Serial.printf("Mono LED → %s\n", monoOn ? "ON" : "OFF");
    }
  };

  // Control componente rojo del LED RGB
  thing["LED_R"] << [](pson& value){
    if(value.is_empty()) {
      value = redVal;
    } else {
      redVal = value;
      analogWrite(RED_PIN, 255 - redVal);
      Serial.printf("Red = %u\n", redVal);
    }
  };

  // Control componente verde del LED RGB
  thing["LED_G"] << [](pson& value){
    if(value.is_empty()) {
      value = greenVal;
    } else {
      greenVal = value;
      analogWrite(GREEN_PIN, 255 - greenVal);
      Serial.printf("Green = %u\n", greenVal);
    }
  };

  // Control componente azul del LED RGB
  thing["LED_B"] << [](pson& value){
    if(value.is_empty()) {
      value = blueVal;
    } else {
      blueVal = value;
      analogWrite(BLUE_PIN, 255 - blueVal);
      Serial.printf("Blue = %u\n", blueVal);
    }
  };

  // Encendido/apagado total del LED RGB
  thing["LED_ALL"] << [](pson& value){
    if(!value.is_empty()) {
      uint8_t intensity = value ? 255 : 0;
      redVal = greenVal = blueVal = intensity;

      analogWrite(RED_PIN, 255 - redVal);
      analogWrite(GREEN_PIN, 255 - greenVal);
      analogWrite(BLUE_PIN, 255 - blueVal);

      Serial.printf("RGB All → %s\n", value ? "ON" : "OFF");
      value = intensity;
    }
  };
}

void loop() {
  thing.handle();
}
