# Gunfight

A recreation of Modern Warfare's gunfight mode for Venice Unleashed.

## Building

Dependecies:
1. NPM

Create a production build of the webui
```
cd webui
npm install
npm run build
```

Compile the webui in the mod's main directory
```
.\vuicc.exe .\webui\build\ .\ui.vuic
```