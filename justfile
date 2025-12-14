# List all PlatformIO environments
list-envs:
    pio project config | grep ^env: | sed "s,env:,,"

# Show all PlatformIO targets
show:
    pio project config

#--------------------------------------------------------------------#
#                               Build                                #
#--------------------------------------------------------------------#

# Build all environments
build-all:
    pio run

# Build a specific environment
build ENV:
    pio run -e {{ENV}}

build_pico_receiver:
  pio run -e pico_receiver

build_pico_transmitter:
  pio run -e pico_transmitter

build_rpipico2_receiver:
  pio run -e rpipico2_receiver

build_rpipico2_transmitter:
  pio run -e rpipico2_transmitter

build_adafruit_feather_rfm_receiver:
  pio run -e adafruit_feather_rfm_receiver

build_adafruit_feather_rfm_transmitter:
  pio run -e adafruit_feather_rfm_transmitter

#--------------------------------------------------------------------#
#                               Upload                               #
#--------------------------------------------------------------------#

# Upload firmware to a specific environment
upload ENV:
    pio run -e {{ENV}} --target upload

upload_pico_receiver:
  pio run -e pico_receiver

upload_pico_transmitter:
  pio run -e pico_transmitter

upload_rpipico2_receiver:
  pio run -e rpipico2_receiver

upload_rpipico2_transmitter:
  pio run -e rpipico2_transmitter

upload_adafruit_feather_rfm_receiver:
  pio run -e adafruit_feather_rfm_receiver

upload_adafruit_feather_rfm_transmitter:
  pio run -e adafruit_feather_rfm_transmitter

#--------------------------------------------------------------------#
#                                misc                                #
#--------------------------------------------------------------------#

# Fuzzy search boards (requires fzf and jq)
fzf-boards:
    pio boards --json-output | jq -r '.[] | "id:" + .id + ", name:" + .name + ", platform:" + .platform' | fzf
