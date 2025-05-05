#include <WiFi.h>
#include <ThingerESP32.h>

// Wi-Fi y credenciales de Thinger.io
#define WIFI_SSID   "ADONIS"
#define WIFI_PASS   "johanny2020"
#define USER_NAME   "Adonis"
#define DEVICE_ID   "Esp32_A"
#define DEVICE_CRED "kOBjk95BhW-sR@ao"

ThingerESP32 thing(USER_NAME, DEVICE_ID, DEVICE_CRED);

// Pines del LED monocromático y RGB
const int LED_MONO = 12;
const int LED_R = 27;
const int LED_G = 26;
const int LED_B = 25;

// Variables de estado
bool estadoMono = false;
uint8_t valorR = 0, valorG = 0, valorB = 0;

void setup() {
  Serial.begin(115200);
  thing.add_wifi(WIFI_SSID, WIFI_PASS);

  // Configurar pines como salida
  pinMode(LED_MONO, OUTPUT);
  pinMode(LED_R, OUTPUT);
  pinMode(LED_G, OUTPUT);
  pinMode(LED_B, OUTPUT);

  // Control LED monocromático
  thing["LED_MONO"] << [](pson& data){
    if (data.is_empty()) {
      data = estadoMono;
    } else {
      estadoMono = (bool)data;
      digitalWrite(LED_MONO, estadoMono ? HIGH : LOW);
      Serial.printf("MONO: %s\n", estadoMono ? "ENCENDIDO" : "APAGADO");
    }
  };

  // Control canal rojo
  thing["LED_R"] << [](pson& data){
    if (data.is_empty()) {
      data = valorR;
    } else {
      valorR = data;
      analogWrite(LED_R, 255 - valorR);
      Serial.printf("Rojo = %u\n", valorR);
    }
  };

  // Control canal verde
  thing["LED_G"] << [](pson& data){
    if (data.is_empty()) {
      data = valorG;
    } else {
      valorG = data;
      analogWrite(LED_G, 255 - valorG);
      Serial.printf("Verde = %u\n", valorG);
    }
  };

  // Control canal azul
  thing["LED_B"] << [](pson& data){
    if (data.is_empty()) {
      data = valorB;
    } else {
      valorB = data;
      analogWrite(LED_B, 255 - valorB);
      Serial.printf("Azul = %u\n", valorB);
    }
  };

  // Encendido/apagado total del LED RGB
  thing["LED_ALL"] << [](pson& data){
    if (!data.is_empty()) {
      uint8_t nivel = data ? 255 : 0;
      valorR = valorG = valorB = nivel;

      analogWrite(LED_R, 255 - valorR);
      analogWrite(LED_G, 255 - valorG);
      analogWrite(LED_B, 255 - valorB);

      Serial.printf("TODOS: %s\n", data ? "ON" : "OFF");
      data = nivel;
    }
  };
}

void loop() {
  thing.handle();
}
