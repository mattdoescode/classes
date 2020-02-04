/*
   Arduino code for connecting arduino sensors to processing sketch for NMD430 assignment 2
   Matthew Loewen
   Date: 3/13

   Pressure sensor code thanks to
   https://learn.sparkfun.com/tutorials/force-sensitive-resistor-hookup-guide?_ga=2.16799738.277617534.1520918153-1728128114.1520918153


*/


char val;                 // Data received from the serial port
int ledPin = 13;          // Set the pin to digital I/O 13
boolean ledState = LOW;   //to toggle our LED

const int FSR_PIN = A0;
const int trigPin = 9;
const int echoPin = 10;

const float VCC = 4.98;       // Measured voltage of Ardunio 5V line
const float R_DIV = 3230.0;   // Measured resistance of 3.3k resistor

float duration, distance;

void setup() {
  //set up ultra sonic
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  //setup pressure
  pinMode(FSR_PIN, INPUT);

  //serial communication
  pinMode(ledPin, OUTPUT);

  Serial.begin(9600);

  //establishContact();
}

void loop() {

  String message = "";
  float force;
  String forceStr = "";

  if (Serial.available() > 0) {
    val = Serial.read();

    if (val == '1') {
      ledState = !ledState;
      digitalWrite(ledPin, ledState);
    }
    delay(100);

  } else {

    //Ultrasonic getting values
    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);
    duration = pulseIn(echoPin, HIGH);
    distance = (duration * .0343) / 2;

    //convert from float to string for easier value editing
    message = String(distance);

    //normalize data length
    while (message.length() < 6) {
      message = '0' + message;
    }

    force = 0;
    //pressure getting value
    int fsrADC = analogRead(FSR_PIN);
    // If the FSR has no pressure, the resistance will be
    // near infinite. So the voltage should be near 0.
    if (fsrADC != 0) // If the analog reading is non-zero
    {
      // Use ADC reading to calculate voltage:
      float fsrV = fsrADC * VCC / 1023.0;
      // Use voltage and static resistor value to
      // calculate FSR resistance:
      float fsrR = R_DIV * (VCC / fsrV - 1.0);
      //Serial.println("Resistance: " + String(fsrR) + " ohms");

      // Guesstimate force based on slopes in figure 3 of
      // FSR datasheet:
      float fsrG = 1.0 / fsrR; // Calculate conductance
      // Break parabolic curve down into two linear slopes:
      if (fsrR <= 600)
        force = (fsrG - 0.00075) / 0.00000032639;
      else
        force =  fsrG / 0.000000642857;
      //Serial.println("Force: " + String(force) + " g");
    } else {
      //set force to 0 here.
      force = 0;
    }

    forceStr = String(force);
    
    while(forceStr.length() < 7){
       forceStr =  "0" + forceStr;
    }
   
    message += " " + String(forceStr);
    Serial.println(message);
  }
}


void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("A");   // send a capital A
    delay(100);
  }
  Serial.println("contact from Arduino");
}
