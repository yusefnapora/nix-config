# Add to a configuration module's `imports` list to enable bluetooth
{
  config = {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  }
}