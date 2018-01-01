# ruby-mastermind

We use Ruby (2.4.2) in the programming course for applied information science at the university.

One of our mandatory tasks was to programm the Mastermind game.

In general 
- separate game logic and interaction
- for convenience use numbers instead of colors
- be able to configure the rules 
Specifically
 1. Please write code, the master mind on the computer against a human being as a codebreaker over the console. 
    You must do the following:
  1.1 Generate a combination that needs to be guessed.
  1.2 Reading the inputs via the keyboard (console).
  1.3 Analysis of the input and
  1.4 Output of the evaluation.
  1.5 Counting the number of attempts to abort after 10 attempts.

 2. Not all methods are easy to test. But for some, it's simple and easy. at least for some it should be helpful.
    At least it's easy for
  2.1 Check whether the generated number corresponds to the rules.
  2.2 Detection of the correct number of direct or indirect hits.

 3. After the base for mastermind I ask you to develop some "artificial intelligence":
    Please write code, which mastermind as codebreaker against a computer, or plays a human being as codemaker!
    In detail, your further developed Mastermind game should now do just that:
  3.1 It should be possible for the computer (i. e. your code) to play against a human being,i. e. the person (codemaker) thinks up a code that the computer has to guess.
  3.2 When a person is playing as a codebreaker against the computer, he should get a hint, which makes a sensible suggestion for the next attempt.
  3.3 The selection of game variants and playing should be done in a clear and comfortable way according to the limited possibilities of the console.

  (Translated from german to english using www.DeepL.com/Translator)

## Getting Started

### Prerequisites

What things you need to install the software and how to install them

I developed and tested using 

```
Ruby version 2.4.2
```

### Installing

On Windows download and install

```
http://ruby-doc.org/downloads/
```
or

Debian based

```
sudo apt install ruby
```

### Clone Repository

Clone the Git repo

```
git clone https://github.com/GittiMcHub/ruby-mastermind
```

### The rules

A person (the "Codemaker") selects four symbols (colors) from six possible symbols (colors) and repeats are allowed.
The other person (the "Codebreaker") must guess the combination. A tip is given, i. e. four symbols are entered. 
The following information will be provided in response:
1. the number of direct hits ("black hits"), i. e. which symbol in the current attempt is at the same position as in the combination to be guessed.
2. the number of indirect hits ("white hits"), i. e. the number of symbols in the current attempt that occur in the combination to be guessed, but not in the correct place.

If the number is not guessed after 10 attempts, the codebreaker has lost the game.

### Play

Change to game directory

```
cd ruby-mastermind
```

And start using the Start.rb

```
ruby Start.rb
```


Follow the instructions in the console

```
   _____                   __                       .__            .___
  /     \ _____    _______/  |_  ___________  _____ |__| ____    __| _/
 /  \ /  \\__  \  /  ___/\   __\/ __ \_  __ \/     \|  |/    \  / __ |
/    Y    \/ __ \_\___ \  |  | \  ___/|  | \/  Y Y  \  |   |  \/ /_/ |
\____|__  (____  /____  > |__|  \___  >__|  |__|_|  /__|___|  /\____ |
     \/     \/     \/            \/            \/        \/      \/
                                              by Team.new("ALT.F4")

 10 trys to break a 4-digit code with numbers between 1 and 6

  # # # Main Menu # # #
 Code MAKER    vs. BREAKER
-------------------------------------
[ 1 ] Player   vs. Player
[ 2 ] Player   vs. Computer
[ 3 ] Computer vs. Player
------- C O M P E T I T I O N -------
[ 5 ] Player   vs. Player vs. Player
[ 6 ] Player   vs. Player vs. KI
[ 7 ] Computer vs. Player vs. Player
[ 8 ] Computer vs. Player vs. KI

Choose between listed options: _
```

## Running the tests

The tests are located in the test folder.

There should be a Test*.rb for each class

```
cd test
e.g. ruby TestGame.rb
```


## Authors

Team.new("ALT-F4")
* **GittiMcHub** - *Initial work* - [GittiMcHub](https://github.com/GittiMcHub)
* **NilClass** - *Teammate*

## License

See the [LICENSE.md](LICENSE.md) file for details

