# Nathan Hay's Dot File Repository
This is my system's configuration files for Nixos and general applications. Application specific files can be found within the `.dotfiles` directory. Rebuilding of the flakes can be done with:
```
sudo nixos-rebuild switch --flake ~/.nixos/default
```

A current TODO list for the Nixos configuration:
- Add lock screen.
- Mute button LED.
- Add Nvidia proprietary driver support.
- Create ISO installation medium.
