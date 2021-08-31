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
#include "display_info.h"
#include "programopts.h"
#include "utils.h"

#include <errno.h>
#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include <math.h>
#include <string>

using std::string;

const int SPECT_WIDTH = 64;

ArduiPi_OLED display; // global, for use during signal handling

void cleanup(void)
{
  // Clear and close display
  display.invertDisplay(false);
  display.clearDisplay();
  display.display();
  display.close();
}

void signal_handler(int sig)
{
  switch (sig) {
  case SIGINT:
  case SIGHUP:
  case SIGTERM:
    cleanup();
    break;
  }
  abort();
}

void init_signals(void)
{
  struct sigaction new_action;
  memset(&new_action, 0, sizeof(new_action));
  new_action.sa_handler = &signal_handler;
  sigemptyset(&new_action.sa_mask);
  new_action.sa_flags = 0;

  struct sigaction old_action;
  sigaction(SIGINT, NULL, &old_action);
  if (old_action.sa_handler != SIG_IGN)
    sigaction(SIGINT, &new_action, NULL);
  sigaction(SIGHUP, NULL, &old_action);
  if (old_action.sa_handler != SIG_IGN)
    sigaction(SIGHUP, &new_action, NULL);
  sigaction(SIGTERM, NULL, &old_action);
  if (old_action.sa_handler != SIG_IGN)
    sigaction(SIGTERM, &new_action, NULL);
}

class OledOpts : public ProgramOpts {
public:
  int oled = OLED_ADAFRUIT_SPI_128x32; // OLED type, as a number
  int framerate = 15;                  // frame rate in Hz
  int bars = 16;                       // number of bars in spectrum
  int gap = 1;                         // gap between bars, in pixels
  string cava_prog_name = "mpd_oled_cava"; // cava executable name
  string cava_method = "fifo";             // fifo, alsa or pulse
  string cava_source;                      // Path to FIFO / alsa device
  double cava_start_delay = 2;   // delay (secs) after play before starting cava
  double invert = 0;             // 0 normal, -1 invert, n>0 invert every n hrs
  bool rotate180 = false;        // display upside down
  unsigned char i2c_addr = 0;    // number of I2C address
  int i2c_bus = 1;               // number of I2C bus
  int reset_gpio = 25;           // reset pin
  int spi_dc_gpio = OLED_SPI_DC; // SPI DC
  int spi_cs = OLED_SPI_CS0;     // SPI CS - 0: CS0, 1: CS1

  OledOpts() : ProgramOpts("mpd_oled", "0.02")
  {
    cava_source = "/tmp/" + get_program_name() + "_fifo";

  }
  void process_command_line(int argc, char **argv);
  void usage();
};

void OledOpts::usage()
{
  fprintf(stdout, R"(
Usage: %s -o oled_type [options] [input_file]

Display information about an MPD-based player on an OLED screen

Options
%s)",
          get_program_name().c_str(), help_ver_text);

  fprintf(
      stdout,
      "  -o <type>  OLED type, specified as a number, from the following:\n");
  for (int i = 0; i < OLED_LAST_OLED; i++)
    if (strstr(oled_type_str[i], "128x64"))
      fprintf(stdout, "      %1d %s\n", i, oled_type_str[i]);

  fprintf(stdout,
          R"(  -b <num>   number of bars to display (default: 16)
  -g <sz>    gap between bars in, pixels (default: 1)
  -f <hz>    framerate in Hz (default: 15)
  -k         cava executable name is cava (default: mpd_oled_cava)
  -c         cava input method and source (default: '%s,%s')
             e.g. 'fifo,/tmp/my_fifo', 'alsa,hw:5,0', 'pulse'
  -R         rotate display 180 degrees
  -I <val>   invert black/white: n - normal (default), i - invert,
             number - switch between n and i with this period (hours), which
             may help avoid screen burn
  -a <addr>  I2C address, in hex (default: default for OLED type)
  -B num     I2C bus number (default: 1, giving device /dev/i2c-1)
  -r <gpio>  I2C/SPI reset GPIO number, if needed (default: 25)
  -D <gpio>  SPI DC GPIO number (default: 24)
  -S <num>   SPI CS number (default: 0)
Example :
%s -o 6 use a %s OLED
)",
          cava_method.c_str(),
          cava_source.c_str(), get_program_name().c_str(), oled_type_str[6]);
}

