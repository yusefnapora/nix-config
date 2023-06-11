# features

This directory contains "features" that can be added to a host configuration's `imports` list to enable certain functionality and configure things as I like them. In other words, my personal config, not something that's necesarily usable by other people.

Enable a feature by adding it to your host config's `imports` list:

```nix
{
  imports = [
    ../features/bluetooth.nix
  ];
}
```

Note that you may need to tweak the import path depending on where you're importing from. TODO: I wonder if there's a way to write import paths relative to the repo root? Seems like something flakes might support.
