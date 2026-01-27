# Tools

https://github.com/junegunn/fzf
https://github.com/sharkdp/fd
https://github.com/BurntSushi/ripgrep
https://github.com/cheat/cheat/
https://github.com/denisidoro/navi


## Linux



### Arch
```sh
sudo pacman -S fzf
sudo pacman -S fd
sudo pacman -S ripgrep
go install github.com/cheat/cheat/cmd/cheat@latest
sudo packman -S navi
```


### Debian
```sh
sudo apt install fzf
sudo apt install fd
sudo apt install ripgrep
go install github.com/cheat/cheat/cmd/cheat@latest
sudo apt isntall navi
```

## MacOS

```sh
brew install fzf
brew install fd
brew install ripgrep
brew install cheat
brew install navi
```


## Windows

```powershell
winget install JanDeDobbeleer.OhMyPosh --source winget

Install-Module posh-git -Scope CurrentUser -Force

Install-Module -Name Terminal-Icons -Repository PSGallery -Force

Install-Module -Name Z -Force

Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck

Install-Module -Name PSFzf -Scope CurrentUser -Force

go install github.com/cheat/cheat/cmd/cheat@latest


```