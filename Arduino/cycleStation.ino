#include <SoftwareSerial.h>
#include <string.h>
#include <LiquidCrystal.h>
#include <ArduinoJson.h>
#include <Servo.h>

SoftwareSerial bluetooth(0, 1);
int maxCycles = 5;
const int ERROR_CYCLES_UNAVAILABLE=100, ERROR_CYCLE_STAND_FULL=101;
int cyclesAvailable = 5;
const int rs = 12, en = 11, d4 = 5, d5 = 4, d6 = 3, d7 = 2;
bool isEngaged = false;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);

class Cycle {
  public:int ledPin;
  public:bool isAvailable;
};

Cycle cycles[5];


void setup() {
  // put your setup code here, to run once:
  bluetooth.begin(9600);
  lcd.begin(16, 2);
  lcd.print("Initializing");
  lcd.setCursor(0,1);
  lcd.print("Station");
  bluetooth.println(maxCycles);
  for(int i=0; i<5; i++) {
    Cycle cycle;
    cycle.isAvailable = true;
    cycle.ledPin = i+6;
    cycles[i] = cycle;
    pinMode(i+6, OUTPUT);
  }

  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);

for(int i=0; i<5; i++) {
  for(int j=0; j<5; j++) {
    digitalWrite(cycles[j].ledPin, HIGH);
  }
  delay(250);
  for(int j=0; j<5; j++) {
    digitalWrite(cycles[j].ledPin, LOW);
  }
  delay(250);
  }

  for(int i=0; i<maxCycles; i++) {
    if(cycles[i].isAvailable)
      digitalWrite(cycles[i].ledPin, HIGH);
    else
      digitalWrite(cycles[i].ledPin, LOW);
  }

  lcd.clear();
  lcd.print("Waiting for");
  lcd.setCursor(0, 1);
  lcd.print("Bluetooth");

}

void loop() {
  String bluetoothData;
  // put your main code here, to run repeatedly:
  if(bluetooth.available()) {
      bluetoothData = bluetooth.readString();
      char arr[bluetoothData.length()+1];
      strcpy(arr, bluetoothData.c_str());
      int command;
      String name;
      int splitIndex;
      for(int i=0; i<bluetoothData.length(); i++) {
        if(arr[i]==':') {
          splitIndex = i;
          break;
        }
      }
      for(int i=0; i<splitIndex; i++) {
        name = name + arr[i];
      }
      command = arr[splitIndex+1] - '0';
      handleBluetoothInput(name, command);
  }
}

void handleBluetoothInput(String name, int input) {
  switch(input) {
    case -3:
      lcd.clear();
      lcd.print("Waiting for");
      lcd.setCursor(0, 1);
      lcd.print("QR"); 
      break;
    case 0:
      initStation();
      break;
    case 1:
        dislodgeCycle(name);
      break;
    case 2:
        lodgeCycle(name);
      break;
  }
}

void initStation() {
  setup();
}

void dislodgeCycle(String name) {
  if(cyclesAvailable==0) {
    bluetooth.println(ERROR_CYCLES_UNAVAILABLE);
    return;
  }
  int i;
  for(i=0; i<maxCycles; i++) {
    if(cycles[i].isAvailable) {
      break;
    }
  }

  cycles[i].isAvailable = false;
  cyclesAvailable--;
  callibrate();
  lcd.clear();
  lcd.print("Hi "+name);
  lcd.setCursor(0, 1);
  lcd.print("Dislodged ");
  lcd.print(i+1);
  for(int j=0; j<5; j++) {
    digitalWrite(cycles[i].ledPin, HIGH);
    delay(250);
    digitalWrite(cycles[i].ledPin, LOW);
    delay(250);
  }
  lcd.clear();
  lcd.print("Waiting for");
  lcd.setCursor(0, 1);
  lcd.print("QR");
  digitalWrite(cycles[i].ledPin, LOW);
}

void lodgeCycle(String name) {
  if(cyclesAvailable>=maxCycles) {
    bluetooth.println(ERROR_CYCLE_STAND_FULL);
    return;
  }
  int i;
  for(i=0; i<maxCycles; i++) {
    if(!cycles[i].isAvailable) {
      break;
    }
  }

  cycles[i].isAvailable = true;
  cyclesAvailable++;
  callibrate();
  lcd.clear();
  lcd.print("Hi "+name);
  lcd.setCursor(0, 1);
  lcd.print("Lodge at ");
  lcd.print(i+1);
  for(int j=0; j<5; j++) {
    digitalWrite(cycles[i].ledPin, HIGH);
    delay(250);
    digitalWrite(cycles[i].ledPin, LOW);
    delay(250);
  }
  lcd.clear();
  lcd.print("Waiting for");
  lcd.setCursor(0, 1);
  lcd.print("QR");
  digitalWrite(cycles[i].ledPin, HIGH);  
}

void callibrate() {
  isEngaged = false;
  bluetooth.println(cyclesAvailable);
}
