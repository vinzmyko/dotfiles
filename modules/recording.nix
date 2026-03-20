{ config, pkgs, ... }:

let
  toggle-recording = pkgs.writeShellApplication {
    name = "toggle-recording";
    runtimeInputs = with pkgs; [
      procps
      wf-recorder
      pulseaudio
      coreutils
      gnugrep
      gnused
    ];
    text = ''
      RECORDING_DIR="$HOME/videos/recordings"
      STATE_FILE="/tmp/recording-modules"

      if pgrep -x wf-recorder > /dev/null; then
        pkill wf-recorder || true

        if [ -f "$STATE_FILE" ]; then
          while read -r pid; do
            pactl unload-module "$pid" 2>/dev/null || true
          done < "$STATE_FILE"
          rm "$STATE_FILE"
        fi
        exit 0
      fi

      mkdir -p "$RECORDING_DIR"

      # Get the monitor source name for desktop audio
      DEFAULT_SINK=$(wpctl inspect @DEFAULT_AUDIO_SINK@ | grep node.name | head -1 | sed 's/.*"\(.*\)"/\1/')
      MONITOR_SOURCE="''${DEFAULT_SINK}.monitor"

      # Get the mic source name
      DEFAULT_SOURCE=$(wpctl inspect @DEFAULT_AUDIO_SOURCE@ | grep node.name | head -1 | sed 's/.*"\(.*\)"/\1/')

      # Create null sink
      NULL_ID=$(pactl load-module module-null-sink sink_name=Combined)

      # Loopback desktop audio monitor into Combined
      LB_DESKTOP=$(pactl load-module module-loopback sink=Combined source="$MONITOR_SOURCE" latency_msec=200)

      # Loopback mic into Combined
      LB_MIC=$(pactl load-module module-loopback sink=Combined source="$DEFAULT_SOURCE" latency_msec=200)

      printf '%s\n' "$NULL_ID" "$LB_DESKTOP" "$LB_MIC" > "$STATE_FILE"

      sleep 0.5

      wf-recorder --audio=Combined.monitor -f "$RECORDING_DIR/$(date +%Y-%m-%d_%H-%M-%S).mp4"
    '';
  };
in
{
  home.packages = [ toggle-recording ];
}
