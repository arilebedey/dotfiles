bluez_monitor.properties = {
  ["bluez5.enable-msbc"] = true,
  ["bluez5.enable-hw-volume"] = true,
  ["bluez5.headset-sco-msbc"] = true,
  ["bluez5.sco.buffer-ms"] = 60
}

alsa_monitor.rules = {
  {
    matches = {
      {
        { "node.name", "matches", "*HiFi__Mic*" },
      },
    },
    apply_properties = {
      ["node.latency"] = "2048/48000",
      ["resample.quality"] = 4,
      ["node.pause-on-idle"] = false,
    },
  },
}
