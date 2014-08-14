
// spark-neopixel-app.cpp
// Author: Mohit Bhoite

#include <application.h>
#include "neopixel/neopixel.h"

int setColor(String commang);

#define PIN D2

// Parameter 1 = number of pixels in strip
// Parameter 2 = pin number (most are valid)
//               note: if not specified, D2 is selected for you.
// Parameter 3 = pixel type [ WS2812, WS2812B, WS2811 ]
//               note: if not specified, WS2812B is selected for you.
//               note: RGB order is automatically applied to WS2811,
//                     WS2812/WS2812B is GRB order.
//
// 800 KHz bitstream 800 KHz bitstream (most NeoPixel products ...
//                         ... WS2812 (6-pin part)/WS2812B (4-pin part) )
//
// 400 KHz bitstream (classic 'v1' (not v2) FLORA pixels, WS2811 drivers)

Adafruit_NeoPixel strip = Adafruit_NeoPixel(24, PIN, WS2812B);


int redValue,greenValue,blueValue;
// IMPORTANT: To reduce NeoPixel burnout risk, add 1000 uF capacitor across
// pixel power leads, add 300 - 500 Ohm resistor on first pixel's data input
// and minimize distance between Arduino and first pixel.  Avoid connecting
// on a live circuit...if you must, connect GND first.

void setup() 
{
    //Register the Spark Function
    Spark.function("color", setColor);
    strip.begin();
    strip.show(); // Initialize all pixels to 'off'
}

void loop() {

}

int setColor(String command)
{
    uint16_t i;
    
    //Parse the incoming command string
    //Example command R:123,G:100,B:50,
    //RGB values should be between 0 to 255
    String red = command.substring(command.indexOf("R:")+2, command.indexOf("G"));
    red.trim();
    redValue = red.toInt();
    
    String green = command.substring(command.indexOf("G:")+2, command.indexOf("B"));
    green.trim();
    greenValue = green.toInt();
    
    String blue = command.substring(command.indexOf("B:")+2, command.indexOf(","));
    blue.trim();
    blueValue = blue.toInt();
    
    //Set the color of the entire neopixel ring
    for(i=0; i<strip.numPixels(); i++) 
    {
        strip.setPixelColor(i, strip.Color(redValue, greenValue, blueValue));
    }
    
    strip.show();
    
    return 1;
}