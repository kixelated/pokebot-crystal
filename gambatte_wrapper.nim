{.passC: "-Igambatte/libgambatte/src".}
{.passC: "-Igambatte/libgambatte/include".}
{.passC: "-Igambatte/common".}

{.compile: "gambatte/libgambatte/src/bitmap_font.cpp".}
{.compile: "gambatte/libgambatte/src/cpu.cpp".}
{.compile: "gambatte/libgambatte/src/gambatte.cpp".}
{.compile: "gambatte/libgambatte/src/initstate.cpp".}
{.compile: "gambatte/libgambatte/src/interrupter.cpp".}
{.compile: "gambatte/libgambatte/src/interruptrequester.cpp".}
{.compile: "gambatte/libgambatte/src/loadres.cpp".}
{.compile: "gambatte/libgambatte/src/memory.cpp".}
{.compile: "gambatte/libgambatte/src/sound.cpp".}
{.compile: "gambatte/libgambatte/src/state_osd_elements.cpp".}
{.compile: "gambatte/libgambatte/src/statesaver.cpp".}
{.compile: "gambatte/libgambatte/src/tima.cpp".}
{.compile: "gambatte/libgambatte/src/video.cpp".}
{.compile: "gambatte/libgambatte/src/mem/cartridge.cpp".}
{.compile: "gambatte/libgambatte/src/mem/memptrs.cpp".}
{.compile: "gambatte/libgambatte/src/mem/pakinfo.cpp".}
{.compile: "gambatte/libgambatte/src/mem/rtc.cpp".}
{.compile: "gambatte/libgambatte/src/sound/channel1.cpp".}
{.compile: "gambatte/libgambatte/src/sound/channel2.cpp".}
{.compile: "gambatte/libgambatte/src/sound/channel3.cpp".}
{.compile: "gambatte/libgambatte/src/sound/channel4.cpp".}
{.compile: "gambatte/libgambatte/src/sound/duty_unit.cpp".}
{.compile: "gambatte/libgambatte/src/sound/envelope_unit.cpp".}
{.compile: "gambatte/libgambatte/src/sound/length_counter.cpp".}
{.compile: "gambatte/libgambatte/src/video/ly_counter.cpp".}
{.compile: "gambatte/libgambatte/src/video/lyc_irq.cpp".}
{.compile: "gambatte/libgambatte/src/video/next_m0_time.cpp".}
{.compile: "gambatte/libgambatte/src/video/ppu.cpp".}
{.compile: "gambatte/libgambatte/src/video/sprite_mapper.cpp".}
{.compile: "gambatte/libgambatte/src/file/file.cpp".}

type GB* {.header: "gambatte.h", importcpp: "gambatte::GB".} = object
proc reset*(gb: var GB) {.header: "gambatte.h", importcpp: "#.reset()".}
proc load*(gb: var GB, romfile: cstring, flags: cint = 0): cint {.header: "gambatte.h", importcpp: "#.load(@)".}
#proc runFor(gb: var GB, videoBuf: ptr, pitch: cint, audioBuf: ptr, samples cint): cint {.header: "gambatte.h", importcpp: "#.runFor(@)".}

# std::ptrdiff_t runFor(gambatte::uint_least32_t *videoBuf, std::ptrdiff_t pitch,
#                      gambatte::uint_least32_t *audioBuf, std::size_t &samples);
