// Future versions of Hyper may add additional config options,
// which will not automatically be merged into this file.
// See https://hyper.is#cfg for all currently supported options.

module.exports = {
    config: {
        // Choose either "stable" for receiving highly polished,
        // or "canary" for less polished but more frequent updates
        updateChannel: 'stable',

        // default font size in pixels for all tabs
        fontSize: 12,

        // font family with optional fallbacks
        fontFamily: '"Fira Code", "Hack Nerd Font"',

        // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
        cursorColor: '#FFFFFF',

        // `BEAM` for |, `UNDERLINE` for _, `BLOCK` for █
        cursorShape: 'BLOCK',

        // set to true for blinking cursor
        cursorBlink: false,

        // color of the text
        foregroundColor: '#b7c5d3',

        // terminal background color
        backgroundColor: '#2A2D37',

        // border color (window, tabs)
        borderColor: '#333',

        // custom css to embed in the main window
        css: '',

        // custom css to embed in the terminal window
        termCSS: '',

        // set to `true` (without backticks) if you're using a Linux setup that doesn't show native menus
        // default: `false` on Linux, `true` on Windows (ignored on macOS)
        showHamburgerMenu: '',

        // set to `false` if you want to hide the minimize, maximize and close buttons
        // additionally, set to `'left'` if you want them on the left, like in Ubuntu
        // default: `true` on windows and Linux (ignored on macOS)
        showWindowControls: '',

        hyperTabs: {
            trafficButtons: true,
        },

        // https://github.com/lucleray/hyper-opacity
        opacity: {
            focus: 0.9,
            blur: 0.5
        },

        // custom padding (css format, i.e.: `top right bottom left`)
        padding: '12px 12px',

        // the full list. if you're going to provide the full color palette,
        // including the 6 x 6 color cubes and the grayscale map, just provide
        // an array here instead of a color map object
        colors: {
            black: '#7F7F7F',
            red: '#e15a60',
            green: '#a9cfa4',
            yellow: '#ffe2a9',
            blue: '#91c5d3',
            magenta: '#f1a5ab',
            cyan: '#91c5d3',
            white: '#fffff',
            lightBlack: '#7F7F7F',
            lightRed: '#e15a60',
            lightGreen: '#a9cfa4',
            lightYellow: '#ffe2a9',
            lightBlue: '#91c5d3',
            lightMagenta: '#f1a5ab',
            lightCyan: '#91c5d3',
            lightWhite: '#fffff'
        },

        // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
        // if left empty, your system's login shell will be used by default
        //
        // Windows
        // - Make sure to use a full path if the binary name doesn't work
        // - Remove `--login` in shellArgs
        //
        // Bash on Windows
        // - Example: `C:\\Windows\\System32\\bash.exe`
        //
        // Powershell on Windows
        // - Example: `C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe`
        shell: '',

        // for setting shell arguments (i.e. for using interactive shellArgs: ['-i'])
        // by default ['--login'] will be used
        shellArgs: ['--login'],

        // for environment variables
        env: {},

        // set to false for no bell
        bell: 'SOUND',

        // if true, selected text will automatically be copied to the clipboard
        copyOnSelect: false

        // if true, on right click selected text will be copied or pasted if no
        // selection is present (true by default on Windows)
        // quickEdit: true

        // URL to custom bell
        // bellSoundURL: 'http://example.com/bell.mp3',

        // for advanced config flags please refer to https://hyper.is/#cfg
    },

    // a list of plugins to fetch and install from npm
    // format: [@org/]project[#version]
    // examples:
    //   `hyperpower`
    plugins: ['hyper-statusline', 'hyper-tabs-enhanced', 'hyper-opacity'],

    // in development, you can create a directory under
    // `~/.hyper_plugins/local/` and include it here
    // to load it and avoid it being `npm install`ed
    localPlugins: [],

    keymaps: {
        // Example
        // 'window:devtools': 'cmd+alt+o',
    }
};