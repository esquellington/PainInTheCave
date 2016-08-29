# Pain in the Cave 
## LudumDare36: Ancient Technology (compo entry)

So what tech is more ancient than "rendering" on cave walls? None, I bet!

The tribe is diminishing, only a Hunter, a Gatherer and a Scout
remain. To survive, they must feed the fire with wood to remain warm and
safe, hunt and gather themselves a healthy dose of prehistoric
proteins and carbohidrates and avoid being eaten by wolves, ran down
by bisons and annoyed by birds that steal their crops...

## Controls
- Click on tribemen to select them, and then click on a target resource to
collect it (Hunter->Meat, Gatherer->Cereal, Scout->Wood), on an animal
to attack it (Hunter), or anywhere to move (All).
- Actions cannot be interrupted, so use your 21st century brain to
plan ahead your actions in the -100th

## Notes
- Prefer FullScreen, as art is 1920x1080 with no resizing (sorry:_)
- Web play using love.js (https://github.com/TannerRogalsky/love.js)
- Offline play requires Löve2D (>= 0.10.1), run from the game directory as "love ." 
- Developed in Ubuntu 14.04, but "should" work wherever there's Love.
- Source included in the .zip, no license, do whatever you feel like with it.
- Song "Krakatoa" Joseph Gilbert / Kistol (through http://opengameart.org/)

## Postmortem

This was my first Ludum Dare, and just my second Jam altogether. I
planned to be very realistic with the time limit, avoid overscoping
and feature creeping... and failed miserably, of course, but had a
lot of fun and learned a bit in the process.

The theme was fine, I was initially puzzled and couldn't think of
anything fun to do with it, but then I wondered what was the most
"Ancient" invention that could be called "Technology", and the
cavement setting and cave painting aesthetics followed from there.

### Right

The cave painting aesthetics is the decision I'm most happy with,
because they fit the theme pretty well (Ancient Rendering
Technology?) and were quite easy to draw and animate.

I'm mainly a C++ programmer, but coded the game in LÖVE
(https://love2d.org), a Lua-based set of libraries that does just
the right amount of work for you without forcing any bloated system
or complex workflow down your throat. I'll definitely use it again
in future jams.

As a bonus, LÖVE games can be automatically ported to Javascript
using love.js (https://github.com/TannerRogalsky/love.js), which worked
pretty well despite minor hiccups.

I did everything on Ubuntu using Free Software exclusively, which 
served me perfectly. Inkscape for vector drawing, GIMP for image 
processing, and Emacs for text/code editing.

### Wrong

I totally overscoped... the game ended up having 3 characters, 3
enemies and 3 resources, many with totally unique behaviours, as
well as art. Coding the game mechanics took most of the time.

As a consequence, the gameplay is quite unbalanced... from control
response to movement and enemy/resource generation, the game is
quite punishing. If I were to begin again, I'd remove 1/3 of the
mechanics and invest in gameplay balancing and global polish.

On the technical side, LÖVE is great, but dynamic-typed languages
such as Lua are not my cup of tea, and every time there was an
error that a static-typed language compiler would have caught I got
really mad and cursed aloud in the name of Stroustroup... I'll need
to practice further to follow the way of the type-less programmer.

### Conclusion

It was a lot of fun, and I'm happy with the result, so overall it
was a great experience that I'll try to repeat.
