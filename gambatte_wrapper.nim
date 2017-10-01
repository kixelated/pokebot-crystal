{.passC: "-Igambatte/libgambatte/include -DHAVE_STDINT_H".}
{.passL: "-Lgambatte/libgambatte -lgambatte -lz".}

type size_t* {.importcpp: "std::size_t".} = uint
type uint_least32_t* {.importcpp: "gambatte::uint_least32_t".} = uint32 # TODO
type std_uint_least32_t* {.importcpp: "std::uint_least32_t".} = uint32 # TODO
type ptrdiff_t* {.importcpp: "std::ptrdiff_t".} = int32

type GB* {.header: "gambatte.h", importcpp: "gambatte::GB".} = object
proc reset*(this: var GB) {.header: "gambatte.h", importcpp: "#.reset()".}
proc load*(this: var GB, romfile: cstring, flags: cint = 0): cint {.header: "gambatte.h", importcpp: "#.load(@)".}
proc runFor*(this: var GB, videoBuf: pointer, pitch: ptrdiff_t, audioBuf: pointer, samples: var size_t): ptrdiff_t {.header: "gambatte.h", importcpp: "#.runFor(@)".}
