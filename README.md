
## Build: 
```bash
  ./build.sh
```

## Push:
```bash
  docker push sbchisholm/devbox:latest
```

## Run:
```bash
  docker run -it -h devbox -v /var/run/docker.sock:/var/run/docker.sock -v $HOME:/var/shared sbchisholm/devbox
```
