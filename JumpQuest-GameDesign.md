# Qabża Sa L-Aħħar - Game Design Document

## High Concept
A themed endless runner platformer with double-jump mechanics, progression systems, and handcrafted levels. Players navigate through 30-50 unique levels across different themes, unlocking abilities and competing for high scores.

## Core Gameplay

### Primary Mechanics
- **Running**: Auto-runner (character moves automatically right)
- **Jump**: Single jump with precise timing
- **Double Jump**: Unlockable ability - press jump again mid-air
- **Lives System**: 5 lives per level attempt
  - Hit obstacle = lose 1 life
  - 0 lives = level restart
  - Perfect run bonus (no deaths)

### Controls
- **Spacebar / Click / Tap**: Jump
- **Spacebar / Click / Tap (mid-air)**: Double Jump (when unlocked)
- Simple, one-button gameplay for accessibility

## Level Design

### Structure
- **30-50 handcrafted levels** organized into themed chapters
- Each level: 60-120 seconds of runtime
- Progressive difficulty curve

### Themes (5-7 chapters, ~7 levels each)
1. **Forest Realm** (Levels 1-7)
   - Green/nature aesthetic
   - Basic obstacles: logs, pits, bushes
   - Sound: Birds, rustling leaves

2. **Desert Wasteland** (Levels 8-14)
   - Sandy/orange palette
   - Obstacles: cacti, quicksand, tumbleweeds
   - Sound: Wind, desert ambience

3. **Ice Mountains** (Levels 15-21)
   - Blue/white aesthetic
   - Slippery physics, icicles
   - Sound: Howling wind, ice cracking

4. **Volcanic Caves** (Levels 22-28)
   - Red/dark aesthetic
   - Lava pits, falling rocks
   - Sound: Rumbling, fire

5. **Sky Kingdom** (Levels 29-35)
   - Clouds, floating platforms
   - Wind currents, moving platforms
   - Sound: Whooshing wind, ethereal music

6. **Neon City** (Levels 36-42)
   - Cyberpunk/futuristic
   - Laser gates, moving walls
   - Sound: Electronic, synthwave

7. **Final Dimension** (Levels 43-50)
   - Abstract/cosmic
   - Mixed mechanics from all themes
   - Sound: Atmospheric, epic

## Challenges & Obstacles

### Obstacle Types
- **Static**: Spikes, walls, barriers (basic jump to avoid)
- **Moving**: Platforms, pendulums, rotating obstacles
- **Environmental**: Falling rocks, rising lava, wind gusts
- **Timing-based**: Disappearing platforms, gates that open/close
- **Speed**: Sections that speed up/slow down the runner

### Challenge Variety
- **Collectibles**: Coins/gems scattered through levels
- **Time Trials**: Beat level under target time
- **Perfect Runs**: Complete without losing lives
- **Hidden Paths**: Secret routes with bonus rewards

## Progression Systems

### 1. Ability Unlocks (Progression Gates)
- **Level 1**: Basic Jump only
- **Level 5**: Double Jump unlocked
- **Level 15**: Wall Slide (optional advanced mechanic)
- **Level 25**: Dash (short speed boost)
- **Level 35**: Glide (hold jump to slow fall)

### 2. Customization Unlocks
Unlock with collected coins/gems:
- **Character Skins**: 10-15 different avatars
- **Particle Effects**: Jump trails, landing effects
- **Music Tracks**: Alternate soundtracks per theme
- **Color Palettes**: Modify level color schemes

### 3. Story Elements
Simple narrative told through:
- **Chapter intro screens**: Brief text/images
- **Environmental storytelling**: Background details
- **End-game reveal**: Why the character is jumping

**Story Hook**:
*"A mysterious force has scattered the legendary Jump Crystals across different realms. As the chosen jumper, quest through these worlds to collect them all and restore balance."*

### 4. Leaderboards
- **Global High Scores**: Per level
- **Speed Run Times**: Fastest completion
- **Total Coins Collected**: Lifetime stats
- **Perfect Runs**: Number of no-death completions

## Monetization Value Proposition

### Why Pay $1?
- **No Ads**: Uninterrupted gameplay
- **50+ Handcrafted Levels**: Hours of content
- **Progression Systems**: Unlocks and customization
- **Leaderboard Competition**: Compare with others
- **Regular Updates**: New levels/themes added

### Free Demo (Optional)
- First 5 levels playable
- Teases mechanics and quality
- Ends with "Purchase to continue" prompt

## Technical Scope

### Must-Have (MVP)
- 30 levels minimum across 5 themes
- Basic jump + double jump
- 5 lives system
- 3 obstacle types per theme
- Coin collection
- Basic progression tracking
- Simple leaderboard
- Background music + SFX per theme

### Nice-to-Have (Post-Launch)
- Additional abilities (wall slide, dash, glide)
- More customization options
- Daily challenges
- Achievement system
- Level editor (user-generated content)

## Art Style

### Visual Direction
- **2D Sprite-based** or **Simple Geometric Shapes**
- **Bright, Colorful**: Each theme has distinct color palette
- **Clean UI**: Minimalist HUD (lives, coins, timer)
- **Smooth Animations**: Satisfying jump/land feedback

### Reference Style Options
1. **Pixel Art**: Retro 16-bit aesthetic (easier for beginners)
2. **Flat Design**: Modern, minimalist shapes
3. **Hand-drawn**: Sketchy, unique style

## Audio Design

### Music
- **Themed Tracks**: Each chapter has unique background music
- **Dynamic**: Music intensity changes based on gameplay
- **Menu Music**: Chill, memorable theme

### Sound Effects
- Jump sound
- Double jump sound (distinct from single jump)
- Landing sound
- Coin collection
- Hit/damage sound
- Death sound
- Level complete fanfare
- Theme-specific ambience

## Success Metrics

### Player Engagement
- Average session time: 15-30 minutes
- Completion rate: 60%+ players finish all levels
- Replay rate: Players return to beat high scores

### Quality Bars
- **Responsive Controls**: <50ms input lag
- **Fair Difficulty**: Challenging but not frustrating
- **Visual Clarity**: Obstacles clearly visible
- **Performance**: Smooth 60 FPS on all devices

## Development Phases

### Phase 1: Core Prototype (Week 1-2)
- Basic runner movement
- Jump + double jump mechanics
- 3 test levels
- Simple collision detection
- Lives system

### Phase 2: Content Creation (Week 3-4)
- Create first 2 themes (14 levels)
- Add coin collection
- Implement progression tracking
- Basic customization system

### Phase 3: Polish & Expand (Week 5-6)
- Add remaining themes
- All audio implementation
- Leaderboard integration
- Menu systems
- Payment gate

### Phase 4: Testing & Launch (Week 7-8)
- Playtesting and difficulty balancing
- Bug fixes
- Payment integration
- Deployment

---

## Next Steps

1. **Validate Design**: Review and adjust this document
2. **Create Asset List**: Sprites, sounds, music needed
3. **Build Prototype**: Implement core mechanics
4. **Test & Iterate**: Ensure it's fun before scaling up
