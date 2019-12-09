# wasmOpenSSL

wasmOpenSSL is a port of OpenSSL for nodejs and browser applications.

> **Note**: This is a source-code build of OpenSSL using the [Wasienv](https://github.com/wasienv/wasienv) and [Emscripten SDK](https://emscripten.org/docs/getting_started/downloads.html), this makes both prerequisite for a successful porting of the library.

![](images/2019-12-09-18-46-24.png)

## Steps for porting OpenSSL

This script has been tested on Ubuntu `18.04` with OpenSSL version `1.1.1d`

### Setting up the environment

1. Install `wasienv`:

```bash
~/ $ curl https://raw.githubusercontent.com/wasienv/wasienv/master/install.sh | sh
```

2. Install `emscripten`:

```bash
~/ $ git clone https://github.com/emscripten-core/emsdk.git
~/ $ cd emsdk
~/emsdk $ git pull
~/emsdk $ ./emsdk install latest
~/emsdk $ ./emsdk activate latest
~/emsdk $ source ./emsdk_env.sh
```

### Building

1. Compile wasmOpenSSL 

It should be noted that in order for the script to execute successfully, both `wasienv` and `emcc` commands should be available  

```bash
~/ $ cd WasmOpenSSL/ && chmod +x build.sh
~/WasmOpenSSL $ ./build.sh
{...SNIP...}
Done!
```

Results of the compilation are in the `/build` folder.

2. TO BE CONTINUED

## Known issues

* Static declaration follows non-static declaration (syntax error)

    ```bash
    In file included from crypto/ui/ui_openssl.c:111:
    /home/voltron/.local/lib/python3.6/site-packages/wasienv/stubs/termios.h:48:36: error: static   declaration of 'tcgetattr' follows non-static declaration
    ```

    **FIX:**
    - Open `termios.h`
    ```cpp
        int tcgetattr (int, struct termios *); -to-> static int tcgetattr (int, struct termios *);
        int tcsetattr (int, int, const struct termios *); -to-> static int tcsetattr (int, int, const struct termios *);
    ```