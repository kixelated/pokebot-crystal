use emulator;

extern crate sdl2;
use self::sdl2::keyboard::Keycode; // TODO why self::

pub struct Window {
    canvas: sdl2::render::WindowCanvas,
    events: sdl2::EventPump,

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

        let video = [0; 160*144*4];
        let audio = [0; (35112+2064)*4];

        Self{canvas, events, video, audio}
    }

    pub fn run(&mut self, emu: &mut emulator::Emulator) -> bool {
        let texture_creator = self.canvas.texture_creator();
        let mut texture = texture_creator.create_texture_streaming(sdl2::pixels::PixelFormatEnum::ARGB8888, 160, 144).unwrap();

        for event in self.events.poll_iter() {
            if let sdl2::event::Event::Quit {..} = event {
                return true;
            };
        }

        emu.set_input(self.emu_input());
        emu.run(&mut self.video, &mut self.audio);

        texture.update(None, &self.video, 160*4).unwrap();
        self.canvas.copy(&texture, None, None).unwrap();
        self.canvas.present();

        return false;
    }

    fn emu_input(&self) -> emulator::Input {
        let mut input: emulator::Input = 0;

        for key in self.events.keyboard_state().pressed_scancodes() {
            let button = match Keycode::from_scancode(key).unwrap() {
                Keycode::D => emulator::Button::A,
                Keycode::C => emulator::Button::B,
                Keycode::RShift => emulator::Button::Select,
                Keycode::Return => emulator::Button::Start,
                Keycode::Right => emulator::Button::Right,
                Keycode::Left => emulator::Button::Left,
                Keycode::Up => emulator::Button::Up,
                Keycode::Down => emulator::Button::Down,
                _ => continue,
            };

            input = input | button as u32;
        }

        return input;
    }
}