void OledOpts::process_command_line(int argc, char **argv)
{
  opterr = 0;
  int c;
  int method_len;

  handle_long_opts(argc, argv);

  while ((c = getopt(argc, argv, ":ho:b:g:f:s:C:dP:kc:Z:RI:a:B:r:D:S:p:")) !=
         -1) {
    if (common_opts(c, optopt))
      continue;

    switch (c) {
    case 'o':
      print_status_or_exit(read_int(optarg, &oled), c);
      if (oled < 0 || oled >= OLED_LAST_OLED ||
          !strstr(oled_type_str[oled], "128x64"))
        error(msg_str("invalid 128x64 oled type %d (see -h)", oled), c);
      break;

    case 'b':
      print_status_or_exit(read_int(optarg, &bars), c);
      if (bars < 2 || bars > 60)
        error("select between 2 and 60 bars", c);
      break;

    case 'g':
      print_status_or_exit(read_int(optarg, &gap), c);
      if (gap < 0 || gap > 30)
        error("gap must be between 0 and 30 pixels", c);
      break;

    case 'f':
      print_status_or_exit(read_int(optarg, &framerate), c);
      if (framerate < 1)
        error("framerate must be a positive integer", c);
      break;

    case 'k':
      cava_prog_name = "cava";
      break;

    case 'c':
      method_len = 5; // all the initial method strings are length 5!
      if (strncmp(optarg, "fifo,", method_len) == 0) {
        cava_method = "fifo";
        if (optarg[method_len] == '\0')
          error("cava input method is fifo, but no FIFO path was specified", c);
      }
      else if (strncmp(optarg, "alsa,", method_len) == 0) {
        cava_method = "alsa";
        if (optarg[method_len] == '\0')
          error("cava input method is alsa, but no ALSA stream was specified",
                c);
      }
      else if (strncmp(optarg, "pulse", method_len) == 0) {
        cava_method = "pulse";
        if (optarg[method_len] != '\0')
          error("cava input method is pulse, but is followed by extra text", c);
      }
      else
        error("cava input specifier is not in form 'fifo,fifo_path', "
              "'alsa,alsa_stream', or 'pulse'",
              c);

      cava_source = &optarg[method_len];
      break;

    case 'Z':
      print_status_or_exit(read_double(optarg, &cava_start_delay), c);
      if (cava_start_delay < 0)
        error("cava start delay cannot be negative", c);
      break;

    case 'R':
      rotate180 = true;
      break;

    case 'I':
      if (strcmp(optarg, "n") == 0)
        invert = 0;
      else if (strcmp(optarg, "i") == 0)
        invert = -1;
      else if (read_double(optarg, &invert)) {
        if (invert <= 0)
          error("number of hours for period must be positive number", c);
      }
      else
        error("invalid value, should be n, i or a positive number", c);
      break;

    case 'a':
      if (strlen(optarg) != 2 || strspn(optarg, "01234567890aAbBcCdDeEfF") != 2)
        error("I2C address should be two hexadecimal digits", c);

      i2c_addr = (unsigned char)strtol(optarg, NULL, 16);
      break;

    case 'B':
      print_status_or_exit(read_int(optarg, &i2c_bus), c);
      if (i2c_bus < 0)
        error("bus number cannot be negative", c);
      break;

    case 'r':
      print_status_or_exit(read_int(optarg, &reset_gpio), c);
      if (!isdigit(optarg[0]) || reset_gpio < 0 || reset_gpio > 99)
        error("probably invalid (not integer in range 0 - 99), specify the\n"
              "GPIO number of the pin that RST is connected to",
              c);
      break;

    case 'D':
      print_status_or_exit(read_int(optarg, &spi_dc_gpio), c);
      if (!isdigit(optarg[0]) || reset_gpio < 0 || reset_gpio > 99)
        error("probably invalid (not integer in range 0 - 99), specify the\n"
              "GPIO number of the pin that SPI DC is connected to",
              c);
      break;

    case 'S':
      print_status_or_exit(read_int(optarg, &spi_cs), c);
      if (spi_cs < 0 || spi_cs > 1)
        error("SPI CS should be 0 or 1", c);
      break;

    default:
      error("unknown command line error");
    }
  }

  if (argc - optind > 0)
    error(msg_str("invalid option or parameter: '%s'", argv[optind]));

  if (oled == 0)
    error("must specify a 128x64 oled", 'o');

  const int min_spect_width = bars + (bars - 1) * gap; // assume bar width = 1
  if (min_spect_width > SPECT_WIDTH)
    error(msg_str(
        "spectrum graph width is %d: to display %d bars with a gap of %d\n"
        "requires a minimum width of %d. Reduce the number of bars and/or the "
        "gap\n",
        SPECT_WIDTH, bars, gap, min_spect_width));
}

string print_config_file(int bars, int framerate, string cava_method,
                         string cava_source, string fifo_path_cava_out)
{
  char templt[] = "/tmp/cava_config_XXXXXX";
  int fd = mkstemp(templt);
  if (fd == -1)
    return ""; // failed to open file and convert to file stream
  FILE *ofile = fdopen(fd, "w");
  if (ofile == NULL)
    return ""; // failed to open file and convert to file stream

  fprintf(ofile,
          "[general]\n"
          "framerate = %d\n"
          "bars = %d\n"
          "\n"
          "[input]\n"
          "method = %s\n"
          "source = %s\n"
          "\n"
          "[output]\n"
          "method = raw\n"
          "data_format = binary\n"
          "channels = mono\n"
          "raw_target = %s\n"
          "bit_format = 8bit\n",
          framerate, bars, cava_method.c_str(), cava_source.c_str(),
          fifo_path_cava_out.c_str());
  fclose(ofile);
  return templt;
}

