#include <Arduino.h>
#include <SPI.h>
#include <RH_RF95.h>

#define RF95_FREQ 915.0

#ifdef MR_IS_RECEIVER
#pragma message("Compiling as RECEIVER")
  #include "receiver.h"
#elif defined(MR_IS_TRANSMITTER)
#pragma message("Compiling as TRANSMITTER")
  #include "transmitter.h"
#else
  #error "Must define MR_IS_RECEIVER or MR_IS_TRANSMITTER"
#endif
