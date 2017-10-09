package main

// #cgo CFLAGS: -I ${SRCDIR}/gambatte/libgambatte/include -DHAVE_STDINT_H
// #cgo LDFLAGS: -L ${SRCDIR}/gambatte/libgambatte -lgambatte -lz -lstdc++
// #include "gambatte-c.h"
// #include <stdlib.h>
import "C"

import (
	"errors"
	"fmt"
	"os"
	"unsafe"

	"github.com/veandco/go-sdl2/sdl"
)

func main() {
	err := run()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func run() (err error) {
	err = sdl.Init(sdl.INIT_EVERYTHING)
	if err != nil {
		return err
	}

	defer sdl.Quit()

	window, err := sdl.CreateWindow("Nintengo", sdl.WINDOWPOS_UNDEFINED, sdl.WINDOWPOS_UNDEFINED, 320, 288, sdl.WINDOW_SHOWN)
	if err != nil {
		return err
	}

	defer window.Destroy()

	renderer, err := sdl.CreateRenderer(window, -1, sdl.RENDERER_SOFTWARE)
	if err != nil {
		return err
	}

	texture, err := renderer.CreateTexture(sdl.PIXELFORMAT_ARGB8888, sdl.TEXTUREACCESS_STREAMING, 160, 144)
	if err != nil {
		return err
	}

	gb := C.gambatte_init()
	defer C.gambatte_destroy(gb)

	result := C.gambatte_load(gb, C.CString("rom/crystal.gbc"))
	if result != 0 {
		return errors.New("failed to load rom")
	}

	video := [160 * 144 * 4]byte{}
	audio := [(35112 + 2064) * 4]byte{}

	for {
		for event := sdl.PollEvent(); event != nil; event = sdl.PollEvent() {
			switch event.(type) {
			case *sdl.QuitEvent:
				return nil
			}
		}

		offset := C.ptrdiff_t(-1)
		for offset == -1 {
			samples := C.size_t(35112)
			offset = C.gambatte_run(gb, unsafe.Pointer(&video), 160, unsafe.Pointer(&audio), &samples)
		}

		err = texture.Update(nil, video[:], 160*4)
		if err != nil {
			return err
		}

		err = renderer.Copy(texture, nil, nil)
		if err != nil {
			return err
		}

		renderer.Present()
	}
}
