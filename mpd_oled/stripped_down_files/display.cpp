/*
   Copyright (c) 2018, Adrian Rossiter

   Antiprism - http://www.antiprism.com

   Permission is hereby granted, free of charge, to any person obtaining a
   copy of this software and associated documentation files (the "Software"),
   to deal in the Software without restriction, including without limitation
   the rights to use, copy, modify, merge, publish, distribute, sublicense,
   and/or sell copies of the Software, and to permit persons to whom the
   Software is furnished to do so, subject to the following conditions:

      The above copyright notice and this permission notice shall be included
      in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
  IN THE SOFTWARE.
*/

#include "display.h"

#include <algorithm>
#include <string>

using std::string;

void print(ArduiPi_OLED &display, const char *str)
{
  int sz = strlen(str);
  for (int i = 0; i < sz; i++)
    display.write((uint8_t)str[i]);
}

int draw_spectrum(ArduiPi_OLED &display, int x_start, int y_start, int width,
                  int height, const spect_graph &spect)
{
  const int num_bars = spect.heights.size();
  const int gap = spect.gap;

  int total_bar_pixes = width - (num_bars - 1) * gap;
  int bar_width = total_bar_pixes / num_bars;
  int bar_height_max = height - 1;
  int graph_width = num_bars * bar_width + (num_bars - 1) * gap;

  if (bar_width < 1 || bar_height_max < 1) // bars too small to draw
    return -1;

  // Draw spectrum graph axes
  display.drawFastHLine(x_start, height - 1 - y_start, graph_width, WHITE);
  for (int i = 0; i < num_bars; i++) {
    // map vals range to graph ht
    int val = bar_height_max * spect.heights[i] / 255.0 + 0.5;
    int x = x_start + i * (bar_width + gap);
    // int y = y_start+2;
    if (val)
      display.fillRect(x, y_start + height - val - 2, bar_width, val, WHITE);
  }
  return 0;
}

static void set_rotation(ArduiPi_OLED &display, bool upside_down)
{
  if (upside_down) {
    display.sendCommand(0xA0);
    display.sendCommand(0xC0);
  }
  else {
    display.sendCommand(0xA1);
    display.sendCommand(0xC8);
  }
}

bool init_display(ArduiPi_OLED &display, int oled, unsigned char i2c_addr,
                  int i2c_bus, int reset_gpio, int spi_dc_gpio, int spi_cs,
                  bool rotate180)
{
  if (display.oled_is_spi_proto(oled)) {
    // SPI change parameters to fit to your LCD
    if (!display.init_spi(spi_dc_gpio, reset_gpio, spi_cs, oled))
      return false;
    bcm2835_spi_set_speed_hz(1e6); // ~1MHz
  }
  else {
    // I2C change parameters to fit to your LCD
    if (!display.init_i2c(reset_gpio, oled, i2c_addr, i2c_bus))
      return false;
  }

  display.begin();

  set_rotation(display, rotate180);
  display.setTextWrap(false);

  // init done
  display.clearDisplay(); // clears the screen  buffer
  display.display();      // display it (clear display)

  return true;
}
