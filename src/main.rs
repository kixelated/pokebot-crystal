mod emulator;
extern crate sdl2;

use sdl2::event::Event;
use sdl2::keyboard::Keycode;

fn main() {
    let sdl_context = sdl2::init().unwrap();
    let video_subsystem = sdl_context.video().unwrap();

    let window = video_subsystem.window("Pokemon Rust", 320, 288).build().unwrap();

    let mut canvas = window.into_canvas().software().build().unwrap();
    let texture_creator = canvas.texture_creator();

    let mut texture = texture_creator.create_texture_streaming(sdl2::pixels::PixelFormatEnum::ARGB8888, 160, 144).unwrap();

    let mut emu = emulator::new();
    emu.load("rom/crystal.gbc").unwrap();

    let mut video: [u8; 160*144*4] = [0; 160*144*4];
    let mut audio: [u8; (35112+2064)*4] = [0; (35112+2064)*4];

    let mut events = sdl_context.event_pump().unwrap();

    'running: loop {
        for event in events.poll_iter() {
            if let Event::Quit {..} = event {
                break 'running;
            };
        }

        let mut input: emulator::Input = 0;

        for key in events.keyboard_state().pressed_scancodes() {
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

        emu.set_input(input);

        emu.run(&mut video, &mut audio);

        texture.update(None, &video, 160*4).unwrap();
        canvas.copy(&texture, None, None).unwrap();
        canvas.present();
    }
}
