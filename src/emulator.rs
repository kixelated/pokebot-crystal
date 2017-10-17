extern crate libc;

use std;

enum Gambatte {}

#[link(name = "gambatte")]
extern "C" {
    fn gambatte_init() -> *mut Gambatte;
    fn gambatte_destroy(gb: *mut Gambatte);

    fn gambatte_load(gb: *mut Gambatte, file: *const libc::c_char) -> libc::c_int;
    fn gambatte_run(
        gb: *mut Gambatte,
        video: *mut u8,
        pitch: libc::ptrdiff_t,
        audio: *mut u8,
        samples: *mut libc::size_t,
    ) -> libc::ptrdiff_t;

    #[allow(dead_code)]
    fn gambatte_get_input(gb: *mut Gambatte) -> libc::c_uint;
    fn gambatte_set_input(gb: *mut Gambatte, input: libc::c_uint);

    fn gambatte_save_state(gb: *mut Gambatte, num: libc::c_int) -> bool;
    fn gambatte_load_state(gb: *mut Gambatte, num: libc::c_int) -> bool;

    fn gambatte_work_ram(gb: *mut Gambatte, data: *mut *const u8, size: *mut libc::size_t);
}

pub struct Emulator {
    gb: *mut Gambatte,
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

pub enum Button {
    None = 0,
    A = 0x01,
    B = 0x02,
    Select = 0x04,
    Start = 0x08,
    Right = 0x10,
    Left = 0x20,
    Up = 0x40,
    Down = 0x80,
}

pub type Input = u32;

impl Emulator {
    pub fn new() -> Emulator {
        let gb = unsafe { gambatte_init() };
        Emulator { gb }
    }

    pub fn load(&mut self, file: &str) -> Result<(), LoadError> {
        let file = std::ffi::CString::new(file).unwrap().into_raw();
        let result = unsafe { gambatte_load(self.gb, file) };
        let _ = unsafe { std::ffi::CString::from_raw(file) };

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

    pub fn advance(&mut self) -> ([u8; 92160], [u8; 148704]) {
        let mut video: [u8; 92160] = [0; 92160];
        let mut audio: [u8; 148704] = [0; 148704];

        loop {
            let mut samples: libc::size_t = 35112;
            let offset = unsafe {
                gambatte_run(
                    self.gb,
                    video.as_mut_ptr(),
                    160,
                    audio.as_mut_ptr(),
                    &mut samples,
                )
            };

            if offset != -1 {
                break;
            }
        }

        (video, audio)
    }

    #[allow(dead_code)]
    pub fn get_input(&mut self) -> Input {
        unsafe { gambatte_get_input(self.gb) }
    }

    pub fn set_input(&mut self, input: Input) {
        unsafe { gambatte_set_input(self.gb, input) }
    }

    pub fn save_state(&mut self, num: i32) -> Result<(), &str> {
        let result = unsafe { gambatte_save_state(self.gb, num) };
        match result {
            true => Ok(()),
            false => Err("failed to save state"),
        }
    }

    pub fn load_state(&mut self, num: i32) -> Result<(), &str> {
        let result = unsafe { gambatte_load_state(self.gb, num) };
        match result {
            true => Ok(()),
            false => Err("failed to load state"),
        }
    }

    pub fn work_ram(&self) -> &[u8] {
        let mut data: *const u8 = std::ptr::null();
        let mut size: libc::size_t = 0;

        unsafe {
            gambatte_work_ram(self.gb, &mut data, &mut size);
            std::slice::from_raw_parts(data as *mut u8, size)
        }
    }
}

impl Drop for Emulator {
    fn drop(&mut self) {
        unsafe {
            gambatte_destroy(self.gb);
        }
    }
}
