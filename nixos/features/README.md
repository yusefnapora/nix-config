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

Other features have optional arguments, so I can tweak them per-machine or role or whatever. For example, [key-remap.nix](./key-remap.nix) sets up mappings for my keyboard using `interception-tools`. Since not all machines need the same mappings, it takes in a few boolean flags. To import one of these features, use the `import` keyword and pass in required arguments like `pkgs`, `lib`, etc as well as any overrides for default args you want to set. See each feature definition to know which args to pass.

```nix
{
  imports = [
    (import ../features/key-remap.nix {
      inherit lib pkgs; # most features need these. some also need config, inputs, etc.
      caps-to-ctrl-esc = true;
    })
  ];
}
```

Note that the nixos module system seems to get confused by the existence of arguments with default values, so you need to use `import` even if you're not overriding any default args, and pass in the required stuff:

```nix
{
  imports = [
    (import ../features/desktop/sway { 
      inherit inputs outputs config lib pkgs; 
    })
  ];
}
```