Status start_cava(FILE **p_fifo_file, const OledOpts &opts)
{

  // Create a FIFO for cava to write its raw output to
  const string fifo_path_cava_out = msg_str("/tmp/cava_fifo_%d", getpid());
  unlink(fifo_path_cava_out.c_str());
  if (mkfifo(fifo_path_cava_out.c_str(), 0666) == -1)
    opts.error("could not create cava output FIFO for writing: " +
               string(strerror(errno)));

  // Create a temporary config file for cava
  string config_file_name =
      print_config_file(opts.bars, opts.framerate, opts.cava_method,
                        opts.cava_source, fifo_path_cava_out);
  if (config_file_name == "")
    opts.error("could not create cava config file: " + string(strerror(errno)));

  // Create a pipe to a cava subprocess
  string cava_cmd = opts.cava_prog_name + " -p " + config_file_name;
  if (popen(cava_cmd.c_str(), "r") == NULL)
    opts.error("could not start cava program: " + string(strerror(errno)));

  // Create a file stream to read cava's raw output from
  *p_fifo_file = fopen(fifo_path_cava_out.c_str(), "rb");
  if (*p_fifo_file == NULL)
    opts.error("could not open cava output FIFO for reading");

  return Status::ok();
}

void draw_display(ArduiPi_OLED &display, const display_info &disp_info)
{
  draw_spectrum(display, 0, 0, 128, 64, disp_info.spect);
}

namespace {
pthread_mutex_t disp_info_lock;
}

void *update_info(void *data)
{
  const float delay_secs = 0.3;
  display_info *disp_info_orig = (display_info *)data;
  while (true) {
    pthread_mutex_lock(&disp_info_lock);
    display_info disp_info = *disp_info_orig;
    pthread_mutex_unlock(&disp_info_lock);

    pthread_mutex_lock(&disp_info_lock);
    pthread_mutex_unlock(&disp_info_lock);

    usleep(delay_secs * 1000000);
  }
};

bool get_invert(double period)
{
  return (period > 0) ? (fmod(time(0) / 3600.0, 2 * period) > period) : period;
}

int start_idle_loop(ArduiPi_OLED &display, const OledOpts &opts)
{
  const double update_sec =
      1 / (0.9 * opts.framerate); // default update freq just under framerate
  const long select_usec =
      update_sec * 1100000; // slightly longer, but still less than framerate

  display_info disp_info;
  disp_info.spect.init(opts.bars, opts.gap);

  // Update MPD info in separate thread to avoid stuttering in the spectrum
  // animation.
  pthread_t update_info_thread;
  if (pthread_create(&update_info_thread, NULL, update_info,
                     (void *)(&disp_info))) {
    fprintf(stderr, "error: could not create pthread\n");
    return 1;
  }

  if (pthread_mutex_init(&disp_info_lock, NULL) != 0) {
    fprintf(stderr, "error: could not create pthread mutex\n");
    return 2;
  }

  // Cava not yet started
  int fifo_fd = -1;
  FILE *fifo_file = nullptr;

  while (true) {
    int num_bars_read = 0;
    if (fifo_fd >= 0) {
      fd_set set;
      FD_ZERO(&set);
      FD_SET(fifo_fd, &set);

      // FIFO read timeout value
      struct timeval timeout;
      timeout.tv_sec = 0;
      timeout.tv_usec = select_usec; // slightly longer than timer

      // If there is data read it all.
      if (select(FD_SETSIZE, &set, NULL, NULL, &timeout) > 0) {
        do {
          num_bars_read =
              fread(&disp_info.spect.heights[0], sizeof(unsigned char),
                    disp_info.spect.heights.size(), fifo_file);

          FD_ZERO(&set);
          FD_SET(fifo_fd, &set);
          timeout.tv_sec = 0;
          timeout.tv_usec = 0;
        } while (select(FD_SETSIZE, &set, NULL, NULL, &timeout) > 0);
      }
    }

    // Clear spectrum data if no data read or music not playing
    if (num_bars_read == 0) {
      std::fill(disp_info.spect.heights.begin(), disp_info.spect.heights.end(),
                0);
      usleep(0.1 * 1000000); // 0.1 sec delay, don't idle too fast if no need
    }

    // Update display if necessary
    if (num_bars_read) {
      display.clearDisplay();
      pthread_mutex_lock(&disp_info_lock);
      display.invertDisplay(get_invert(opts.invert));
      draw_display(display, disp_info);
      pthread_mutex_unlock(&disp_info_lock);
      display.display();
    }

    display.reset_offset();
    if (fifo_fd < 0) {
      opts.print_status_or_exit(start_cava(&fifo_file, opts));
      fifo_fd = fileno(fifo_file);
    }
  }

  return 0;
}

int main(int argc, char **argv)
{
  OledOpts opts;
  opts.process_command_line(argc, argv);

  // Set up the OLED display
  if (!init_display(display, opts.oled, opts.i2c_addr, opts.i2c_bus,
                    opts.reset_gpio, opts.spi_dc_gpio, opts.spi_cs,
                    opts.rotate180))
    opts.error("could not initialise OLED");

  init_signals();
  atexit(cleanup);
  int loop_ret = start_idle_loop(display, opts);

  if (loop_ret != 0)
    exit(EXIT_FAILURE);

  return 0;
}
