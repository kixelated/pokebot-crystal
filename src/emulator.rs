extern crate libc;

use std::ffi::CString;

enum Gamebatte {}

#[link(name = "gambatte")]
extern {
    fn gambatte_init() -> *mut Gamebatte;
    fn gambatte_destroy(gb: *mut Gamebatte);
    fn gambatte_load(gb: *mut Gamebatte, file: *const libc::c_char) -> libc::c_int;
    fn gambatte_run(gb: *mut Gamebatte, video: *mut u8, pitch: libc::ptrdiff_t, audio: *mut u8, samples: *mut libc::size_t) -> libc::ptrdiff_t;
}

pub struct Emulator {
    gb: *mut Gamebatte
}

#[derive(Debug)]
pub enum LoadError {
    BadFileOrUnknownMbc,
    IOError,
    UnsupportedHUC3,
    UnsupportedTAMA5,
    UnsupportedPocketCamera,
    UnsupportedMBC7,
    UnsupportedMBC6,
    UnsupportedMBC4,
    UnsupportedMMM01,
    Unknown,
}

pub fn new() -> Emulator {
    let gb = unsafe { gambatte_init() };
    Emulator{gb}
}

impl Emulator {
    pub fn load(&self, file: &str) -> Result<(), LoadError> {
        let file = CString::new(file).unwrap().into_raw();
        let result = unsafe { gambatte_load(self.gb, file) };
        let _ = unsafe { CString::from_raw(file) };

        match result {
            0 => Ok(()),
            -0x7FFF => Err(LoadError::BadFileOrUnknownMbc),
            -0x7FFE => Err(LoadError::IOError),
            -0x1FE => Err(LoadError::UnsupportedHUC3),
            -0x1FD => Err(LoadError::UnsupportedTAMA5),
            -0x1FC => Err(LoadError::UnsupportedPocketCamera),
            -0x122 => Err(LoadError::UnsupportedMBC7),
            -0x120 => Err(LoadError::UnsupportedMBC6),
            -0x117 => Err(LoadError::UnsupportedMBC4),
            -0x10D => Err(LoadError::UnsupportedMMM01),
            _ => Err(LoadError::Unknown),
        }
    }

    pub fn run(&self, video: &mut [u8], audio: &mut [u8]) {
        loop {
            let mut samples: libc::size_t = 35112;
            let offset = unsafe { gambatte_run(self.gb, video.as_mut_ptr(), 160, audio.as_mut_ptr(), &mut samples) };
            if offset != -1 {
                break
            }
        }
    }
}

impl Drop for Emulator {
    fn drop(&mut self) {
        unsafe { gambatte_destroy(self.gb); }
    }
}
