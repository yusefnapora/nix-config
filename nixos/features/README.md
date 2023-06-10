# features

This directory contains "features" that can be added to a host configuration's `imports` list to enable certain functionality and configure things as I like them. In other words, my personal config, not something that's necesarily usable by other people.

## without arguments

Some features are simple and don't have any arguments. For example, [bluetooth.nix](./bluetooth.nix) just sets a couple `enable` flags:

```nix
{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
```

And you can import it by just adding the path to your `imports` list:

```nix
{
  imports = [
    ../features/bluetooth.nix
  ];
}
```

Note that you may need to tweak the import path depending on where you're importing from. TODO: I wonder if there's a way to write import paths relative to the repo root? Seems like something flakes might support.

## with arguments

Other features have optional arguments, so I can tweak them per-machine or role or whatever. For example, [key-remap.nix](./key-remap.nix) sets up mappings for my keyboard using `interception-tools`. Since not all machines need the same mappings, it takes in a few boolean flags. To import one of these features, use `pkgs.callPackage`, which will slurp up the required arguments like `pkgs`, `lib`, `config`, etc. from the calling scope, and allow you to pass in overrides for the default arguments: 

```nix
{
  imports = [
    (pkgs.callPackage ../features/key-remap.nix {
      caps-to-ctrl-esc = true;
    })
  ];
}
```

Note that the nixos module system seems to get confused by the existence of arguments with default values, so you need to use `callPackage` even if you're not overriding any default args. To use the defaults, pass in an empty attrset `{}`:

```nix
{
  imports = [
    (pkgs.callPackage ../features/desktop/sway { })
  ];
}
```