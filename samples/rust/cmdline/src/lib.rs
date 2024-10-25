use std::error::Error;

pub struct Config {
    pub option: String,
}

impl Config {
    pub fn build(args: &[String]) -> Result<Config, &'static str> {
        if args.len() < 2 {
            return Err("not enough arguments");
        }

        let option = args[1].clone();

        Ok(Config { option })
    }
}

pub fn run(config: Config) -> Result<(), Box<dyn Error>> {
    println!("With option: {}", config.option);
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test() {
        assert!(true);
    }
}
