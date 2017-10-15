use emulator;

extern crate sdl2;
use self::sdl2::keyboard::Keycode; // TODO why self::
use self::sdl2::keyboard::Scancode; // TODO why self::

pub struct Window {
    canvas: sdl2::render::WindowCanvas,
    events: sdl2::EventPump,
    fpsman: sdl2::gfx::framerate::FPSManager,

    video: [u8; 160*144*4],
    audio: [u8; (35112+2064)*4],
}

impl Window {
    pub fn new() -> Self {
        let sdl_context = sdl2::init().unwrap();
        let video_subsystem = sdl_context.video().unwrap();

        let window = video_subsystem.window("Pokemon Rust", 320, 288).build().unwrap();
        let canvas = window.into_canvas().software().build().unwrap();

        let events = sdl_context.event_pump().unwrap();
        let mut fpsman = sdl2::gfx::framerate::FPSManager::new();
        fpsman.set_framerate(180).unwrap();

        let video = [0; 160*144*4];
        let audio = [0; (35112+2064)*4];

        Self{canvas, events, fpsman, video, audio}
    }

    pub fn run(&mut self, emu: &mut emulator::Emulator) -> bool {
        let texture_creator = self.canvas.texture_creator();
        let mut texture = texture_creator.create_texture_streaming(sdl2::pixels::PixelFormatEnum::ARGB8888, 160, 144).unwrap();

        for event in self.events.poll_iter() {
            if let sdl2::event::Event::Quit {..} = event {
                return true;
            };
        }

        self.handle_events(emu);

        emu.run(&mut self.video, &mut self.audio);

        texture.update(None, &self.video, 160*4).unwrap();
        self.canvas.copy(&texture, None, None).unwrap();
        self.canvas.present();

        self.fpsman.delay();

        return false;
    }

    fn handle_events(&self, emu: &mut emulator::Emulator) {
        let mut input: emulator::Input = 0;

        for scancode in self.events.keyboard_state().pressed_scancodes() {
            let keycode = Keycode::from_scancode(scancode).unwrap();

            let button = match keycode {
                Keycode::D => emulator::Button::A,
                Keycode::C => emulator::Button::B,
                Keycode::RShift => emulator::Button::Select,
                Keycode::Return => emulator::Button::Start,
                Keycode::Right => emulator::Button::Right,
                Keycode::Left => emulator::Button::Left,
                Keycode::Up => emulator::Button::Up,
                Keycode::Down => emulator::Button::Down,
                _ => emulator::Button::None,
            };

            input = input | button as u32;

            let state = match keycode {
                Keycode::F1 => 1,
                Keycode::F2 => 2,
                Keycode::F3 => 3,
                Keycode::F4 => 4,
                Keycode::F5 => 5,
                Keycode::F6 => 6,
                Keycode::F7 => 7,
                Keycode::F8 => 8,
                Keycode::F9 => 9,
                Keycode::F10 => 10,
                Keycode::F11 => 11,
                Keycode::F12 => 12,
                _ => 0,
            };

            if state != 0 {
                if self.events.keyboard_state().is_scancode_pressed(Scancode::LCtrl) {
                    emu.save_state(state).unwrap();
                } else {
                    emu.load_state(state).unwrap();
                }
            }
        }

        emu.set_input(input);
    }
}
